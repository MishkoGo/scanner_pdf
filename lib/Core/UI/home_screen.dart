import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scanner_pdf/Core/UI/diamond_bottom_sheet.dart';
import 'package:scanner_pdf/Core/UI/settings_bottom_sheet.dart';
import 'package:intl/intl.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:scanner_pdf/common/extension/build_context.dart';
import 'package:scanner_pdf/common/style/cubit/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class DocScannerScreen extends StatefulWidget {
  const DocScannerScreen({super.key});

  @override
  _DocScannerScreenState createState() => _DocScannerScreenState();
}

class _DocScannerScreenState extends State<DocScannerScreen> {
  List<Map<String, String>> _documents = [];
  dynamic _scannedDocuments;
  String _documentName = '';
  String _documentDate = '';
  String _imagePath = '';

  List<Map<String, String>> _filteredDocuments = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDocuments();
    _filteredDocuments = _documents;
    _searchController.addListener(_filterDocuments);
  }

  void _filterDocuments() {
    setState(() {
      _filteredDocuments = _documents
          .where((document) => document['documentName']!
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
              document['documentDate']!
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadDocuments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedDocuments = prefs.getString('documents');

    if (savedDocuments != null) {
      List<dynamic> documentList = jsonDecode(savedDocuments);
      setState(() {
        _filteredDocuments =
            documentList.map((doc) => Map<String, String>.from(doc)).toList();
      });
    }
  }

  void _saveDocument(
    String imagePath,
    String documentName,
    String documentDate,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> newDocument = {
      'imagePath': imagePath,
      'documentName': documentName,
      'documentDate': documentDate,
    };

    setState(() {
      _documents.add(newDocument);
    });
    String jsonDocuments = jsonEncode(_documents);
    await prefs.setString('documents', jsonDocuments);
  }

  void _deleteDocument(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _documents.removeAt(index);
    String jsonDocuments = jsonEncode(_documents);
    await prefs.setString('documents', jsonDocuments);

    setState(() {});
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

  Future<void> scanDocumentAsImages() async {
    dynamic scannedDocuments;
    try {
      scannedDocuments = await FlutterDocScanner().getScannedDocumentAsImages(
        page: 4,
      );
      print('Полученные данные: $scannedDocuments');

      if (scannedDocuments != null &&
          scannedDocuments['Uri'] != null &&
          scannedDocuments['Uri'].isNotEmpty) {
        setState(() {
          var imageUriString = scannedDocuments['Uri'];
          imageUriString = imageUriString
              .replaceAll(RegExp(r'\]$'), '')
              .replaceAll(RegExp(r'\}$'), '');
          int startIndex = imageUriString.indexOf('/data/');
          if (startIndex != -1) {
            _imagePath = imageUriString.substring(startIndex);
          } else {
            _imagePath = '';
          }
          _documentDate = DateFormat(
            'dd.MM.yyyy, HH:mm',
          ).format(DateTime.now());
          _documentName = 'New scan';
          _saveDocument(_imagePath, _documentName, _documentDate);
        });
      } else {
        setState(() {
          _scannedDocuments = 'Нет документов';
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        _scannedDocuments = 'Ошибка при сканировании: ${e.message}';
      });
    }
  }

  void _shareDocument(String imagePath) async {
    if (imagePath.isNotEmpty) {
      try {
        await Share.shareXFiles([XFile(imagePath)], text: 'Вот документ');
      } catch (e) {
        print('Ошибка при отправке: $e');
      }
    } else {
      print('Изображение не найдено');
    }
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

  void _saveDocuments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonDocuments = jsonEncode(_documents);
    await prefs.setString('documents', jsonDocuments);
  }

  void _renameDocument(int index) {
    TextEditingController _controller = TextEditingController(
      text: _documents[index]['documentName'],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Переименовать документ"),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Введите новое имя документа",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Отмена"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _documents[index]['documentName'] = _controller.text;
                  _saveDocuments();
                });
                Navigator.of(context).pop();
              },
              child: const Text("Сохранить"),
            ),
          ],
        );
      },
    );
  }

  void _showFullScreenImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Center(
              child: Image.file(File(imagePath), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: context.color.surface,
      appBar: AppBar(
        backgroundColor: context.color.appHeader,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.diamond, color: context.color.textColor),
          onPressed: () => _showDiamondBottomSheet(context),
        ),
        title: Text('Документы', style: context.textStyles.body),
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
                style: TextStyle(color: context.color.card),
                controller: _searchController,
                decoration: InputDecoration(
                  fillColor: context.color.card,
                  hintText: 'Введите название документа',
                  hintStyle: TextStyle(color: context.color.textColor),
                  prefixIcon: Icon(
                    Icons.search,
                    color: context.color.textColor,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
                onChanged: (text) {
                  setState(() {
                    _documentName = text;
                  });
                },
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredDocuments.length,
                itemBuilder: (context, index) {
                  var document = _filteredDocuments[index];
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
                            '${document['documentName']} - ${document['documentDate']}',
                            style: context.textStyles.h1,
                          ),

                          Row(
                            children: [
                              Image.file(
                                File(document['imagePath']!),
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  TextButton.icon(
                                    onPressed: () => _deleteDocument(index),
                                    icon: Icon(
                                      Icons.delete,
                                      color: context.color.textColor,
                                    ),
                                    label: Text('Удалить'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: context.color.card,
                                      shadowColor: Colors.grey[850],
                                      foregroundColor: context.color.textColor,
                                      textStyle: context.textStyles.button,
                                      elevation: 0,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 0,
                                      ),
                                    ),
                                  ),

                                  TextButton.icon(
                                    onPressed: () => _renameDocument(index),
                                    icon: Icon(
                                      Icons.edit,
                                      color: context.color.textColor,
                                    ),
                                    label: Text('Переименовать'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: context.color.card,
                                      shadowColor: Colors.grey[850],
                                      foregroundColor: context.color.textColor,
                                      elevation: 0,
                                      textStyle: context.textStyles.button,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 0,
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed:
                                        () => _showFullScreenImage(
                                          context,
                                          document['imagePath']!,
                                        ),
                                    icon: Icon(
                                      Icons.visibility,
                                      color: context.color.textColor,
                                    ),
                                    label: Text('Просмотреть'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: context.color.card,
                                      shadowColor: Colors.grey[850],
                                      foregroundColor: context.color.textColor,
                                      textStyle: TextStyle(fontSize: 13),
                                      elevation: 0,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed:
                                        () => _shareDocument(
                                          document['imagePath']!,
                                        ),
                                    icon: Icon(
                                      Icons.share,
                                      color: context.color.textColor,
                                    ),
                                  ),
                                ],
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
            const SizedBox(height: 24),
            if (_scannedDocuments != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    'Результат: \n${_scannedDocuments.toString()}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scanDocumentAsImages,
        backgroundColor: Colors.grey,
        child: Icon(Icons.camera_alt, color: context.color.textColor),
      ),
    );
  }
}
