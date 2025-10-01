import 'package:flutter/material.dart';
import 'package:flutter_download_button/flutter_download_button.dart';
import 'package:open_file/open_file.dart';

void main() {
  runApp(
    const MaterialApp(
      home: CustomizableDownloadExampleScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class CustomizableDownloadExampleScreen extends StatefulWidget {
  const CustomizableDownloadExampleScreen({super.key});

  @override
  State<CustomizableDownloadExampleScreen> createState() =>
      _CustomizableDownloadExampleScreenState();
}

class _CustomizableDownloadExampleScreenState
    extends State<CustomizableDownloadExampleScreen> {
  late final List<DownloadController> _downloadControllers;

  final List<DownloadItemWithConfig> _items = [
    // Material Design Style
    DownloadItemWithConfig(
      name: 'Material Style PDF',
      url: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      fileName: 'material_sample.pdf',
      config: DownloadButtonConfig.material,
    ),
    // Cupertino/iOS Style
    DownloadItemWithConfig(
      name: 'iOS Style Image',
      url: 'https://picsum.photos/200/300',
      fileName: 'ios_image.jpg',
      config: DownloadButtonConfig.cupertino,
    ),
    // Custom Purple Style
    DownloadItemWithConfig(
      name: 'Custom Purple Button',
      url: 'https://filesamples.com/samples/document/txt/sample3.txt',
      fileName: 'purple_doc.txt',
      config: const DownloadButtonConfig(
        downloadText: '⬇ Download',
        openText: '📂 Open',
        backgroundColor: Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        progressColor: Colors.white,
        progressBackgroundColor: Color(0x40FFFFFF),
        elevation: 4.0,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        buttonPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      ),
    ),
    // Gradient Style with Icons
    DownloadItemWithConfig(
      name: 'Green with Icons',
      url: 'https://images.pexels.com/photos/33502020/pexels-photo-33502020.jpeg',
      fileName: 'green_pexels.jpeg',
      config: const DownloadButtonConfig(
        downloadText: 'Download',
        openText: 'Open',
        backgroundColor: Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        progressColor: Colors.white,
        progressBackgroundColor: Color(0x40FFFFFF),
        downloadIcon: Icons.download_rounded,
        openIcon: Icons.folder_open,
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    // Minimal Flat Style
    DownloadItemWithConfig(
      name: 'Minimal Flat Design',
      url: 'https://www.princexml.com/samples/icelandic/dictionary.pdf',
      fileName: 'minimal_dictionary.pdf',
      config: DownloadButtonConfig.minimal,
    ),
    // Rounded Elevated Style
    DownloadItemWithConfig(
      name: 'Rounded Elevated',
      url: 'http://3.109.162.244/v1/Inspector_App/Inspector_app_controller/board_employee_payslip/1/102/5148/3/2023/3/2023',
      fileName: 'rounded_payslip.pdf',
      config: DownloadButtonConfig.rounded,
    ),
    // Custom Orange with Large Text
    DownloadItemWithConfig(
      name: 'Large Text Orange',
      url: 'https://images.pexels.com/photos/33772565/pexels-photo-33772565.jpeg',
      fileName: 'pexels-photo-33772565.jpeg',
      config: DownloadButtonConfig(
        downloadText: 'GET FILE',
        openText: 'OPEN FILE',
        backgroundColor: const Color(0xFFFF9800),
        foregroundColor: Colors.white,
        progressColor: Colors.white,
        progressBackgroundColor: const Color(0x40FFFFFF),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
        elevation: 6.0,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        buttonPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        minWidth: 120,
      ),
    ),
    // Outlined Style
    DownloadItemWithConfig(
      name: 'Outlined Style',
      url: 'http://3.109.162.244/v1/Inspector_App/Inspector_app_controller/board_employee_payslip/1/102/5148/3/2023/3/2023',
      fileName: 'vikram_payslip_102_2025_1.pdf',
      config: const DownloadButtonConfig(
        downloadText: 'Download',
        openText: 'Open',
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF2196F3),
        progressColor: Color(0xFF2196F3),
        progressBackgroundColor: Color(0x20000000),
        buttonShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: Color(0xFF2196F3), width: 2),
        ),
        elevation: 0.0,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _downloadControllers = _items
        .map((item) => RealDownloadController(
      fileName: item.fileName,
      downloadUrl: item.url,
      onOpenDownload: () => _openDownload(item),
    ))
        .toList();
    _checkAllFiles();
  }

  Future<void> _checkAllFiles() async {
    for (var controller in _downloadControllers) {
      await controller.checkFileExists();
    }
  }

  Future<void> _openDownload(DownloadItemWithConfig item) async {
    try {
      final result = await DownloadService.openFile(item.fileName);

      if (mounted) {
        if (result.type == ResultType.done) {
          _showSnackBar('Opening ${item.name}');
        } else {
          _showSnackBar('Unable to open file: ${result.message}',
              isError: true);
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error opening file: $e', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customizable Download Buttons'),
        elevation: 2,
        backgroundColor: const Color(0xFF6200EE),
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return CustomizableDownloadListItem(
            title: _items[index].name,
            subtitle: _items[index].fileName,
            downloadController: _downloadControllers[index],
            config: _items[index].config,
            buttonWidth: _items[index].config.minWidth,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _downloadControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class DownloadItemWithConfig {
  final String name;
  final String url;
  final String fileName;
  final DownloadButtonConfig config;

  DownloadItemWithConfig({
    required this.name,
    required this.url,
    required this.fileName,
    required this.config,
  });
}



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