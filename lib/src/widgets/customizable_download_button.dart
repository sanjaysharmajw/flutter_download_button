import 'package:flutter/material.dart';
import '../models/download_status.dart';
import '../models/download_button_config.dart';

/// A highly customizable download button widget with animated progress indication.
@immutable
class CustomizableDownloadButton extends StatelessWidget {
  /// Creates a new [CustomizableDownloadButton].
  const CustomizableDownloadButton({
    super.key,
    required this.status,
    this.downloadProgress = 0.0,
    required this.onDownload,
    required this.onCancel,
    required this.onOpen,
    this.config = const DownloadButtonConfig(),
  });

  final DownloadStatus status;
  final double downloadProgress;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onOpen;
  final DownloadButtonConfig config;

  bool get _isDownloading => status == DownloadStatus.downloading;
  bool get _isFetching => status == DownloadStatus.fetchingDownload;
  bool get _isDownloaded => status == DownloadStatus.downloaded;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Stack(
        children: [
          _ButtonShapeWidget(
            isDownloading: _isDownloading,
            isDownloaded: _isDownloaded,
            isFetching: _isFetching,
            config: config,
          ),
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _ProgressIndicatorWidget(
                    downloadProgress: downloadProgress,
                    isDownloading: _isDownloading,
                    isFetching: _isFetching,
                    config: config,
                  ),
                  if (_isDownloading && config.showStopIcon)
                    Icon(
                      config.stopIcon,
                      size: config.stopIconSize,
                      color: config.foregroundColor,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onPressed() {
    switch (status) {
      case DownloadStatus.notDownloaded:
        onDownload();
        break;
      case DownloadStatus.fetchingDownload:
        if (config.allowCancel) {
          onCancel();
        }
        break;
      case DownloadStatus.downloading:
        if (config.allowCancel) {
          onCancel();
        }
        break;
      case DownloadStatus.downloaded:
        onOpen();
        break;
    }
  }
}

@immutable
class _ButtonShapeWidget extends StatelessWidget {
  const _ButtonShapeWidget({
    required this.isDownloading,
    required this.isDownloaded,
    required this.isFetching,
    required this.config,
  });

  final bool isDownloading;
  final bool isDownloaded;
  final bool isFetching;
  final DownloadButtonConfig config;

  @override
  Widget build(BuildContext context) {
    ShapeDecoration shape;

    if (isDownloading || isFetching) {
      shape = ShapeDecoration(
        shape: config.progressShape ?? const CircleBorder(),
        color: Colors.transparent,
      );
    } else {
      shape = ShapeDecoration(
        shape: config.buttonShape ??
            (config.borderRadius != null
                ? RoundedRectangleBorder(borderRadius: config.borderRadius!)
                : const StadiumBorder()),
        color: config.backgroundColor,
      );
    }

    return AnimatedContainer(
      duration: config.transitionDuration,
      curve: Curves.ease,
      constraints: BoxConstraints(minWidth: config.minWidth),
      decoration: ShapeDecoration(
        shape: shape.shape, // reuse shape's existing shape
        color: shape.color,
        gradient: shape.gradient,
        image: shape.image,
        shadows: config.elevation > 0
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: config.elevation * 2,
            offset: Offset(0, config.elevation),
          )
        ]
            : null,
      ),

      // decoration: shape.copyWith(
      //   shadows: config.elevation > 0
      //       ? [BoxShadow(
      //     color: Colors.black.withOpacity(0.2),
      //     blurRadius: config.elevation * 2,
      //     offset: Offset(0, config.elevation),
      //   )] : null,
      // ),
      child: Padding(
        padding: config.buttonPadding,
        child: AnimatedOpacity(
          opacity: isDownloading || isFetching ? 0.0 : 1.0,
          duration: config.transitionDuration,
          curve: Curves.ease,
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final textStyle = config.textStyle ??
        Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: config.foregroundColor,
        ) ??
        TextStyle(
          fontWeight: FontWeight.bold,
          color: config.foregroundColor,
        );

    if (isDownloaded && config.openIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(config.openIcon, size: 16, color: config.foregroundColor),
          const SizedBox(width: 4),
          Text(config.openText, style: textStyle),
        ],
      );
    }

    if (!isDownloaded && config.downloadIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(config.downloadIcon, size: 16, color: config.foregroundColor),
          const SizedBox(width: 4),
          Text(config.downloadText, style: textStyle),
        ],
      );
    }

    return Text(
      isDownloaded ? config.openText : config.downloadText,
      textAlign: TextAlign.center,
      style: textStyle,
    );
  }
}

@immutable
class _ProgressIndicatorWidget extends StatelessWidget {
  const _ProgressIndicatorWidget({
    required this.downloadProgress,
    required this.isDownloading,
    required this.isFetching,
    required this.config,
  });

  final double downloadProgress;
  final bool isDownloading;
  final bool isFetching;
  final DownloadButtonConfig config;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: downloadProgress),
        duration: const Duration(milliseconds: 200),
        builder: (context, progress, child) {
          return CircularProgressIndicator(
            backgroundColor: isDownloading
                ? config.progressBackgroundColor
                : Colors.transparent,
            valueColor: AlwaysStoppedAnimation(
              isFetching ? config.fetchingColor : config.progressColor,
            ),
            strokeWidth: config.progressStrokeWidth,
            value: isFetching ? null : progress,
          );
        },
      ),
    );
  }
}