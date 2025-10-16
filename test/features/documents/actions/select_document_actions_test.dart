import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/documents/actions/select_document_actions.dart';

void main() {
  group('Select Document Actions Tests', () {
    group('getFileTypeColor', () {
      test('returns red color for PDF files', () {
        const filePath = 'document.pdf';
        
        final result = getFileTypeColor(filePath);
        
        expect(result, equals(Colors.red));
      });

      test('returns blue color for DOC files', () {
        const filePath = 'document.doc';
        
        final result = getFileTypeColor(filePath);
        
        expect(result, equals(Colors.blue));
      });

      test('returns blue color for DOCX files', () {
        const filePath = 'document.docx';
        
        final result = getFileTypeColor(filePath);
        
        expect(result, equals(Colors.blue));
      });

      test('returns green color for XLS files', () {
        const filePath = 'spreadsheet.xls';
        
        final result = getFileTypeColor(filePath);
        
        expect(result, equals(Colors.green));
      });

      test('returns green color for XLSX files', () {
        const filePath = 'spreadsheet.xlsx';
        
        final result = getFileTypeColor(filePath);
        
        expect(result, equals(Colors.green));
      });

      test('returns orange color for PPT files', () {
        const filePath = 'presentation.ppt';
        
        final result = getFileTypeColor(filePath);
        
        expect(result, equals(Colors.orange));
      });

      test('returns orange color for PPTX files', () {
        const filePath = 'presentation.pptx';
        
        final result = getFileTypeColor(filePath);
        
        expect(result, equals(Colors.orange));
      });

      test('returns purple color for image files', () {
        expect(getFileTypeColor('image.jpg'), equals(Colors.purple));
        expect(getFileTypeColor('image.jpeg'), equals(Colors.purple));
        expect(getFileTypeColor('image.png'), equals(Colors.purple));
        expect(getFileTypeColor('image.gif'), equals(Colors.purple));
        expect(getFileTypeColor('image.webp'), equals(Colors.purple));
      });

      test('returns teal color for audio files', () {
        expect(getFileTypeColor('audio.mp3'), equals(Colors.teal));
        expect(getFileTypeColor('audio.wav'), equals(Colors.teal));
      });

      test('returns indigo color for video files', () {
        expect(getFileTypeColor('video.mp4'), equals(Colors.indigo));
        expect(getFileTypeColor('video.avi'), equals(Colors.indigo));
        expect(getFileTypeColor('video.mov'), equals(Colors.indigo));
      });

      test('returns amber color for text files', () {
        expect(getFileTypeColor('file.txt'), equals(Colors.amber));
        expect(getFileTypeColor('file.md'), equals(Colors.amber));
        expect(getFileTypeColor('file.json'), equals(Colors.amber));
        expect(getFileTypeColor('file.xml'), equals(Colors.amber));
        expect(getFileTypeColor('file.html'), equals(Colors.amber));
        expect(getFileTypeColor('file.css'), equals(Colors.amber));
        expect(getFileTypeColor('file.js'), equals(Colors.amber));
        expect(getFileTypeColor('file.dart'), equals(Colors.amber));
        expect(getFileTypeColor('file.py'), equals(Colors.amber));
        expect(getFileTypeColor('file.java'), equals(Colors.amber));
        expect(getFileTypeColor('file.cpp'), equals(Colors.amber));
        expect(getFileTypeColor('file.c'), equals(Colors.amber));
        expect(getFileTypeColor('file.cs'), equals(Colors.amber));
        expect(getFileTypeColor('file.php'), equals(Colors.amber));
        expect(getFileTypeColor('file.rb'), equals(Colors.amber));
        expect(getFileTypeColor('file.go'), equals(Colors.amber));
        expect(getFileTypeColor('file.rs'), equals(Colors.amber));
        expect(getFileTypeColor('file.swift'), equals(Colors.amber));
        expect(getFileTypeColor('file.kt'), equals(Colors.amber));
        expect(getFileTypeColor('file.sql'), equals(Colors.amber));
        expect(getFileTypeColor('file.yaml'), equals(Colors.amber));
        expect(getFileTypeColor('file.yml'), equals(Colors.amber));
      });

      test('returns blueGrey color for unknown file types', () {
        const filePath = 'unknown.xyz';
        
        final result = getFileTypeColor(filePath);
        
        expect(result, equals(Colors.blueGrey));
      });

      test('handles file paths with multiple dots', () {
        const filePath = 'document.backup.pdf';
        
        final result = getFileTypeColor(filePath);
        
        expect(result, equals(Colors.red));
      });

      test('handles file paths without extension', () {
        const filePath = 'document';
        
        final result = getFileTypeColor(filePath);
        
        expect(result, equals(Colors.blueGrey));
      });

      test('handles empty file path', () {
        const filePath = '';
        
        final result = getFileTypeColor(filePath);
        
        expect(result, equals(Colors.blueGrey));
      });

      test('handles uppercase file extensions', () {
        expect(getFileTypeColor('document.PDF'), equals(Colors.red));
        expect(getFileTypeColor('image.JPG'), equals(Colors.purple));
        expect(getFileTypeColor('video.MP4'), equals(Colors.indigo));
      });
    });

    group('getFileTypeIcon', () {
      test('returns PDF icon for PDF files', () {
        const filePath = 'document.pdf';
        
        final result = getFileTypeIcon(filePath);
        
        expect(result, equals(Icons.picture_as_pdf));
      });

      test('returns description icon for DOC files', () {
        const filePath = 'document.doc';
        
        final result = getFileTypeIcon(filePath);
        
        expect(result, equals(Icons.description));
      });

      test('returns description icon for DOCX files', () {
        const filePath = 'document.docx';
        
        final result = getFileTypeIcon(filePath);
        
        expect(result, equals(Icons.description));
      });

      test('returns table_chart icon for XLS files', () {
        const filePath = 'spreadsheet.xls';
        
        final result = getFileTypeIcon(filePath);
        
        expect(result, equals(Icons.table_chart));
      });

      test('returns table_chart icon for XLSX files', () {
        const filePath = 'spreadsheet.xlsx';
        
        final result = getFileTypeIcon(filePath);
        
        expect(result, equals(Icons.table_chart));
      });

      test('returns slideshow icon for PPT files', () {
        const filePath = 'presentation.ppt';
        
        final result = getFileTypeIcon(filePath);
        
        expect(result, equals(Icons.slideshow));
      });

      test('returns slideshow icon for PPTX files', () {
        const filePath = 'presentation.pptx';
        
        final result = getFileTypeIcon(filePath);
        
        expect(result, equals(Icons.slideshow));
      });

      test('returns image icon for image files', () {
        expect(getFileTypeIcon('image.jpg'), equals(Icons.image));
        expect(getFileTypeIcon('image.jpeg'), equals(Icons.image));
        expect(getFileTypeIcon('image.png'), equals(Icons.image));
        expect(getFileTypeIcon('image.gif'), equals(Icons.image));
        expect(getFileTypeIcon('image.webp'), equals(Icons.image));
      });

      test('returns audiotrack icon for audio files', () {
        expect(getFileTypeIcon('audio.mp3'), equals(Icons.audiotrack));
        expect(getFileTypeIcon('audio.wav'), equals(Icons.audiotrack));
      });

      test('returns video_file icon for video files', () {
        expect(getFileTypeIcon('video.mp4'), equals(Icons.video_file));
        expect(getFileTypeIcon('video.avi'), equals(Icons.video_file));
        expect(getFileTypeIcon('video.mov'), equals(Icons.video_file));
      });

      test('returns text_fields icon for text files', () {
        expect(getFileTypeIcon('file.txt'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.md'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.json'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.xml'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.html'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.css'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.js'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.dart'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.py'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.java'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.cpp'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.c'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.cs'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.php'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.rb'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.go'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.rs'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.swift'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.kt'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.sql'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.yaml'), equals(Icons.text_fields));
        expect(getFileTypeIcon('file.yml'), equals(Icons.text_fields));
      });

      test('returns insert_drive_file icon for unknown file types', () {
        const filePath = 'unknown.xyz';
        
        final result = getFileTypeIcon(filePath);
        
        expect(result, equals(Icons.insert_drive_file));
      });

      test('handles file paths with multiple dots', () {
        const filePath = 'document.backup.pdf';
        
        final result = getFileTypeIcon(filePath);
        
        expect(result, equals(Icons.picture_as_pdf));
      });

      test('handles file paths without extension', () {
        const filePath = 'document';
        
        final result = getFileTypeIcon(filePath);
        
        expect(result, equals(Icons.insert_drive_file));
      });

      test('handles empty file path', () {
        const filePath = '';
        
        final result = getFileTypeIcon(filePath);
        
        expect(result, equals(Icons.insert_drive_file));
      });

      test('handles uppercase file extensions', () {
        expect(getFileTypeIcon('document.PDF'), equals(Icons.picture_as_pdf));
        expect(getFileTypeIcon('image.JPG'), equals(Icons.image));
        expect(getFileTypeIcon('video.MP4'), equals(Icons.video_file));
      });
    });
  });
}
