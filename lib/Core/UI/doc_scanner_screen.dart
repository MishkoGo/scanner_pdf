import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
import 'package:scanner_pdf/Core/UI/diamond_bottom_sheet.dart';
import 'package:scanner_pdf/Core/UI/settings_bottom_sheet.dart';
import 'package:scanner_pdf/common/extension/build_context.dart';
import 'package:scanner_pdf/common/models/document.dart';
import 'package:scanner_pdf/common/models/document_provider.dart';
import 'package:scanner_pdf/common/style/cubit/theme_cubit.dart';
import 'package:scanner_pdf/generated/l10n.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as p;

class DocScannerScreen extends StatelessWidget {
  DocScannerScreen({Key? key}) : super(key: key);

  final ValueNotifier<String?> _sendingFilePath = ValueNotifier(null);

  // Кэш для уже созданных PDF-файлов
  final Map<String, String> _pdfCache = {};

  void _showRenameDialog(BuildContext context, Document document) {
    final TextEditingController controller = TextEditingController(
      text: document.documentName,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).rename_document),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: S.of(context).new_name_document,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                Provider.of<DocumentProvider>(
                  context,
                  listen: false,
                ).renameDocument(document, controller.text);
                Navigator.pop(context);
              },
              child: Text(S.of(context).save),
            ),
          ],
        );
      },
    );
  }

  void _showFullScreenImage(BuildContext context, String imagePath) {
    final currentDir = context.read<Directory>();
    final file = File(p.join(currentDir.path, imagePath));

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding:
              EdgeInsets
                  .zero, // Убираем отступы, чтобы диалог был на весь экран
          child: Stack(
            children: [
              // Изображение на весь экран
              Center(
                child:
                    file.existsSync()
                        ? Image.file(
                          file,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.white,
                                size: 50,
                              ),
                            );
                          },
                        )
                        : const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
              ),
              // Кнопка закрытия (крестик) в верхнем правом углу
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pop(context); // Закрытие диалога
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> shareDocumentAsPdf(String imagePath) async {
    if (_sendingFilePath.value != null) return;

    if (imagePath.isNotEmpty) {
      try {
        _sendingFilePath.value = imagePath;

        final imageFile = File(imagePath);
        if (!await imageFile.exists()) {
          _sendingFilePath.value = null;
          return;
        }

        // Проверяем, есть ли PDF в кэше
        if (_pdfCache.containsKey(imagePath)) {
          final cachedPdfPath = _pdfCache[imagePath]!;
          if (File(cachedPdfPath).existsSync()) {
            await Share.shareXFiles([
              XFile(cachedPdfPath),
            ], text: 'Вот документ');
            _sendingFilePath.value = null;
            return;
          }
        }

        // Сжимаем изображение для ускорения
        final imageBytes = await imageFile.readAsBytes();
        final decodedImage = img.decodeImage(imageBytes);
        final resizedImage = img.copyResize(
          decodedImage!,
          width: 595, // Ширина A4 в пикселях при 72 DPI
          height: 842, // Высота A4 в пикселях при 72 DPI
          interpolation: img.Interpolation.linear,
        );
        final compressedBytes = img.encodeJpg(resizedImage, quality: 85);

        // Создаем PDF
        final pdf = pw.Document();
        final pdfImage = pw.MemoryImage(compressedBytes);
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Center(child: pw.Image(pdfImage));
            },
          ),
        );

        final tempDir = await getTemporaryDirectory();
        final pdfPath =
            '${tempDir.path}/document_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final pdfFile = File(pdfPath);
        await pdfFile.writeAsBytes(await pdf.save());

        // Сохраняем путь в кэш
        _pdfCache[imagePath] = pdfPath;

        await Share.shareXFiles([XFile(pdfPath)], text: 'Вот документ');
      } catch (e) {
        print('Ошибка при отправке PDF: $e');
      } finally {
        _sendingFilePath.value = null;
      }
    }
  }

  void _showDiamondBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const DiamondBottomSheet();
      },
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return const SettingsBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final documentProvider = Provider.of<DocumentProvider>(context);
    final documents = documentProvider.documents;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.color.appHeader,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.diamond, color: context.color.textColor),
          onPressed: () => _showDiamondBottomSheet(context),
        ),
        title: Text(S.of(context).documents, style: context.textStyles.body),
        actions: [
          IconButton(
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
            icon: Icon(Icons.light_mode, color: context.color.textColor),
          ),
          IconButton(
            onPressed: () => _showSettingsBottomSheet(context),
            icon: Icon(Icons.settings, color: context.color.textColor),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.color.search,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                style: TextStyle(color: context.color.textColor),
                decoration: InputDecoration(
                  fillColor: context.color.textColor,
                  hintText: S.of(context).enter_name_document,
                  hintStyle: TextStyle(color: context.color.textColor),
                  prefixIcon: Icon(
                    Icons.search,
                    color: context.color.textColor,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(10),
                ),
                onChanged: (text) {
                  documentProvider.updateSearch(text);
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child:
                  documents.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              S.of(context).empty_storage ??
                                  "В хранилище пусто",
                              style: context.textStyles.h1.copyWith(
                                color: context.color.textColor,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              S.of(context).scan_first_document,
                              style: context.textStyles.body.copyWith(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () => documentProvider.scanDocuments(),
                              child: Text(
                                S.of(context).start_scanning ??
                                    "Начать сканировать",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final document = documents[index];
                          return Card(
                            color: context.color.card,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${document.documentName} - ${document.documentDate}',
                                    style: context.textStyles.h1,
                                  ),
                                  Row(
                                    children: [
                                      Builder(
                                        builder: (context) {
                                          final currentDir =
                                              context.read<Directory>();
                                          final file = File(
                                            p.join(
                                              currentDir.path,
                                              document.imagePath,
                                            ),
                                          );
                                          if (file.existsSync()) {
                                            return GestureDetector(
                                              onTap:
                                                  () => _showFullScreenImage(
                                                    context,
                                                    document.imagePath,
                                                  ),
                                              child: Image.file(
                                                File(file.path),
                                                width: 110,
                                                height: 110,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              width: 110,
                                              height: 110,
                                              color: Colors.grey,
                                              child: Icon(
                                                Icons.broken_image,
                                                size: 40,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextButton.icon(
                                              onPressed:
                                                  () => documentProvider
                                                      .deleteDocument(document),
                                              icon: Icon(
                                                Icons.delete,
                                                color: context.color.textColor,
                                              ),
                                              label: Flexible(
                                                child: Text(
                                                  S.of(context).delete,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: context
                                                      .textStyles
                                                      .button!
                                                      .copyWith(fontSize: 10),
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    context.color.card,
                                                shadowColor: Colors.grey[800],
                                                foregroundColor:
                                                    context.color.textColor,
                                                minimumSize: Size.zero,
                                                textStyle:
                                                    context.textStyles.button,
                                                
                                                elevation: 0,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 0,
                                                    ),
                                                alignment: Alignment.centerLeft,
                                              ),
                                            ),
                                            TextButton.icon(
                                              onPressed:
                                                  () => _showRenameDialog(
                                                    context,
                                                    document,
                                                  ),
                                              icon: Icon(
                                                Icons.edit,
                                                color: context.color.textColor,
                                              ),
                                              label: Flexible(
                                                child: Text(
                                                  S.of(context).rename,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: context
                                                      .textStyles
                                                      .button!
                                                      .copyWith(fontSize: 10),
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    context.color.card,
                                                shadowColor: Colors.grey[850],
                                                foregroundColor:
                                                    context.color.textColor,
                                                minimumSize: Size.zero,
                                                
                                                textStyle:
                                                    context.textStyles.button,
                                                elevation: 0,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 0,
                                                    ),
                                                alignment: Alignment.centerLeft,
                                              ),
                                            ),
                                            TextButton.icon(
                                              onPressed:
                                                  () => _showFullScreenImage(
                                                    context,
                                                    document.imagePath,
                                                  ),
                                              icon: Icon(
                                                Icons.visibility,
                                                color: context.color.textColor,
                                              ),
                                              label: Flexible(
                                                child: Text(
                                                  S.of(context).view,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: context
                                                      .textStyles
                                                      .button!
                                                      .copyWith(fontSize: 10),
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    context.color.card,
                                                shadowColor: Colors.grey[850],
                                                foregroundColor:
                                                    context.color.textColor,
                                                minimumSize: Size.zero,
                                                textStyle:
                                                    context.textStyles.button,
                                               
                                                elevation: 0,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 0,
                                                    ),
                                                alignment: Alignment.centerLeft,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ValueListenableBuilder<String?>(
                                        valueListenable: _sendingFilePath,
                                        builder: (context, sendingPath, _) {
                                          final isLoading =
                                              sendingPath == document.imagePath;
                                          return SizedBox(
                                            width: 36,
                                            height: 36,
                                            child: IconButton(
                                              onPressed:
                                                  isLoading
                                                      ? null
                                                      : () {
                                                        final currentDir =
                                                            context
                                                                .read<
                                                                  Directory
                                                                >();
                                                        final file = File(
                                                          p.join(
                                                            currentDir.path,
                                                            document.imagePath,
                                                          ),
                                                        );
                                                        shareDocumentAsPdf(
                                                          file.path,
                                                        );
                                                      },
                                              icon:
                                                  isLoading
                                                      ? const SizedBox(
                                                        width: 24,
                                                        height: 24,
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                      )
                                                      : Icon(
                                                        Icons.share,
                                                        color:
                                                            context
                                                                .color
                                                                .textColor,
                                                      ),
                                              padding: EdgeInsets.zero,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => documentProvider.scanDocuments(),
        backgroundColor: Colors.grey,
        child: Icon(Icons.camera_alt, color: context.color.textColor),
      ),
    );
  }
}
