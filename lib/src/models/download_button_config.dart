import 'package:flutter/material.dart';

/// Configuration class for customizing the download button appearance and behavior.
@immutable
class DownloadButtonConfig {
  /// Creates a new [DownloadButtonConfig].
  const DownloadButtonConfig({
    this.downloadText = 'GET',
    this.openText = 'OPEN',
    this.backgroundColor = const Color(0xFFE5E5EA),
    this.foregroundColor = const Color(0xFF007AFF),
    this.stopIconColor = const Color(0xFF007AFF),
    this.progressColor = const Color(0xFF007AFF),
    this.progressBackgroundColor = const Color(0xFFE5E5EA),
    this.fetchingColor = const Color(0xFFE5E5EA),
    this.textStyle,
    this.downloadIcon,
    this.openIcon,
    this.stopIcon = Icons.stop,
    this.stopIconSize = 14.0,
    this.buttonShape,
    this.progressShape,
    this.transitionDuration = const Duration(milliseconds: 500),
    this.progressStrokeWidth = 2.0,
    this.buttonPadding = const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    this.minWidth = 96.0,
    this.borderRadius,
    this.elevation = 0.0,
    this.showStopIcon = true,
    this.allowCancel = true,
  });

  /// Text to display when file is not downloaded (default: 'GET')
  final String downloadText;

  /// Text to display when file is downloaded (default: 'OPEN')
  final String openText;

  /// Background color of the button
  final Color backgroundColor;

  /// Foreground color
  final Color foregroundColor;

  /// icons color
  final Color stopIconColor;

  /// Color of the progress indicator
  final Color progressColor;

  /// Background color of the progress indicator
  final Color progressBackgroundColor;

  /// Color during fetching state
  final Color fetchingColor;

  /// Custom text style for button text
  final TextStyle? textStyle;

  /// Custom icon for download state
  final IconData? downloadIcon;

  /// Custom icon for open state
  final IconData? openIcon;

  /// Icon to show during download for stopping (default: Icons.stop)
  final IconData stopIcon;

  /// Size of the stop icon
  final double stopIconSize;

  /// Custom shape for the button
  final ShapeBorder? buttonShape;

  /// Custom shape for progress indicator
  final ShapeBorder? progressShape;

  /// Duration of transitions between states
  final Duration transitionDuration;

  /// Stroke width of the progress indicator
  final double progressStrokeWidth;

  /// Padding inside the button
  final EdgeInsets buttonPadding;

  /// Minimum width of the button
  final double minWidth;

  /// Border radius (used if buttonShape is not provided)
  final BorderRadius? borderRadius;

  /// Elevation of the button
  final double elevation;

  /// Whether to show stop icon during download
  final bool showStopIcon;

  /// Whether download can be cancelled
  final bool allowCancel;

  /// Creates a copy with modified properties
  DownloadButtonConfig copyWith({
    String? downloadText,
    String? openText,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? progressColor,
    Color? progressBackgroundColor,
    Color? fetchingColor,
    TextStyle? textStyle,
    IconData? downloadIcon,
    IconData? openIcon,
    IconData? stopIcon,
    double? stopIconSize,
    ShapeBorder? buttonShape,
    ShapeBorder? progressShape,
    Duration? transitionDuration,
    double? progressStrokeWidth,
    EdgeInsets? buttonPadding,
    double? minWidth,
    BorderRadius? borderRadius,
    double? elevation,
    bool? showStopIcon,
    bool? allowCancel,
  }) {
    return DownloadButtonConfig(
      downloadText: downloadText ?? this.downloadText,
      openText: openText ?? this.openText,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      progressColor: progressColor ?? this.progressColor,
      progressBackgroundColor: progressBackgroundColor ?? this.progressBackgroundColor,
      fetchingColor: fetchingColor ?? this.fetchingColor,
      textStyle: textStyle ?? this.textStyle,
      downloadIcon: downloadIcon ?? this.downloadIcon,
      openIcon: openIcon ?? this.openIcon,
      stopIcon: stopIcon ?? this.stopIcon,
      stopIconSize: stopIconSize ?? this.stopIconSize,
      buttonShape: buttonShape ?? this.buttonShape,
      progressShape: progressShape ?? this.progressShape,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      progressStrokeWidth: progressStrokeWidth ?? this.progressStrokeWidth,
      buttonPadding: buttonPadding ?? this.buttonPadding,
      minWidth: minWidth ?? this.minWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      showStopIcon: showStopIcon ?? this.showStopIcon,
      allowCancel: allowCancel ?? this.allowCancel,
    );
  }

  /// Material Design style preset
  static const DownloadButtonConfig material = DownloadButtonConfig(
    downloadText: 'DOWNLOAD',
    openText: 'OPEN',
    backgroundColor: Color(0xFF2196F3),
    foregroundColor: Colors.white,
    progressColor: Colors.white,
    progressBackgroundColor: Color(0x40FFFFFF),
    elevation: 2.0,
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );

  /// iOS Cupertino style preset
  static const DownloadButtonConfig cupertino = DownloadButtonConfig(
    downloadText: 'GET',
    openText: 'OPEN',
    backgroundColor: Color(0xFFE5E5EA),
    foregroundColor: Color(0xFF007AFF),
    progressColor: Color(0xFF007AFF),
    progressBackgroundColor: Color(0xFFE5E5EA),
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );

  /// Minimal style preset
  static const DownloadButtonConfig minimal = DownloadButtonConfig(
    downloadText: 'Download',
    openText: 'Open',
    backgroundColor: Colors.transparent,
    foregroundColor: Color(0xFF333333),
    progressColor: Color(0xFF333333),
    progressBackgroundColor: Color(0xFFE0E0E0),
    elevation: 0.0,
    borderRadius: BorderRadius.all(Radius.circular(8)),
    buttonPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  );

  /// Rounded style preset
  static const DownloadButtonConfig rounded = DownloadButtonConfig(
    downloadText: 'GET',
    openText: 'OPEN',
    backgroundColor: Color(0xFF6200EE),
    foregroundColor: Colors.white,
    progressColor: Colors.white,
    progressBackgroundColor: Color(0x40FFFFFF),
    elevation: 4.0,
    borderRadius: BorderRadius.all(Radius.circular(24)),
    buttonPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  );
}