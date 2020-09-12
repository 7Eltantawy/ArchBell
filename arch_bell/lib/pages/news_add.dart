import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stringprocess/stringprocess.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsAdd extends StatefulWidget {
  @override
  _NewsAddState createState() => _NewsAddState();
}

class _NewsAddState extends State<NewsAdd> with SingleTickerProviderStateMixin {
  String id;
  final db = Firestore.instance;
  TabController _controller;
  bool autoVailidate = false;

  TextEditingController pubNameController = TextEditingController();
  TextEditingController pubImgController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController imgsController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //* Firebase Curd
  void createData() async {
    if (_formKey.currentState.validate()) {
      final snackBar = SnackBar(content: LinearProgressIndicator());
      _scaffoldKey.currentState.showSnackBar(snackBar);
      DocumentReference ref = await db.collection('Article').add(
        {
          'time': DateTime.now().millisecondsSinceEpoch.toString(),
          'pubName': pubNameController.text,
          'pubImg': pubImgController.text,
          'title': titleController.text,
          'subtitle': subtitleController.text,
          'imgs': imgsController.text,
          'body': descriptionController.text,
          'password': passwordController.text
        },
      );
      setState(() => id = ref.documentID);
      //print(ref.documentID);
      _showSnackbar("Published Successfully");
    }
  }

  //*  ///////////////////

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
        pubimg = ((prefs.getString('userImg')));
        pubImgController = TextEditingController(text: pubimg);
      });
    }

    //* get username
    if (prefs.getString('userName') == null) {
      prefs.setString('userName', "Publisher Name");
    } else {
      this.setState(() {
        pubname = ((prefs.getString('userName')));
        pubNameController = TextEditingController(text: pubname);
      });
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

  String pubimg = "";
  String pubname = "Publisher Name";
  String timestamp = "";
  String title = "Mars Planet Default article";
  String text = """
  # Mars Planet
  ---
  
  ![](http://pngimg.com/uploads/mars_planet/mars_planet_PNG11.png)


  ## Watch Youtube video
  ---
  [![](https://img.shields.io/badge/Watch-YotubeVideo-red.png)](https://www.youtube.com/watch?v=D8pnmwOXhoY) 

  """;

  @override
  void initState() {
    super.initState();
    getData();
    _controller = TabController(length: 3, vsync: this);
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
          "Write Article",
          style: TextStyle(fontFamily: 'PlayfairDisplays'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: createData,
          ),
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: Colors.blue,
          tabs: [
            Tab(
              child: Text("Rules"),
            ),
            Tab(
              child: Text("Write"),
            ),
            Tab(
              child: Text("Preview"),
            ),
          ],
        ),
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
                        blockquoteDecoration: BoxDecoration(color: Colors.blue),
                        blockquote: TextStyle(color: Colors.white),
                        tableHead: TextStyle(fontSize: 20),
                        p: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      selectable: true,
                      data: snapshot.data,
                      onTapLink: (link) {
                        _launchURL(link);
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
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
                        SizedBox(height: 15),
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(pubimg),
                          child: pubimg != ""
                              ? null
                              : Image.asset("assets/avatar.jpg"),
                          backgroundColor: Colors.transparent,
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
                              labelText: descriptionController.text == ""
                                  ? 'Article Body'
                                  : readtime,
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            controller: descriptionController,
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
          //* View tab
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
                            backgroundImage: NetworkImage(pubimg),
                            child: pubimg != ""
                                ? null
                                : Image.asset("assets/avatar.jpg"),
                            backgroundColor: Colors.transparent,
                          ),
                          SizedBox(width: 7),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                pubname,
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
                        title,
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
                          data: text,
                          onTapLink: (link) {
                            _launchURL(link);
                          },
                        ),
                      ),
                      SizedBox(height: 15),

                      SizedBox(height: 15),
                      Divider(),
                      Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(pubimg),
                              child: pubimg != ""
                                  ? null
                                  : Image.asset("assets/avatar.jpg"),
                              backgroundColor: Colors.transparent,
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
                                  pubname,
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

          /////////////////////////////////////////////////////////////////////
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
