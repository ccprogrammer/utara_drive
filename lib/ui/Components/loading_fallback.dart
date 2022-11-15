import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:utara_drive/themes/my_themes.dart';

class LoadingFallback extends StatelessWidget {
  const LoadingFallback({
    required this.isLoading,
    required this.child,
     this.loadingLabel,
    Key? key,
  }) : super(key: key);

  final bool isLoading;
  final Widget child;
  final String? loadingLabel;

  @override
  Widget build(BuildContext context) {
    buildIndicator() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: MyTheme.colorBlueGrey,
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                color: MyTheme.colorCyan,
              ),
            ),
            const SizedBox(width: 10),
            DefaultTextStyle(
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
              child: Text(
                loadingLabel ?? 'Loading',
              ),
            ),
          ],
        ),
      );
    }

    return LoadingOverlay(
      isLoading: isLoading,
      color: Colors.black54,
      progressIndicator: buildIndicator(),
      child: child,
    );
  }
}
