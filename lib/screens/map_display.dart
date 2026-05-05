import '../data/robot_status_model.dart';
import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/widget_previews.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:vector_math/vector_math_64.dart';

@Preview(name: 'Map Display')
Widget mapDisplay() {
  RobotStatusViewModel vm = RobotStatusViewModel();
  return MapDisplay(robotStatusViewModel: vm);
}

class MapPainter extends CustomPainter {
  MapPainter({
    required this.mapImage
  });

  final ui.Image? mapImage;

  @override
  void paint(Canvas canvas, Size size) {
    if (mapImage == null) {
      return;
    }
    canvas.save();
    canvas.drawImage(
      mapImage!,
      Offset((size.width - mapImage!.width) / 2.0, (size.height - mapImage!.height) / 2.0),
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
  const MapDisplay({required this.robotStatusViewModel, super.key});

  final RobotStatusViewModel robotStatusViewModel;

  @override
  State<MapDisplay> createState() => _MapDisplayState();
}

class _MapDisplayState extends State<MapDisplay> {
  RobotStatusViewModel get robotStatusViewModel => widget.robotStatusViewModel;

  final _controller = TransformationController();

  void _reset() {
    _controller.value = Matrix4.identity();
  }

  void _setScale(double scale) {
    // TODO: Implement.
    // throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.robotStatusViewModel.currentMapNotifier,
      builder: (context, map, child) {
        return Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                transformationController: _controller,
                minScale: 0.1,
                maxScale: 10.0,
                scaleFactor: kDefaultMouseScrollToScaleFactor * 4,
                child: CustomPaint(
                  painter: MapPainter(mapImage: widget.robotStatusViewModel.currentMapImage),
                ),
              )
            ),
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
        ) ;
      }
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
  SliderValue _sliderValue = SliderValue.single(0.5);

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
              widget.onScaleChanged?.call(newValue.value);
            },
          )
        ),
        IconButton.secondary(
          icon: Icon(Icons.home),
          onPressed: widget.onResetClicked?.call,
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
