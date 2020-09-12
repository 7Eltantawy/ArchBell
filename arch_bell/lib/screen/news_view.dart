import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:arch_bell/shared/nothingtoshow.dart';
import 'package:arch_bell/screen/news_update.dart';
import 'package:arch_bell/screen/photo_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsViewer extends StatefulWidget {
  NewsViewer(
      this.readtimeTotalSec,
      this.id,
      this.title,
      this.subtitle,
      this.pubImg,
      this.pubName,
      this.date,
      this.readtime,
      this.views,
      this.imgs,
      this.body,
      this.password);
  final readtimeTotalSec;
  final id;
  final title;
  final subtitle;
  final pubImg;
  final pubName;
  final date;
  final readtime;
  final views;
  final imgs;
  final body;
  final password;

  @override
  _NewsViewerState createState() => _NewsViewerState();
}

class _NewsViewerState extends State<NewsViewer> {
  final _formKeyComment = GlobalKey<FormState>();
  String username = "";
  String userimg = "";
  TextEditingController userNameController = TextEditingController();
  TextEditingController userImgController = TextEditingController();
  TextEditingController userCommentController = TextEditingController();
  //* SharedPreferences
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  //* Load Crediaents
  Future getData() async {
    final SharedPreferences prefs = await _sprefs;
    //* get userimg
    if (prefs.getString('userImg') == null) {
      prefs.setString('userImg', "");
    } else {
      this.setState(() {
        userimg = ((prefs.getString('userImg')));
        userImgController = TextEditingController(text: userimg);
      });
    }

    //* get username
    if (prefs.getString('userName') == null) {
      prefs.setString('userName', "");
    } else {
      this.setState(() {
        username = ((prefs.getString('userName')));
        userNameController = TextEditingController(text: username);
      });
    }
  }

//* set timer to add views
  Timer _timer;
  void startTimer() {
    _timer = new Timer.periodic(
      Duration(
          seconds:
              widget.readtimeTotalSec == 0 || widget.readtimeTotalSec == null
                  ? 1
                  : widget.readtimeTotalSec),
      (Timer timer) => setState(
        () {
          addViews();
        },
      ),
    );
  }

//* to cancel timer onpress back
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

//* call timer on open
  void initState() {
    super.initState();
    getData();
    startTimer();
    //* this was ashort method to add view but onpress back the time still active
    /* Timer(
      Duration(seconds: widget.readtimeTotalSec),
      () {
        addView();
      },
    );*/
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _showSnackbar(String message, Color color) {
    final snackBar = SnackBar(
      duration: Duration(milliseconds: 0),
      backgroundColor: color,
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    );
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  //* Firebase CURD
  final db = Firestore.instance;
  //* delete article
  void deleteData() async {
    await db.collection('Article').document(widget.id).delete();
    //print("deleted");
    _showSnackbar("Deleted Successfully", Colors.blue);
  }

  //* addviews
  void addViews() async {
    await db.collection('Article').document(widget.id).updateData(
      {'views': widget.views + 1},
    );
  }

  //* add Comment
  addComment() async {
    String commentCheck =
        userCommentController.text.replaceAll(new RegExp(r"\s+"), "");
    if (_formKeyComment.currentState.validate() &&
        username != null &&
        username != "" &&
        commentCheck != "" &&
        commentCheck != null) {
      await Firestore.instance
          .document('Article/' + widget.id)
          .collection('comments')
          .add(
        {
          'name': username,
          'img': userimg,
          'time': DateTime.now().millisecondsSinceEpoch.toString(),
          'comment': userCommentController.text,
        },
      );
      setState(() {
        userCommentController = TextEditingController(text: "");
      });
    } else if (username == null || username == "") {
      _showSnackbar("Enter Your name", Colors.orange);
    } else if (commentCheck == "") {
      setState(() {
        userCommentController = TextEditingController(text: "");
      });
    }
  }

  TextEditingController passwordController = TextEditingController();
  //* Choose & Edit % delete Dialogs
  _showPasswordDialog() async {
    DocumentSnapshot snapshotAdminYear1 =
        await db.collection('ADMIN').document('Eltantawy').get();
    String eltantawy = snapshotAdminYear1.data['password'];
    await showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text("Article Password"),
        content: Column(
          children: [
            SizedBox(height: 10),
            CupertinoTextField(
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
              controller: passwordController,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                _scaffoldKey.currentState.hideCurrentSnackBar();
              },
              child: Text("CANCEL", style: TextStyle(color: Colors.white))),
          CupertinoDialogAction(
            child: Text("ENTER", style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (passwordController.text == widget.password ||
                  passwordController.text == eltantawy) {
                _showSnackbar("", Colors.green);
                Navigator.pop(context);
                _showEditDialog();
              } else if ((passwordController.text).isEmpty) {
                _showSnackbar("Enter The Password", Colors.orange);
              } else if (passwordController.text.length <= 3) {
                _showSnackbar(
                    "The Password must be more than 3 char", Colors.orange);
              } else {
                _showSnackbar("Wrong Password", Colors.red);
              }
            },
          ),
        ],
      ),
    );
  }

  _showEditDialog() async {
    await showDialog<String>(
        context: context,
        child: new CupertinoAlertDialog(title: Text("Article"), actions: [
          CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                _showDeleteConfirmDialog();
              },
              child: Text("DELETE", style: TextStyle(color: Colors.white))),
          CupertinoDialogAction(
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) => new NewsUpdate(
                      widget.id,
                      widget.title,
                      widget.subtitle,
                      widget.pubImg,
                      widget.pubName,
                      widget.date,
                      widget.readtime,
                      widget.imgs,
                      widget.body,
                      widget.password,
                    ),
                  ),
                );
              },
              child: Text("EDIT", style: TextStyle(color: Colors.white))),
        ]));
  }

  _showDeleteConfirmDialog() async {
    await showDialog<String>(
        context: context,
        child:
            new CupertinoAlertDialog(title: Text("Confirm Delete"), actions: [
          CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("NO", style: TextStyle(color: Colors.white))),
          CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                deleteData();
              },
              child: Text("YES", style: TextStyle(color: Colors.white))),
        ]));
  }

  ListTile buildCommentItem(DocumentSnapshot doc) {
    //* parse time fromMillisecondsSinceEpoch to normal date
    int timeInt = int.parse(doc.data['time'].toString());
    String date = DateFormat.MMMEd()
            .format(DateTime.fromMillisecondsSinceEpoch(timeInt))
            .toString() +
        " - " +
        DateFormat.Hms()
            .format(DateTime.fromMillisecondsSinceEpoch(timeInt))
            .toString();

    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(doc.data['name'].toString()),
          Text(
            date,
            style: TextStyle(fontSize: 10),
          ),
        ],
      ),
      subtitle: SelectableText(
        doc.data['comment'].toString(),
        cursorColor: Colors.blue,
      ),
      leading: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new PhotoViewer(
                    doc.data['img'] != '' && doc.data['img'] != null
                        ? doc.data['img']
                        : "")),
          );
        },
        child: CircleAvatar(
          radius: 20,
          backgroundImage: doc.data['img'] != '' && doc.data['img'] != null
              ? NetworkImage(doc.data['img'])
              : AssetImage(
                  "assets/avatar.jpg",
                ),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String dateView;
    if (widget.readtime == "") {
      dateView = widget.date;
    } else {
      dateView = widget.date + " - " + widget.readtime;
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(fontFamily: 'PlayfairDisplays'),
        ),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.edit),
            onPressed: _showPasswordDialog,
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new PhotoViewer(widget.pubImg != '' ||
                                          widget.pubImg != null
                                      ? widget.pubImg
                                      : "")),
                        );
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(widget.pubImg),
                        child: widget.pubImg != ""
                            ? null
                            : Image.asset("assets/avatar.jpg"),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    SizedBox(width: 7),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.pubName, style: TextStyle(fontSize: 20)),
                        Text(dateView, style: TextStyle(fontSize: 10)),
                        Row(
                          children: [
                            Icon(FontAwesomeIcons.eye, size: 10),
                            SizedBox(width: 5),
                            Text((widget.views).toString(),
                                style: TextStyle(fontSize: 7))
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SelectableText(
                  widget.title,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PlayfairDisplays'),
                ),
                SizedBox(height: 15),
                widget.body == ''
                    ? NoThing()
                    : MarkdownBody(
                        data: widget.body,
                        selectable: true,
                        styleSheet: MarkdownStyleSheet(
                          blockquoteDecoration:
                              BoxDecoration(color: Colors.blue),
                          blockquote: TextStyle(color: Colors.white),
                          tableHead: TextStyle(fontSize: 20),
                          p: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        onTapLink: (link) {
                          _launchURL(link);
                        },
                      ),
                SizedBox(height: 15),
                //* Comments
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('Article')
                      .document(widget.id)
                      .collection('comments')
                      .orderBy('time', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      // return Loading();
                      return Container();
                    } else {
                      return Column(
                          children: snapshot.data.documents
                              .map((doc) => buildCommentItem(doc))
                              .toList());
                    }
                  },
                ),
                SizedBox(height: 15),
                ListTile(
                  title: Text(username),
                  subtitle: Column(
                    children: [
                      SizedBox(height: 10),
                      Form(
                        key: _formKeyComment,
                        child: TextFormField(
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Please Write your Comment';
                            }
                            return null;
                          },
                          controller: userCommentController,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: "Add Comment",
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            suffixIcon: IconButton(
                                icon: Icon(FontAwesomeIcons.plus),
                                onPressed: () {
                                  //*
                                  addComment();
                                }),
                            //isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            filled: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) => new PhotoViewer(
                                userimg != '' && userimg != null
                                    ? userimg
                                    : "")),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: userimg != '' && userimg != null
                          ? NetworkImage(userimg)
                          : AssetImage(
                              "assets/avatar.jpg",
                            ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),

                SizedBox(height: 15),
                Divider(),
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new PhotoViewer(widget.pubImg != '' ||
                                            widget.pubImg != null
                                        ? widget.pubImg
                                        : "")),
                          );
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(widget.pubImg),
                          child: widget.pubImg != ""
                              ? null
                              : Image.asset("assets/avatar.jpg"),
                          backgroundColor: Colors.transparent,
                        ),
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
                            widget.pubName,
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
    );
  }
}

_launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
