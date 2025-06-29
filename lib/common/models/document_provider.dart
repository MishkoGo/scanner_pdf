import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:scanner_pdf/common/models/document.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:path/path.dart' as p;

class DocumentProvider extends ChangeNotifier {
  List<Document> _documents = [];
  List<Document> _filteredDocuments = [];
  String _searchText = '';

  List<Document> get documents => _filteredDocuments;

  DocumentProvider() {
    loadDocuments();
  }

  Future<void> loadDocuments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedDocuments = prefs.getString('documents');
    if (savedDocuments != null) {
      List<dynamic> documentList = jsonDecode(savedDocuments);
      _documents = documentList.map((doc) => Document.fromJson(doc)).toList();

      for (var doc in _documents) {
        print('Загруженный путь к файлу: ${doc.imagePath}');
      }
    }
    _filterDocuments();
  }

  Future<void> saveDocuments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonDocuments = jsonEncode(
      _documents.map((doc) => doc.toJson()).toList(),
    );
    await prefs.setString('documents', jsonDocuments);
  }

  void addDocument(Document document) {
    _documents.add(document);
    saveDocuments();
    _filterDocuments();
  }

  void deleteDocument(Document document) {
    _documents.remove(document);
    saveDocuments();
    _filterDocuments();
  }

  void renameDocument(Document document, String newName) {
    document.documentName = newName;
    saveDocuments();
    _filterDocuments();
  }

  void updateSearch(String text) {
    _searchText = text;
    _filterDocuments();
  }

  void _filterDocuments() {
    if (_searchText.isEmpty) {
      _filteredDocuments = List.from(_documents);
    } else {
      _filteredDocuments =
          _documents.where((doc) {
            return doc.documentName.toLowerCase().contains(
                  _searchText.toLowerCase(),
                ) ||
                doc.documentDate.toLowerCase().contains(
                  _searchText.toLowerCase(),
                );
          }).toList();
    }
    notifyListeners();
  }

  Future<void> scanDocuments() async {
    try {
      List<dynamic>? scannedDocuments = await FlutterDocScanner()
          .getScannedDocumentAsImages(page: 4);

      print('Полученные данные: $scannedDocuments');

      if (scannedDocuments != null && scannedDocuments.isNotEmpty) {
        
        List<String> imagePaths = scannedDocuments.cast<String>().map((e) => p.basename(e)).toList();

        for (String path in imagePaths) {

          String documentDate = DateFormat(
            'dd.MM.yyyy, HH:mm',
          ).format(DateTime.now());

          Document newDoc = Document(
            imagePath: path,
            documentName: 'New scan',
            documentDate: documentDate,
          );

          addDocument(newDoc);
        }
      }
    } on PlatformException catch (e) {
      print('Ошибка при сканировании: ${e.message}');
    }
  }
}
