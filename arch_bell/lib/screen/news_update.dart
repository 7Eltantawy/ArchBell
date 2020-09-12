import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:stringprocess/stringprocess.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsUpdate extends StatefulWidget {
  NewsUpdate(this.id, this.title, this.subtitle, this.pubImg, this.pubName,
      this.date, this.readtime, this.imgs, this.body, this.password);

  final id;
  final title;
  final subtitle;
  final pubImg;
  final pubName;
  final date;
  final readtime;
  final imgs;
  final body;
  final password;
  @override
  _NewsUpdateState createState() => _NewsUpdateState();
}

class _NewsUpdateState extends State<NewsUpdate>
    with SingleTickerProviderStateMixin {
  String id;
  final db = Firestore.instance;
  TabController _controller;
  bool autoVailidate = false;

  //*
  TextEditingController pubNameController;
  TextEditingController pubImgController;
  TextEditingController titleController;
  TextEditingController subtitleController;
  TextEditingController imgsController;
  TextEditingController bodyController;
  TextEditingController passwordController;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    pubNameController = TextEditingController(text: widget.pubName);
    pubImgController = TextEditingController(text: widget.pubImg);
    titleController = TextEditingController(text: widget.title);
    subtitleController = TextEditingController(text: widget.subtitle);
    imgsController = TextEditingController(text: widget.imgs);
    bodyController = TextEditingController(text: widget.body);
    passwordController = TextEditingController(text: widget.password);
  }

  String pubname = "";
  String pubimg = "";
  String title = "";
  String text = "";
  String timestamp = "";

  //* Keys
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void updateData() async {
    if (_formKey.currentState.validate()) {
      final snackBar = SnackBar(content: LinearProgressIndicator());
      _scaffoldKey.currentState.showSnackBar(snackBar);

      await db.collection('Article').document(widget.id).updateData(
        {
          'time': DateTime.now().millisecondsSinceEpoch.toString(),
          'pubName': pubNameController.text,
          'pubImg': pubImgController.text,
          'title': titleController.text,
          'subtitle': subtitleController.text,
          'imgs': imgsController.text,
          'body': bodyController.text,
          'password': passwordController.text
        },
      );

      _showSnackbar("Updated Successfully");
    }
  }

  // Method to show snackbar with 'message'.
  _showSnackbar(String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    //int timeInMillis = DateTime.now().millisecondsSinceEpoch;
    //var unformatdate = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
    //var date = DateFormat.yMMMMEEEEd().format(unformatdate);
    //DateTime now = DateTime.now();
    //String date = DateFormat('yyyy-MM-dd  kk:mm ').format(now);
    String date = DateFormat('kk:mm ').format(DateTime.now()) +
        " " +
        DateFormat.yMMMMEEEEd()
            .format(DateTime.fromMillisecondsSinceEpoch(
                DateTime.now().millisecondsSinceEpoch))
            .toString();
//*read time
    StringProcessor tps = new StringProcessor();
    int readCount = tps.getWordCount(text);
    double readtimeTotal = readCount / 200;
    int readtimeMin = readtimeTotal.toInt();
    int readtimeSec = text == ""
        ? 0
        : ((int.tryParse(
                    readtimeTotal.toString().split('.')[1].substring(0, 2))) *
                .6)
            .toInt();

    String readtime;
    if (readtimeMin != 0 && readtimeSec != 0) {
      readtime = '$readtimeMin' + " Min" + ' $readtimeSec' + " Sec" + "  Read";
    } else if (readtimeMin != 0 && readtimeSec == 0) {
      readtime = '$readtimeMin' + " Min" + "  Read";
    } else if (readtimeMin == 0 && readtimeSec != 0) {
      readtime = '$readtimeSec' + " Sec" + "  Read";
    } else {
      readtime = "Very short time";
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Update Article",
          style: TextStyle(fontFamily: 'PlayfairDisplays'),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: "update",
            icon: Icon(Icons.cloud_upload),
            onPressed: updateData,
          ),
        ],
        bottom:
            TabBar(controller: _controller, indicatorColor: Colors.blue, tabs: [
          Tab(
            child: Text("Rules"),
          ),
          Tab(
            child: Text("Edit"),
          ),
          Tab(
            child: Text("Preview"),
          ),
        ]),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          //////////////////////////////////////////////////////////////////////
          ////* MarkDown tab */
          Scaffold(
            body: new FutureBuilder(
                future: rootBundle.loadString("assets/hello.md"),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    return Markdown(
                        styleSheet: MarkdownStyleSheet(
                          blockquoteDecoration:
                              BoxDecoration(color: Colors.blue),
                          blockquote: TextStyle(color: Colors.white),
                          tableHead: TextStyle(fontSize: 20),
                          p: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        selectable: true,
                        data: snapshot.data);
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
          //////////////////////////////////////////////////////////////////////
          ////* Write tab */
          Scaffold(
            body: ListView(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 10),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              pubimg != "" ? pubimg : widget.pubImg),
                          child: widget.pubImg != ""
                              ? null
                              : pubimg != "" ? null : Icon(Icons.person),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: pubNameController,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please Enter your name';
                              } else if (val.length < 3) {
                                return 'Your Name is too short';
                              }
                              return null;
                            },
                            onChanged: (String pubname) {
                              setState(() {
                                this.pubname = pubname;
                              });
                            },
                            maxLength: 25,
                            decoration: InputDecoration(
                              labelText: 'Publisher name',
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Publisher Image',
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                            controller: pubImgController,
                            onChanged: (String pubimg) {
                              setState(() {
                                this.pubimg = pubimg;
                              });
                            },
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Article Title',
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                            controller: titleController,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please Fill';
                              }
                              return null;
                            },
                            onChanged: (String title) {
                              setState(() {
                                this.title = title;
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Article Subitle',
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                            controller: subtitleController,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please Fill';
                              }
                              return null;
                            },
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Article Main Img',
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                            controller: imgsController,
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: bodyController.text == ""
                                  ? 'Article Body'
                                  : readtime,
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            controller: bodyController,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please Fill';
                              }
                              return null;
                            },
                            onChanged: (String text) {
                              setState(() {
                                this.text = text;
                              });
                            },
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Article Password',
                              hintText:
                                  "Please don't enter sensetive passsword",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please Fill';
                              } else if (val.length < 4) {
                                return 'Password must be more than 3';
                              }
                              return null;
                            },
                            textAlign: TextAlign.center,
                            controller: passwordController,
                          ),
                        ),
                        SizedBox(height: 20),
                        //Image.network(
                        //  widget.img,
                        //  loadingBuilder: (context, child, loadingProgress) {
                        //    return loadingProgress == null
                        //        ? child
                        //        : LinearProgressIndicator();
                        //  },
                        //),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /////////////////////////////////////////////////////////////////////
          //* View tab */
          Scaffold(
            body: new ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      /////////////////
                      //* Circle avatar */
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                                pubimg != "" ? pubimg : widget.pubImg),
                            child: widget.pubImg != ""
                                ? null
                                : pubimg != "" ? null : Icon(Icons.person),
                          ),
                          SizedBox(width: 7),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                pubname != "" ? pubname : widget.pubName,
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                date + " - " + readtime,
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      SelectableText(
                        title != "" ? title : widget.title,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PlayfairDisplays'),
                      ),

                      SizedBox(height: 15),
                      /////////////////////////////////////////////////////////
                      //* Body */

                      Container(
                        child: MarkdownBody(
                          styleSheet: MarkdownStyleSheet(
                            blockquoteDecoration:
                                BoxDecoration(color: Colors.blue),
                            blockquote: TextStyle(color: Colors.white),
                            tableHead: TextStyle(fontSize: 20),
                            p: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          selectable: true,
                          data: text != "" ? text : widget.body,
                          onTapLink: (link) {
                            _launchURL(link);
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        child: null,
                      ),
                      SizedBox(height: 15),
                      Divider(),
                      Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                  pubimg != "" ? pubimg : widget.pubImg),
                              child: widget.pubImg != ""
                                  ? null
                                  : pubimg != "" ? null : Icon(Icons.person),
                            ),
                            SizedBox(width: 7),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "WRITTEN BY",
                                  style: TextStyle(fontSize: 10),
                                ),
                                Text(
                                  pubname != "" ? pubname : widget.pubName,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //////////////////////////////////////////////////////////////////////
        ],
      ),
    );
  }
}

divider(String text) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Container(height: 2, width: 70, color: Colors.blue),
        SizedBox(width: 20),
        Text(
          text,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        SizedBox(width: 20),
        Container(height: 2, width: 70, color: Colors.blue),
      ],
    ),
  );
}

_launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
