import 'package:flutter/material.dart';

enum SnackbarType {
  error,
  success,
  info,
}

class CustomSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    Color backgroundColor = const Color(0xFFff4444), // Red color
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismiss,
    SnackbarType? type,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => _SnackbarOverlay(
        message: message,
        backgroundColor: backgroundColor,
        textColor: textColor,
        duration: duration,
        onDismiss: onDismiss,
        type: type,
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }

  // Error snackbar (red)
  static void showError(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      backgroundColor: const Color(0xFFff4444),
      type: SnackbarType.error,
    );
  }

  // Success snackbar (green)
  static void showSuccess(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      backgroundColor: const Color(0xff00c851),
      type: SnackbarType.success,
    );
  }

  // Info snackbar (blue)
  static void showInfo(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      backgroundColor: const Color(0xFF2196F3),
      type: SnackbarType.info,
    );
  }
}

// Snackbar Overlay Widget
class _SnackbarOverlay extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final Duration duration;
  final VoidCallback? onDismiss;
  final SnackbarType? type;

  const _SnackbarOverlay({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    required this.duration,
    this.onDismiss,
    this.type,
  });

  @override
  State<_SnackbarOverlay> createState() => _SnackbarOverlayState();
}

class _SnackbarOverlayState extends State<_SnackbarOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();

    // Auto dismiss
    Future.delayed(widget.duration - const Duration(milliseconds: 300), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      widget.onDismiss?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: (widget.type != null && widget.type == SnackbarType.success) 
                      ? Image.asset("assets/additional_icons/check.png") : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          color: widget.textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _dismiss,
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset("assets/additional_icons/close.png"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}