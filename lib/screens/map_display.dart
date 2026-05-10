import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rui/data/data_types.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class MapMarker {
  MapMarker({
    required this.marker,
    required this.pose,
    required this.width,
    required this.height
  });

  final LayerLink layerLink = LayerLink();
  final Widget marker;
  final ValueNotifier<Pose> pose;
  final double width;
  final double height;
  final ValueNotifier<bool> hiddenNotifier = ValueNotifier(false);
}

class RobotMarker extends MapMarker {
  RobotMarker({
    required super.pose,
    double size = 20,
    Color color = Colors.redAccent
  }) : super(
    marker: Transform.rotate(
      angle: pi / 2.0,
      child: Icon(Icons.navigation, color: color),
    ),
    width: size,
    height: size,
  );
}

class HomeMarker extends MapMarker {
  HomeMarker({
    required super.pose,
    double size = 20,
    Color color = Colors.blueAccent
  }) : super(
    marker: Icon(Icons.home, color: color),
    width: size,
    height: size
  );
}

class MapDisplay extends StatefulWidget {
  const MapDisplay({
    super.key,
    required this.mapData,
    required this.mapMarkers,
  });

  final MapData mapData;
  final List<MapMarker> mapMarkers;

  @override
  State<MapDisplay> createState() => _MapDisplayState();
}

class _MapDisplayState extends State<MapDisplay> {
  static const double _minScale = 1.0;
  static const double _maxScale = 10.0;
  final TransformationController _transformController = TransformationController();
  final GlobalKey _stackKey = GlobalKey();
  BoxConstraints _viewerConstraints = BoxConstraints();
  final ValueNotifier<double> _selectedScaleNotifier = ValueNotifier(1.0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

void _fitToScreen() {
  final scaleX = _viewerConstraints.maxWidth / widget.mapData.width;
  final scaleY = _viewerConstraints.maxHeight / widget.mapData.height;
  final scale = min(scaleX, scaleY);
  final dx = (_viewerConstraints.maxWidth - widget.mapData.width * scale) / 2;
  final dy = (_viewerConstraints.maxHeight - widget.mapData.height * scale) / 2;
  _transformController.value = Matrix4.identity()
    ..translateByVector3(math.Vector3(dx, dy, 0.0))
    ..scaleByVector3(math.Vector3(scale, scale, scale));
  _selectedScaleNotifier.value = _transformController.value.getMaxScaleOnAxis();
}

  void _setScale(double scale, double min, double max) {
    // Normalize the given scale to the display's range.
    final norm = (scale - min) / (max - min);
    final scaleToUse = norm * (_maxScale - _minScale) + _minScale;
    final dx = (_viewerConstraints.maxWidth - widget.mapData.width * scaleToUse) / 2;
    final dy = (_viewerConstraints.maxHeight - widget.mapData.height * scaleToUse) / 2;
    _transformController.value = Matrix4.identity()
      ..translateByVector3(math.Vector3(dx, dy, 0))
      ..scaleByVector3(math.Vector3(scaleToUse, scaleToUse, scaleToUse));
  }

  Offset _worldToMap({
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
    return Scaffold(
      body: Stack(
        key: _stackKey,
        children: [
          // WORLD LAYER
          LayoutBuilder(
            builder: (context, constraints) {
              _viewerConstraints = constraints;
              WidgetsBinding.instance.addPostFrameCallback((_) => _fitToScreen());
              return InteractiveViewer(
                transformationController: _transformController,
                minScale: _minScale,
                maxScale: _maxScale,
                scaleFactor: kDefaultMouseScrollToScaleFactor * 4,
                constrained: false,
                boundaryMargin: EdgeInsets.all(min(widget.mapData.width, widget.mapData.height) * 0.5),
                onInteractionEnd:(details) {
                  _selectedScaleNotifier.value = _transformController.value.getMaxScaleOnAxis();
                },
                child: SizedBox(
                  width: widget.mapData.width,
                  height: widget.mapData.height,
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(widget.mapData.width, widget.mapData.height),
                        painter: _MapPainter(mapImage: widget.mapData.mapImage),
                      ),
                      ...widget.mapMarkers.map((marker) {
                        return ValueListenableBuilder(
                          valueListenable: marker.pose,
                          builder: (context, value, child) {
                            Offset pos = _worldToMap(
                              mx: value.posX,
                              my: value.posY,
                              resolution: widget.mapData.resolution,
                              originX: widget.mapData.origin.posX,
                              originY: widget.mapData.origin.posY,
                              mapHeight: widget.mapData.height
                            );
                            return Positioned(
                              left: pos.dx - marker.width / 2.0,
                              top: pos.dy - marker.height / 2.0,
                              child: CompositedTransformTarget(
                                link: marker.layerLink,
                                child: Transform.rotate(
                                  angle: -marker.pose.value.yaw,
                                  child: _InteractiveViewMarker(
                                    mapData: widget.mapData,
                                    marker: marker.marker,
                                    width: marker.width,
                                    height: marker.height,
                                    hiddenNotifier: marker.hiddenNotifier,
                                    onTap: (){},
                                    onSecondaryTapDown:(details) {},
                                  )
                                )
                              )
                            );
                          }
                        );
                      })
                    ],
                  ),
                ),
              );
            }
          ),
          // LIGHTWEIGHT OVERLAY LAYER
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _transformController,
              builder: (context, child) {
                return Stack(
                  children: [
                    ...widget.mapMarkers.map((marker) {
                      return CompositedTransformFollower(
                        link: marker.layerLink,
                        child: _OverlayMarker(
                          width: marker.width,
                          height: marker.height
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
          // HUD LAYER
          Positioned(
            top: 10,
            right: 10,
            bottom: 10,
            left: 10,
            child: _MapHUD(
              selectedScaleNotifier: _selectedScaleNotifier,
              scaleMin: _minScale,
              scaleMax: _maxScale,
              onFitToScreenClicked: _fitToScreen,
              onScaleChanged: _setScale,
              onHiddenChanged: (hidden) {
                for (var m in widget.mapMarkers) {
                  m.hiddenNotifier.value = hidden;
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter({required this.mapImage});

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

class _MapHUD extends StatefulWidget {
  const _MapHUD({
    required this.selectedScaleNotifier,
    required this.scaleMin,
    required this.scaleMax,
    required this.onFitToScreenClicked,
    required this.onScaleChanged,
    required this.onHiddenChanged,
  });

  final ValueNotifier<double> selectedScaleNotifier;
  final double scaleMin;
  final double scaleMax;
  final void Function()? onFitToScreenClicked;
  final void Function(double, double, double)? onScaleChanged;
  final void Function(bool)? onHiddenChanged;

  @override
  State<StatefulWidget> createState() => _MapHUDState();
}

class _MapHUDState extends State<_MapHUD> {
  bool _internalSliderChange = false;
  final _markersHidden = ValueNotifier(false);
  late final ShadSliderController _sliderController = ShadSliderController(initialValue: widget.scaleMin);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 8.0,
          children: [
            SizedBox(
              width: 150,
              child: ValueListenableBuilder(
                valueListenable: widget.selectedScaleNotifier,
                builder: (context, value, child) {
                  if (!_internalSliderChange) {
                  _sliderController.value = value;
                  }
                  _internalSliderChange = false;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5.0,
                    children: [
                      Text(_sliderController.value.toStringAsFixed(1), style: Theme.of(context).primaryTextTheme.labelLarge),
                      ShadSlider(
                        controller: _sliderController,
                        divisions: 100,
                        min: widget.scaleMin,
                        max: widget.scaleMax,
                        onChanged: (newValue) {
                          setState(() {
                            _internalSliderChange = true;
                          });
                          widget.onScaleChanged?.call(newValue, widget.scaleMin, widget.scaleMax);
                        },
                      )
                    ],
                  );
                }
              )
            ),
            ShadTooltip(
              builder: (context) {
                return Text('Fit to screen');
              },
              child: ShadIconButton.secondary(
                icon: Icon(Icons.fit_screen),
                onPressed: widget.onFitToScreenClicked?.call,
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
        )
      ],
    );
  }
}

class _InteractiveViewMarker extends StatefulWidget {
  const _InteractiveViewMarker({
    required this.mapData,
    required this.marker,
    required this.width,
    required this.height,
    required this.hiddenNotifier,
    required this.onTap,
    required this.onSecondaryTapDown,
  });

  final MapData mapData;
  final Widget marker;
  final double width;
  final double height;
  final ValueNotifier<bool> hiddenNotifier;
  final VoidCallback onTap;
  final Function(TapDownDetails details) onSecondaryTapDown;

  @override
  State<StatefulWidget> createState() => _InteractiveViewMarkerState();
}

class _InteractiveViewMarkerState extends State<_InteractiveViewMarker> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      onEnter: (_) {
        setState(() {
          _hovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovering = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        onSecondaryTapDown: widget.onSecondaryTapDown,
        child: AnimatedScale(
          scale: _hovering ? 1.2 : 1.0,
          duration:
              const Duration(milliseconds: 120),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                if (_hovering) BoxShadow(
                  blurRadius: 15,
                  color: Colors.black.withValues(alpha: 0.2),
                ),
              ],
            ),
            child: ValueListenableBuilder(
              valueListenable: widget.hiddenNotifier,
              builder: (context, hidden, child) {
                return hidden ? Container()
                  : SizedBox(
                    width: widget.width,
                    height: widget.height,
                    child: widget.marker,
                  );
              }
            )
          ),
        ),
      ),
    );
  }
}

class _OverlayMarker extends StatefulWidget {
  const _OverlayMarker({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  State<StatefulWidget> createState() => _OverlayMarkerState();
}

class _OverlayMarkerState extends State<_OverlayMarker> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      opaque: false,
      child: GestureDetector(
        child: SizedBox(
          width: widget.width,
          height: widget.height
        ),
      ),
    );
  }
}
