import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:arch_bell/shared/loading.dart';
import 'package:arch_bell/shared/nothingtoshow.dart';
import 'package:arch_bell/screen/admin.dart';
import 'package:arch_bell/screen/lecture_view.dart';
import 'package:arch_bell/pages/news_add.dart';
import 'package:arch_bell/screen/news_view.dart';
import 'package:arch_bell/screen/tasks_view.dart';
import 'package:arch_bell/pages/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stringprocess/stringprocess.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  //* firebase CURD

  String id;
  final db = Firestore.instance;
  StringProcessor tps = new StringProcessor();
  TextEditingController searchController = TextEditingController();
  String search = "";
  bool isSearching = false;

  int tabNum;
  String username = "";
  String userimg = "";
  String useryear = "Year1";
  String userterm = "term1";
  bool y1 = false;
  bool y2 = false;
  bool y3 = false;
  bool y4 = false;
  bool t1 = false;
  bool t2 = false;
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
      });
    }

    //* get username
    if (prefs.getString('userName') == null) {
      prefs.setString('userName', "");
    } else {
      this.setState(() {
        username = ((prefs.getString('userName')));
      });
    }
    //* get useryear
    if (prefs.getString('userYear') == null) {
      prefs.setString('userYear', "Year1");
    } else {
      this.setState(() {
        useryear = ((prefs.getString('userYear')));
        if (useryear == "Year1") {
          y1 = true;
        } else if (useryear == "Year2") {
          y2 = true;
        } else if (useryear == "Year3") {
          y3 = true;
        } else if (useryear == "Year4") {
          y4 = true;
        }
      });
    }
    //* get userterm
    if (prefs.getString('userTerm') == null) {
      prefs.setString('userTerm', "term1");
    } else {
      this.setState(() {
        userterm = ((prefs.getString('userTerm')));
        if (userterm == "term1") {
          t1 = true;
        } else if (userterm == "term2") {
          t2 = true;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    _controller = TabController(length: 3, vsync: this);

    tabNum = _controller.index;
    //print("tabNum " + tabNum.toString());

    //print("tabNum: " + tabNum.toString());
  }

  //* Card build ////////////////////////////////////////

  //* Subject
  GestureDetector buildSubjectItem(DocumentSnapshot doc) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (BuildContext context) =>
                  new LectureView(doc, useryear, userterm),
            ),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width <= 600
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width <= 900
                  ? (MediaQuery.of(context).size.width - 30) / 2
                  : MediaQuery.of(context).size.width <= 1200
                      ? (MediaQuery.of(context).size.width - 40) / 3
                      : (MediaQuery.of(context).size.width - 50) / 4,
          //margin: EdgeInsets.all(10),
          // color: Colors.blue,
          // height: 150,
          // width: MediaQuery.of(context).size.width - 20,
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 140,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    image: DecorationImage(
                        image:
                            doc.data['imgs'] != '' && doc.data['imgs'] != null
                                ? NetworkImage(
                                    doc.data['imgs'],
                                  )
                                : AssetImage(
                                    "assets/no.jpg",
                                  ),
                        fit: BoxFit.cover)),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 140,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      doc.data['subject'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          fontFamily: 'PlayfairDisplays'),
                    ),
                    Text(
                      doc.data['dr'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  //* Tasks
  GestureDetector buildTaksItem(DocumentSnapshot doc) {
    return GestureDetector(
      onTap: () {
        //add code
        // print("Doc ID: " + doc.documentID);
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) =>
                new TaskView(doc, useryear, userterm),
          ),
        );
      },
      child: Container(
        //margin: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width <= 600
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width <= 900
                ? (MediaQuery.of(context).size.width - 30) / 2
                : MediaQuery.of(context).size.width <= 1200
                    ? (MediaQuery.of(context).size.width - 40) / 3
                    : (MediaQuery.of(context).size.width - 50) / 4,
        // color: Colors.blue,
        // height: 150,
        // width: MediaQuery.of(context).size.width - 20,
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 140,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(
                      image: doc.data['img'] != '' && doc.data['img'] != null
                          ? NetworkImage(
                              doc.data['img'],
                            )
                          : AssetImage(
                              "assets/no.jpg",
                            ),
                      fit: BoxFit.cover)),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 140,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    doc.data['week'].toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        fontFamily: 'PlayfairDisplays'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //* News
  InkWell buildNewsItem(DocumentSnapshot doc) {
    //*read time
    StringProcessor tps = new StringProcessor();
    int readCount = tps.getWordCount(doc.data['body'].toString());
    double readtimeTotal = readCount / 200;
    int readtimeTotalSec = ((readCount / 200) * 60).toInt();
    int readtimeMin = readtimeTotal.toInt();
    int readtimeSec = doc.data['body'].toString() == ""
        ? 0
        : ((int.tryParse(
                    readtimeTotal.toString().split('.')[1].substring(0, 2))) *
                .6)
            .toInt();
    //*  article reading time
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
    //* parse time fromMillisecondsSinceEpoch to normal date
    int timeInt = int.parse(doc.data['time']);
    String date = DateFormat.MMMEd()
        .format(DateTime.fromMillisecondsSinceEpoch(timeInt))
        .toString();
    //
    int views;

    if (doc.data['views'] != "" && doc.data['views'] != null) {
      views = int.parse(doc.data['views'].toString());
    } else {
      views = 0;
    }

    return InkWell(
      onTap: () {
        //add code

        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) => new NewsViewer(
                readtimeTotalSec,
                doc.documentID,
                doc.data['title'].toString(),
                doc.data['subtitle'].toString(),
                doc.data['pubImg'],
                doc.data['pubName'].toString(),
                date,
                readtime,
                views,
                doc.data['imgs'],
                doc.data['body'].toString(),
                doc.data['password'].toString()),
          ),
        );
      },
      child: Container(
        // width: double.infinity,
        width: MediaQuery.of(context).size.width <= 600
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width <= 900
                ? (MediaQuery.of(context).size.width - 30) / 2
                : (MediaQuery.of(context).size.width - 40) / 3,
        height: 140,
        //margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 90,
              height: 140,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(
                      image: doc.data['imgs'] != '' && doc.data['imgs'] != null
                          ? NetworkImage(
                              doc.data['imgs'],
                            )
                          : AssetImage(
                              "assets/no.jpg",
                            ),
                      fit: BoxFit.cover)),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    doc.data['title'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'PlayfairDisplays'),
                  ),
                  SizedBox(height: 4),
                  Text(
                    doc.data['subtitle'].toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: 2),
                  Text(
                    readtime,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 10),
                  ),
                  Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: doc.data['pubImg'] != '' &&
                                doc.data['pubImg'] != null
                            ? NetworkImage(doc.data['pubImg'])
                            : AssetImage(
                                "assets/avatar.jpg",
                              ),
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(width: 5),
                      Center(
                        child: Text(
                          doc.data['pubName'].toString(),
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      Spacer(),
                      Center(
                        child: Text(
                          date,
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  //* /////////////////////////////////////////////////

  TabController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          tooltip: username + "\n" + useryear + " " + userterm,
          icon: CircleAvatar(
            radius: 20,
            backgroundImage: userimg != ''
                ? NetworkImage(userimg)
                : AssetImage(
                    "assets/avatar.jpg",
                  ),
            backgroundColor: Colors.transparent,
          ),
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (BuildContext context) => new UserInfo(),
                ));
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Arch",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              "Bell",
              style: TextStyle(color: Colors.blue, fontSize: 22),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _controller,
          indicatorColor: Colors.blue,
          tabs: [
            Tab(child: Text("Subject")),
            Tab(child: Text("Tasks")),
            Tab(child: Text("News")),
          ],
        ),
        actions: [
          IconButton(
              tooltip: 'Reload',
              icon: Icon(FontAwesomeIcons.circleNotch),
              onPressed: () {
                getData();
              })
        ],
      ),
      body: TabBarView(controller: _controller, children: [
        //* Subject View
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection(useryear)
              .document(userterm)
              .collection('subject')
              .orderBy('subject', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Loading();
            } else {
              return snapshot.data.documents.length == 0
                  ? NoThing()
                  : new ListView(
                      padding: EdgeInsets.all(10),
                      children: [
                        Wrap(
                            spacing: 10,
                            runAlignment: WrapAlignment.center,
                            runSpacing: 10,
                            //crossAxisAlignment: WrapCrossAlignment.center,
                            direction: Axis.horizontal,
                            children: snapshot.data.documents
                                .map((doc) => buildSubjectItem(doc))
                                .toList())
                      ],
                    );
            }
          },
        ),
        //* Tasks View
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection(useryear)
              .document(userterm)
              .collection('tasks')
              .orderBy('week', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Loading();
            } else {
              return snapshot.data.documents.length == 0
                  ? NoThing()
                  : new ListView(
                      padding: EdgeInsets.all(10),
                      children: [
                        Wrap(
                            spacing: 10,
                            runAlignment: WrapAlignment.center,
                            runSpacing: 10,
                            //crossAxisAlignment: WrapCrossAlignment.center,
                            direction: Axis.horizontal,
                            children: snapshot.data.documents
                                .map((doc) => buildTaksItem(doc))
                                .toList())
                      ],
                    );
            }
          },
        ),
        //* News View
        Scaffold(
          floatingActionButton: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) => new NewsAdd(),
                        ));
                  },
                  onLongPress: () {
                    _showPasswordDialog();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      FontAwesomeIcons.plus,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('Article')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              } else {
                return snapshot.data.documents.length == 0
                    ? NoThing()
                    : new ListView(
                        padding: EdgeInsets.all(10),
                        children: [
                          Wrap(
                              spacing: 10,
                              runAlignment: WrapAlignment.center,
                              runSpacing: 10,
                              children: snapshot.data.documents
                                  .map((doc) => buildNewsItem(doc))
                                  .toList())
                        ],
                      );
              }
            },
          ),
        )
      ]),
    );
  }

  TextEditingController passwordController = TextEditingController();

  _showPasswordDialog() async {
    DocumentSnapshot snapshotAdminYear1 =
        await db.collection('ADMIN').document('Year1').get();
    DocumentSnapshot snapshotAdminYear2 =
        await db.collection('ADMIN').document('Year2').get();
    DocumentSnapshot snapshotAdminYear3 =
        await db.collection('ADMIN').document('Year3').get();
    DocumentSnapshot snapshotAdminYear4 =
        await db.collection('ADMIN').document('Year4').get();

    String adminYear1 = snapshotAdminYear1.data['password'];
    String adminYear2 = snapshotAdminYear2.data['password'];
    String adminYear3 = snapshotAdminYear3.data['password'];
    String adminYear4 = snapshotAdminYear4.data['password'];
    // print(adminYear1 + " " + adminYear2 + " " + adminYear3 + " " + adminYear4);

    await showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text("Admin Dashboard"),
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
              onPressed: () => Navigator.pop(context),
              child: Text("CANCEL", style: TextStyle(color: Colors.white))),
          CupertinoDialogAction(
            child: Text("ENTER", style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (passwordController.text == adminYear1 ||
                  passwordController.text == adminYear2 ||
                  passwordController.text == adminYear3 ||
                  passwordController.text == adminYear4) {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context) => new Admin(),
                    ));
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
}
