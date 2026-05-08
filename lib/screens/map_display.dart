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
import 'package:rui/screens/map_marker_controller.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vector_math/vector_math_64.dart' as math;

@Preview(name: 'Map Display')
Widget mapDisplay() {
  final rm = RobotModel();
  final vm = RobotStatusViewModel(robotModel: rm);
  return MapDisplay(
    mapData: vm.currentMapNotifier.value,
    mapMarkers: [
      RobotMarker(
        poseNotifier: ValueNotifier(Pose()),
        mapData: MapData()
      )
    ]
  );
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
  const MapDisplay({
    super.key,
    required this.mapData,
    required this.mapMarkers
  });

  final MapData mapData;
  final List<MapMarker> mapMarkers;

  @override
  State<MapDisplay> createState() => _MapDisplayState();
}

class _MapDisplayState extends State<MapDisplay> {
  final _controller = TransformationController();
  final _popoverController = ShadPopoverController();
  BoxConstraints _mapConstraints = BoxConstraints();
  static const double _minScale = 1.0;
  static const double _maxScale = 10.0;

  void _reset() {
    final scaleX = _mapConstraints.maxWidth / widget.mapData.width;
    final scaleY = _mapConstraints.maxHeight / widget.mapData.height;
    final scale = min(scaleX, scaleY);
    final dx = (_mapConstraints.maxWidth - widget.mapData.width * scale) / 2;
    final dy = (_mapConstraints.maxHeight - widget.mapData.height * scale) / 2;
    _controller.value = Matrix4.identity()
      ..translateByVector3(math.Vector3(dx, dy, 0.0))
      ..scaleByVector3(math.Vector3(scale, scale, scale));
  }

  void _setScale(double scale, double min, double max) {
    // Normalize the given scale to the display's range.
    final norm = (scale - min) / (max - min);
    final scaleToUse = norm * (_maxScale - _minScale) + _minScale;
    final dx = (_mapConstraints.maxWidth - widget.mapData.width * scaleToUse) / 2;
    final dy = (_mapConstraints.maxHeight - widget.mapData.height * scaleToUse) / 2;
    _controller.value = Matrix4.identity()
      ..translateByVector3(math.Vector3(dx, dy, 0))
      ..scaleByVector3(math.Vector3(scaleToUse, scaleToUse, scaleToUse));
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
              minScale: _minScale,
              maxScale: _maxScale,
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
                    ...widget.mapMarkers
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
                onScaleChanged: (scale, min, max) {
                  _setScale(scale, min, max);
                },
                onHiddenChanged: (hidden) {
                  for (var marker in widget.mapMarkers) {
                    marker.setHidden(hidden);
                  }
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
    this.onHiddenChanged,
    super.key
  });

  final void Function()? onResetClicked;
  final void Function(double, double, double)? onScaleChanged;
  final void Function(bool)? onHiddenChanged;

  @override
  State<StatefulWidget> createState() => _MapControlsState();
}

class _MapControlsState extends State<MapControls> {
  static const double _min = 0.0;
  static const double _max = 1.0;
  double _sliderValue = 0.5;
  final _markersHidden = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.0,
      children: [
        SizedBox(
          width: 150,
          child: Slider(
            min: _min,
            max: _max,
            value: _sliderValue,
            onChanged: (newValue) {
              setState(() {
                _sliderValue = newValue;
              });
              widget.onScaleChanged?.call(newValue, _min, _max);
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
        ValueListenableBuilder(
          valueListenable: _markersHidden,
          builder: (context, hidden, child) {
            return ShadTooltip(
              child: ShadIconButton.secondary(
                icon: Icon(_markersHidden.value ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  _markersHidden.value = !_markersHidden.value;
                  widget.onHiddenChanged?.call(_markersHidden.value);
                },
              ),
              builder: (context) {
                return _markersHidden.value ? Text('Set markers visible') : Text('Set markers hidden');
              }
            );
          }
        )
      ],
    );
  }
}

class MapMarker extends StatefulWidget {
  const MapMarker({
    super.key,
    required this.controller,
    required this.mapData,
    required this.child,
    this.width = 20.0,
    this.height = 20.0
  });

  final MapMarkerController controller;
  final MapData mapData;
  final Widget child;
  final double width;
  final double height;

  @override
  State<StatefulWidget> createState() => _MapMarkerState();

  void setHidden(bool hidden) {
    controller.hiddenNotifier.value = hidden;
  }
}

class _MapMarkerState extends State<MapMarker> {
  Offset _mapToScreenPixel({
    required double mx,
    required double my,
    required double resolution,
    required double originX,
    required double originY,
    required double mapHeight,
  }) {
    final px = resolution == 0.0 ? 0.0 : (mx - originX) / resolution;
    final py = resolution == 0.0 ? 0.0 : (my - originY) / resolution;
    // flip Y because in UI's convention, the Y axis runs downwards.
    final flippedY = mapHeight - py;
    return Offset(px, flippedY);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) {
        if (widget.controller.hiddenNotifier.value) {
          return Container();
        }
        Offset screenPose = _mapToScreenPixel(
          mx: widget.controller.poseNotifier.value.posX,
          my: widget.controller.poseNotifier.value.posY,
          resolution: widget.mapData.resolution,
          originX: widget.mapData.origin.posX,
          originY: widget.mapData.origin.posY,
          mapHeight: widget.mapData.height
        );
        return Positioned(
          left: screenPose.dx - widget.width / 2,
          top: screenPose.dy - widget.height / 2,
          child: Transform.rotate(
            angle: -widget.controller.poseNotifier.value.yaw,
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: widget.child,
            ),
          ),
        );
      }
    );
  }
}

class RobotMarker extends MapMarker {
  RobotMarker({
    super.key,
    required super.mapData,
    required ValueNotifier<Pose> poseNotifier,
    double size = 20,
    Color color = Colors.redAccent
  }) : super(
    controller: MapMarkerController(
      poseNotifier: poseNotifier,
    ),
    child: Transform.rotate(
      angle: pi / 2.0,
      child: Icon(Icons.navigation, color: color),
    ),
    width: size,
    height: size
  );
}

class HomeMarker extends MapMarker {
  HomeMarker({
    super.key,
    required super.mapData,
    required ValueNotifier<Pose> poseNotifier,
    ValueNotifier<bool>? hiddenNotifier,
    double size = 20,
    Color color = Colors.blueAccent
  }) : super(
    controller: MapMarkerController(
      poseNotifier: poseNotifier,
    ),
    child: Icon(Icons.home, color: color),
    width: size,
    height: size
  );
}
