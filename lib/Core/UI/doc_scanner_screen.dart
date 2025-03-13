import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner_pdf/Core/UI/diamond_bottom_sheet.dart';
import 'package:scanner_pdf/Core/UI/settings_bottom_sheet.dart';
import 'package:scanner_pdf/common/extension/build_context.dart';
import 'package:scanner_pdf/common/models/document.dart';
import 'package:scanner_pdf/common/models/document_provider.dart';
import 'package:scanner_pdf/common/style/cubit/theme_cubit.dart';
import 'package:scanner_pdf/generated/l10n.dart';
import 'package:scanner_pdf/l10n/l10n.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class DocScannerScreen extends StatelessWidget {
  const DocScannerScreen({Key? key}) : super(key: key);

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
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: Image.file(File(imagePath), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }

  Future<void> shareDocumentAsPdf(String imagePath) async {
    if (imagePath.isNotEmpty) {
      try {
        // Проверяем, существует ли файл изображения
        final imageFile = File(imagePath);
        if (!await imageFile.exists()) {
          print('Изображение не найдено');
          return;
        }

        // Читаем байты изображения
        final imageBytes = await imageFile.readAsBytes();

        // Создаём PDF-документ
        final pdf = pw.Document();
        final pdfImage = pw.MemoryImage(imageBytes);

        // Добавляем страницу с изображением в качестве фонового
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Container(
                width: double.infinity,
                height: double.infinity,
                decoration: pw.BoxDecoration(
                  image: pw.DecorationImage(
                    image: pdfImage,
                    fit: pw.BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        );

        // Получаем путь для сохранения PDF (например, во временной папке)
        final tempDir = await getTemporaryDirectory();
        final pdfPath =
            '${tempDir.path}/document_${DateTime.now().millisecondsSinceEpoch}.pdf';

        // Сохраняем PDF-файл
        final pdfFile = File(pdfPath);
        await pdfFile.writeAsBytes(await pdf.save());

        // Отправляем PDF-файл
        await Share.shareXFiles([XFile(pdfPath)], text: 'Вот документ');
      } catch (e) {
        print('Ошибка при отправке PDF: $e');
      }
    } else {
      print('Изображение не найдено');
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
        padding: const EdgeInsets.all(16.0),
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
                  contentPadding: const EdgeInsets.all(12),
                ),
                onChanged: (text) {
                  documentProvider.updateSearch(text);
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final document = documents[index];
                  return Card(
                    color: context.color.card,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${document.documentName} - ${document.documentDate}',
                            style: context.textStyles.h1,
                          ),
                          Row(
                            children: [
                              Image.file(
                                File(document.imagePath),
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextButton.icon(
                                    onPressed:
                                        () => documentProvider.deleteDocument(
                                          document,
                                        ),
                                    icon: Icon(
                                      Icons.delete,
                                      color: context.color.textColor,
                                    ),
                                    label: Text(S.of(context).delete),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: context.color.card,
                                      shadowColor: Colors.grey[850],
                                      foregroundColor: context.color.textColor,
                                      textStyle: context.textStyles.button,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 0,
                                      ),
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
                                    label: Text(S.of(context).rename),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: context.color.card,
                                      shadowColor: Colors.grey[850],
                                      foregroundColor: context.color.textColor,
                                      elevation: 0,
                                      textStyle: context.textStyles.button,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 0,
                                      ),
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
                                    label: Text(S.of(context).view),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: context.color.card,
                                      shadowColor: Colors.grey[850],
                                      foregroundColor: context.color.textColor,
                                      textStyle: const TextStyle(fontSize: 13),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 9),
                              IconButton(
                                onPressed:
                                    () => shareDocumentAsPdf(document.imagePath),
                                icon: Icon(
                                  Icons.share,
                                  color: context.color.textColor,
                                ),
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
