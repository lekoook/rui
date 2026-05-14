import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rui/data/data_types.dart';
import 'package:rui/data/geometry_msgs.dart' hide Transform;
import 'package:rui/screens/app_constants.dart';
import 'package:rui/screens/buttons.dart';
import 'package:rui/screens/cards.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class MapMarker {
  MapMarker({
    required this.marker,
    required this.pose,
    required this.width,
    required this.height,
    this.popupWidget
  });

  final LayerLink layerLink = LayerLink();
  final Widget marker;
  final ValueNotifier<Pose> pose;
  final double width;
  final double height;
  final Widget? popupWidget;
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
    popupWidget: SizedBox(
      width: 100,
      height: 100,
      child: ShadCard(
        // TODO:
      ),
    )
  );
}

class HomeMarker extends MapMarker {
  HomeMarker({
    required super.pose,
    double size = 20,
    Color color = Colors.blueAccent
  }) : super(
    marker: Transform.rotate(
      angle: pi / 2.0,
      child: Icon(Icons.home, color: color),
    ),
    width: size,
    height: size,
    popupWidget: SizedBox(
      width: 100,
      height: 100,
      child: ShadCard(
        // TODO:
      ),
    )
  );
}

class MapDisplay extends StatefulWidget {
  const MapDisplay({
    super.key,
    required this.mapData,
    required this.mapMarkers,
  });

  final MapInfo mapData;
  final List<MapMarker> mapMarkers;

  @override
  State<MapDisplay> createState() => _MapDisplayState();
}

class _MapDisplayState extends State<MapDisplay> with AutomaticKeepAliveClientMixin {
  static const double _minScale = 1.0;
  static const double _maxScale = 10.0;
  bool _noMap = false;
  final TransformationController _transformController = TransformationController();
  final _popoverController = ShadPopoverController();
  final GlobalKey _stackKey = GlobalKey();
  BoxConstraints _viewerConstraints = BoxConstraints();
  final ValueNotifier<double> _selectedScaleNotifier = ValueNotifier(1.0);
  final Set<MapMarker> _selectedMarkers = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

void _fitToScreen() {
  if (_noMap) {
    return;
  }
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
    if (_noMap) {
      return;
    }
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
    super.build(context);
    _noMap = widget.mapData.mapImage == null;
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: constraints,
          child: Column(
            children: [
              AppBar(
                toolbarHeight: 30,
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
                      return Text('Map information');
                    },
                    child: InfoButton.ghost(
                      onPressed: _popoverController.toggle,
                    ),
                  )
                ),
                title: Text(widget.mapData.name)
              ),
              ShadSeparator.horizontal(),
              Expanded(
                child: Stack(
                  key: _stackKey,
                  children: [
                    // WORLD LAYER
                    _noMap
                    ? Center(child: Text('No map to display', style: ShadTheme.of(context).textTheme.h3))
                    : LayoutBuilder(
                      builder: (context, constraints) {
                        _viewerConstraints = constraints;
                        return GestureDetector(
                          onTap:() {
                            setState(() {
                              _selectedMarkers.clear();
                            });
                          },
                          child: InteractiveViewer(
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
                                  painter: MapPainter(mapImage: widget.mapData.mapImage),
                                ),
                                ...widget.mapMarkers.map((marker) {
                                  return ValueListenableBuilder(
                                    valueListenable: marker.pose,
                                    builder: (context, value, child) {
                                      Offset pos = _worldToMap(
                                        mx: value.position.x,
                                        my: value.position.y,
                                        resolution: widget.mapData.resolution,
                                        originX: widget.mapData.origin.position.x,
                                        originY: widget.mapData.origin.position.y,
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
                                              onTap: (){
                                                setState(() {
                                                  if (_selectedMarkers.contains(marker)) {
                                                    _selectedMarkers.remove(marker);
                                                  } else {
                                                    _selectedMarkers.add(marker);
                                                  }
                                                });
                                              },
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
                        ));
                      }
                    ),
                    // LIGHTWEIGHT OVERLAY LAYER
                    Positioned.fill(
                      child: Stack(
                        children: [
                          ..._selectedMarkers.map((marker) {
                            return CompositedTransformFollower(
                              link: marker.layerLink,
                              offset: Offset(marker.width / 2.0, marker.height / 2.0 + AppSpacing.sm),
                              followerAnchor: Alignment.topCenter,
                              child: _OverlayPopup(hiddenNotifier: marker.hiddenNotifier, child: marker.popupWidget),
                            );
                          })
                        ],
                      )
                    ),
                    // HUD LAYER
                    Positioned(
                      top: AppSpacing.sm,
                      right: AppSpacing.sm,
                      bottom: AppSpacing.sm,
                      left: AppSpacing.sm,
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
                )
              )
            ],
          )
        );
      }
    );
  }
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
                      Text(
                        _sliderController.value.toStringAsFixed(1),
                        style: ShadTheme.of(context).textTheme.p.copyWith(
                          shadows: [Shadow(color: ShadTheme.of(context).colorScheme.background, blurRadius: 5)]
                        )
                      ),
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
                    return _markersHidden.value ? Text('Show markers') : Text('Hide markers');
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

  final MapInfo mapData;
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
                return hidden
                ? Container()
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

class _OverlayPopup extends StatefulWidget {
  const _OverlayPopup({
    required this.hiddenNotifier,
    this.child
  });

  final ValueNotifier<bool> hiddenNotifier;
  final Widget? child;

  @override
  State<StatefulWidget> createState() => _OverlayPopupState();
}

class _OverlayPopupState extends State<_OverlayPopup> {
  final _popoverController = ShadPopoverController();

  @override
  void initState() {
    _popoverController.show();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.hiddenNotifier,
      builder: (context, value, child) {
        if (widget.child == null || value) {
          return Container();
        } else {
          return widget.child!;
        }
      }
    );
  }
}
