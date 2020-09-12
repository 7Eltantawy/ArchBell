import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class PdfViwer extends StatefulWidget {
  //PdfViwer(this.urlPath);
  //final urlPath;

  @override
  _PdfViwerState createState() => _PdfViwerState();
}

class _PdfViwerState extends State<PdfViwer> {
  /*bool nighmode = false;
  bool pageSnapping = false;
  bool isloading = false;

  PDFDocument document;

  @override
  void initState() {
    super.initState();

    loadfile();
  }

  loadfile() async {
    document = await PDFDocument.fromURL(
        'https://drive.google.com/u/0/uc?id=1KhM9QKNy9AiJjujT7x7nw0HAeZcFY1fO&export=pdf');

    setState(() {
      document = document;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('PDF'),
      ),
      body: Center(child: PDFViewer(document: document)),
    );
  }
}*/
  String url = "http://www.pdf995.com/samples/pdf.pdf";
  String pdfasset = "assets/sample.pdf";
  PDFDocument _doc;
  bool _loading;

  @override
  void initState() {
    super.initState();
    _initPdf();
  }

  _initPdf() async {
    setState(() {
      _loading = true;
    });
    final doc = await PDFDocument.fromURL(url);
    setState(() {
      _doc = doc;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter PDF Demo"),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : PDFViewer(
              document: _doc,
              indicatorBackground: Colors.red,
              // showIndicator: false,
              // showPicker: false,
            ),
    );
  }
}
