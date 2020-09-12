import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:arch_bell/shared/loading.dart';
import 'package:arch_bell/shared/nothingtoshow.dart';
import 'package:arch_bell/screen/photo_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

class LectureView extends StatefulWidget {
  LectureView(this.doc, this.useryear, this.userterm);
  final useryear;
  final userterm;
  final doc;
  @override
  _LectureViewState createState() => _LectureViewState();
}

class _LectureViewState extends State<LectureView> {
  //* Lectures
  Container buildTaksItem(DocumentSnapshot doc) {
    return Container(
      width: MediaQuery.of(context).size.width <= 600
          ? MediaQuery.of(context).size.width
          : 600,
      child: Card(
          margin: EdgeInsets.all(10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            children: [
              SizedBox(height: 10),
              ListTile(
                title: Text(
                  doc.data['title'],
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                    doc.data['subTitle'] != null && doc.data['subTitle'] != ""
                        ? doc.data['subTitle']
                        : "",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
              ),
              SizedBox(width: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  doc.data['url'] != null && doc.data['url'] != ""
                      ? IconButton(
                          iconSize: 40,
                          icon: Icon(FontAwesomeIcons.firefoxBrowser),
                          onPressed: () {
                            _launchURL(doc.data['url']);
                          },
                        )
                      : Container(),
                  doc.data['url'] != null && doc.data['url'] != ""
                      ? SizedBox(width: 20)
                      : Container(),
                  doc.data['img'] != null && doc.data['img'] != ""
                      ? IconButton(
                          iconSize: 40,
                          icon: Icon(FontAwesomeIcons.solidFileImage),
                          onPressed: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new PhotoViewer(doc.data['img']),
                              ),
                            );
                          },
                        )
                      : Container(),
                  doc.data['img'] != null && doc.data['img'] != ""
                      ? SizedBox(width: 20)
                      : Container(),
                  doc.data['pdf'] != null && doc.data['pdf'] != ""
                      ? IconButton(
                          iconSize: 40,
                          icon: Icon(FontAwesomeIcons.solidFilePdf),
                          onPressed: () {
                            //* add PDF viewer
                            /*Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (BuildContext context) => new PdfViwer(),
                              ),
                            );*/
                            _launchURL(doc.data['pdf']);
                          },
                        )
                      : Container()
                ],
              ),
              SizedBox(height: 10),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.doc.data['subject'].toString(),
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'PlayfairDisplays'),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(widget.useryear)
            .document(widget.userterm)
            .collection('subject')
            .document(widget.doc.documentID)
            .collection('lectures')
            .orderBy('id', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          } else {
            return snapshot.data.documents.length == 0
                ? NoThing()
                : new ListView(
                    children: [
                      Column(
                          children: snapshot.data.documents
                              .map((doc) => buildTaksItem(doc))
                              .toList())
                    ],
                  );
          }
        },
      ),
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
