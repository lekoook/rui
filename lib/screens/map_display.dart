import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:rui/data/data_types.dart';
import 'package:rui/data/robot_model.dart';
import 'package:rui/data/robot_status_view_model.dart';
import 'package:rui/screens/buttons.dart';
import 'package:rui/screens/cards.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vector_math/vector_math_64.dart';

@Preview(name: 'Map Display')
Widget mapDisplay() {
  final rm = RobotModel();
  final vm = RobotStatusViewModel(robotModel: rm);
  return MapDisplay(mapData: vm.currentMapNotifier.value);
}

class MapPainter extends CustomPainter {
  MapPainter({required this.mapImage});

  final ui.Image? mapImage;

  @override
  void paint(Canvas canvas, Size size) {
    if (mapImage == null) {
      return;
    }
    canvas.save();
    canvas.drawImage(
      mapImage!,
      Offset.zero,
      Paint()
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class MapDisplay extends StatefulWidget {
  const MapDisplay({required this.mapData, super.key});

  final MapData mapData;

  @override
  State<MapDisplay> createState() => _MapDisplayState();
}

class _MapDisplayState extends State<MapDisplay> {
  final _controller = TransformationController();
  final _popoverController = ShadPopoverController();
  BoxConstraints _mapConstraints = BoxConstraints();

  void _reset() {
    final scaleX = _mapConstraints.maxWidth / widget.mapData.width;
    final scaleY = _mapConstraints.maxHeight / widget.mapData.height;
    final scale = min(scaleX, scaleY);
    final dx = (_mapConstraints.maxWidth - widget.mapData.width * scale) / 2;
    final dy = (_mapConstraints.maxHeight - widget.mapData.height * scale) / 2;
    _controller.value = Matrix4.identity()
      ..translateByVector3(Vector3(dx, dy, 0.0))
      ..scaleByVector3(Vector3(scale, scale, scale));
  }

  void _setScale(double scale) {
    // TODO: Implement.
    // throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    final Positioned mapPositioned = switch (widget.mapData.mapImage) {
      null => Positioned(
        child: CircularProgressIndicator()
      ),
      _ => Positioned.fill(
        child: LayoutBuilder(
          builder: (context, constraints) {
            _mapConstraints = constraints;
            _reset();
            return InteractiveViewer(
              transformationController: _controller,
              minScale: 1,
              maxScale: 10.0,
              scaleFactor: kDefaultMouseScrollToScaleFactor * 4,
              constrained: false,
              boundaryMargin: const EdgeInsets.all(double.infinity),
              child: SizedBox(
                width: widget.mapData.width,
                height: widget.mapData.height,
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: MapPainter(mapImage: widget.mapData.mapImage),
                    ),
                  ],
                ),
              ),
            );
          }
        )
      )
    };
    return Scaffold(
      appBar: AppBar(
        leading: ShadPopover(
          controller: _popoverController,
          popover: (context) {
            return SizedBox(
              width: 400,
              height: 400,
              child: MapInfoCard(mapData: widget.mapData)
            );
          },
          child: ShadTooltip(
            builder: (context) {
              return Text('More map information');
            },
            child: InfoButton.ghost(
              onPressed: _popoverController.toggle,
            ),
          )
        ),
        title: Text(widget.mapData.name),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            mapPositioned,
            Positioned(
              right: 25,
              bottom: 25,
              child: MapControls(
                onResetClicked: _reset,
                onScaleChanged: (scale) {
                  _setScale(scale);
                },
              ),
            )
          ],
        ),
      )
    );
  }
}

class MapControls extends StatefulWidget {
  const MapControls({
    this.onResetClicked,
    this.onScaleChanged,
    super.key
  });

  final void Function()? onResetClicked;
  final void Function(double)? onScaleChanged;

  @override
  State<StatefulWidget> createState() => _MapControlsState();
}

class _MapControlsState extends State<MapControls> {
  double _sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.0,
      children: [
        SizedBox(
          width: 150,
          child: Slider(
            value: _sliderValue,
            onChanged: (newValue) {
              setState(() {
                _sliderValue = newValue;
              });
              widget.onScaleChanged?.call(newValue);
            },
          )
        ),
        ShadTooltip(
          builder: (context) {
            return Text('Reset view');
          },
          child: ShadIconButton.secondary(
            icon: Icon(Icons.refresh),
            onPressed: widget.onResetClicked?.call,
          ),
        ),
      ],
    );
  }
}

class InteractiveMapView extends StatefulWidget {
  final Widget child;

  const InteractiveMapView({super.key, required this.child});

  @override
  State<InteractiveMapView> createState() => _InteractiveMapViewState();
}

class _InteractiveMapViewState extends State<InteractiveMapView> {
  double scale = 1.0;
  Offset pan = Offset.zero;

  // for pinch zoom
  double _startScale = 1.0;
  Offset _startPan = Offset.zero;
  Offset _focalPoint = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: _handlePointerSignal, // trackpad zoom
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onScaleStart: (details) {
          _startScale = scale;
          _startPan = pan;
          _focalPoint = details.focalPoint;
        },
        onScaleUpdate: (details) {
          _handleScaleUpdate(details);
        },
        child: Transform(
          transform: Matrix4.identity()
            ..translateByVector3(Vector3(pan.dx, pan.dy, 0.0))
            ..scaleByVector3(Vector3(scale, scale, scale)),
          child: widget.child,
        ),
      ),
    );
  }

  // Trackpad / mouse wheel zoom
  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      final zoomDelta = -event.scrollDelta.dy * 0.001;
      final newScale = (scale * (1 + zoomDelta)).clamp(0.1, 10.0);

      // Zoom around cursor position
      final localPosition = event.localPosition;
      final scaleChange = newScale / scale;

      setState(() {
        pan = (pan - localPosition) * scaleChange + localPosition;
        scale = newScale;
      });
    }
  }

  // Pinch + drag handling
  void _handleScaleUpdate(ScaleUpdateDetails details) {
    final newScale = (_startScale * details.scale).clamp(0.1, 10.0);

    // keep focal point stable during zoom
    final focalDelta = details.focalPoint - _focalPoint;
    final scaleChange = newScale / scale;

    setState(() {
      pan = (_startPan + focalDelta - _focalPoint) * scaleChange + _focalPoint;
      scale = newScale;
    });
  }
}
