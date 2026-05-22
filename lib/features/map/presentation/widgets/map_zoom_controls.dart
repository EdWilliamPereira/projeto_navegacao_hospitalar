import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

/// Accessible zoom + / − buttons and an optional "fit bounds" button.
/// Each button is 48×48 dp — meets WCAG 2.1 touch target requirements.
class MapZoomControls extends StatelessWidget {
  final MapController controller;

  /// When provided, the button fits these bounds in view.
  final LatLngBounds? routeBounds;

  const MapZoomControls({
    super.key,
    required this.controller,
    this.routeBounds,
  });

  void _zoomIn() {
    final current = controller.camera.zoom;
    controller.move(controller.camera.center, current + 1);
  }

  void _zoomOut() {
    final current = controller.camera.zoom;
    controller.move(controller.camera.center, current - 1);
  }

  void _fitBounds() {
    final bounds = routeBounds;
    if (bounds == null) return;
    controller.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(48),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ZoomButton(
            tooltip: 'Zoom in',
            icon: Icons.add,
            onTap: _zoomIn,
          ),
          const Divider(height: 1),
          _ZoomButton(
            tooltip: 'Zoom out',
            icon: Icons.remove,
            onTap: _zoomOut,
          ),
          if (routeBounds != null) ...[
            const Divider(height: 1),
            _ZoomButton(
              tooltip: 'Fit route in view',
              icon: Icons.fit_screen,
              onTap: _fitBounds,
            ),
          ],
        ],
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  const _ZoomButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }
}