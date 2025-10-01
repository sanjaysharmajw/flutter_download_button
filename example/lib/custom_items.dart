
import 'package:flutter/material.dart';
import 'package:flutter_download_button/flutter_download_button.dart';

/// A customizable list item widget that includes a download button.
class CustomizableDownloadListItem extends StatelessWidget {
  /// Creates a new [CustomizableDownloadListItem].
  const CustomizableDownloadListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.downloadController,
    this.leading,
    this.onTap,
    this.config = const DownloadButtonConfig(),
    this.titleStyle,
    this.subtitleStyle,
    this.buttonWidth = 96,
  });

  final String title;
  final String subtitle;
  final DownloadController downloadController;
  final Widget? leading;
  final VoidCallback? onTap;
  final DownloadButtonConfig config;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double buttonWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: leading ?? const _DefaultIcon(),
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: titleStyle ?? theme.textTheme.titleLarge,
      ),
      subtitle: Text(
        subtitle,
        overflow: TextOverflow.ellipsis,
        style: subtitleStyle ?? theme.textTheme.bodySmall,
      ),
      trailing: SizedBox(
        width: buttonWidth,
        child: AnimatedBuilder(
          animation: downloadController,
          builder: (context, child) {
            return CustomizableDownloadButton(
              status: downloadController.downloadStatus,
              downloadProgress: downloadController.progress,
              onDownload: downloadController.startDownload,
              onCancel: downloadController.stopDownload,
              onOpen: downloadController.openDownload,
              config: config,
            );
          },
        ),
      ),
      onTap: onTap,
    );
  }
}

class _DefaultIcon extends StatelessWidget {
  const _DefaultIcon();

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 1,
      child: FittedBox(
        child: SizedBox(
          width: 80,
          height: 80,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.blue],
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Center(
              child: Icon(
                Icons.file_download,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}