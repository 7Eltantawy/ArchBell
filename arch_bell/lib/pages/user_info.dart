import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:arch_bell/pages/news_add.dart';
import 'package:arch_bell/screen/photo_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  String username = "";
  String userimg = "";
  String useryear = "Choose the year";
  String userterm = "";
  bool isYearChosen = false;
  bool isTermrChosen = false;
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

  //* Save Crediaents
  Future saveUserData() async {
    final SharedPreferences prefs = await _sprefs;
    //* year
    if (y1) {
      useryear = "Year1";
    } else if (y2) {
      useryear = "Year2";
    } else if (y3) {
      useryear = "Year3";
    } else if (y4) {
      useryear = "Year4";
    }
    //* term
    if (t1) {
      userterm = "term1";
    } else if (t2) {
      userterm = "term2";
    }
    //*
    if (_formKey.currentState.validate()) {
      prefs.setString('userName', userNameController.text);
      prefs.setString('userImg', userImgController.text);
      prefs.setString('userYear', useryear);
      prefs.setString('userTerm', userterm);
      _showSnackbar("Data Saved", Colors.blue);
    } else {
      _showSnackbar("Error", Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  _showSnackbar(String message, Color color) {
    final snackBar = SnackBar(
      backgroundColor: color,
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userImgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("User Info"),
        actions: [
          IconButton(
              tooltip: 'Save',
              icon: Icon(FontAwesomeIcons.save),
              onPressed: () {
                saveUserData();
              })
        ],
      ),
      body: ListView(
        children: [
          Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new PhotoViewer(userimg)),
                        );
                      },
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: userimg != ''
                            ? NetworkImage(userimg)
                            : AssetImage(
                                "assets/avatar.jpg",
                              ),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      username,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: TextFormField(
                        controller: userNameController,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Please Enter your name';
                          } else if (val.length < 3) {
                            return 'Your Name is too short';
                          }
                          return null;
                        },
                        onChanged: (String username) {
                          setState(() {
                            this.username = username;
                          });
                        },
                        maxLength: 25,
                        decoration: InputDecoration(
                          labelText: 'User name',
                          hintText: 'Type your name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          filled: true,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: TextFormField(
                        controller: userImgController,
                        onChanged: (String userimg) {
                          setState(() {
                            this.userimg = userimg;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'User URL Img',
                          hintText: 'Enter your Img URL',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          filled: true,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        divider("Choose Year"),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                iconSize: 40,
                                icon: CircleAvatar(
                                  backgroundColor: y1
                                      ? Colors.blue
                                      : Theme.of(context).backgroundColor,
                                  child: Text("1st",
                                      style: TextStyle(color: Colors.white)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    y4 = y2 = y3 = false;
                                    y1 = true;
                                  });
                                }),
                            SizedBox(width: 20),
                            IconButton(
                                iconSize: 40,
                                icon: CircleAvatar(
                                  backgroundColor: y2
                                      ? Colors.blue
                                      : Theme.of(context).backgroundColor,
                                  child: Text("2nd",
                                      style: TextStyle(color: Colors.white)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    y1 = y4 = y3 = false;
                                    y2 = true;
                                  });
                                }),
                            SizedBox(width: 20),
                            IconButton(
                                iconSize: 40,
                                icon: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: y3
                                      ? Colors.blue
                                      : Theme.of(context).backgroundColor,
                                  child: Text("3rd",
                                      style: TextStyle(color: Colors.white)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    y1 = y2 = y4 = false;
                                    y3 = true;
                                  });
                                }),
                            SizedBox(width: 20),
                            IconButton(
                                iconSize: 40,
                                icon: CircleAvatar(
                                  backgroundColor: y4
                                      ? Colors.blue
                                      : Theme.of(context).backgroundColor,
                                  child: Text("4th",
                                      style: TextStyle(color: Colors.white)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    y1 = y2 = y3 = false;
                                    y4 = true;
                                  });
                                }),
                          ],
                        ),
                        SizedBox(height: 20),
                        divider("Choose Term"),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 40,
                              icon: CircleAvatar(
                                backgroundColor: t1
                                    ? Colors.blue
                                    : Theme.of(context).backgroundColor,
                                child: Text("1st",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              onPressed: () {
                                setState(() {
                                  t2 = false;
                                  t1 = true;
                                });
                              },
                            ),
                            SizedBox(width: 20),
                            IconButton(
                              iconSize: 40,
                              icon: CircleAvatar(
                                backgroundColor: t2
                                    ? Colors.blue
                                    : Theme.of(context).backgroundColor,
                                child: Text("2nd",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              onPressed: () {
                                setState(() {
                                  t1 = false;
                                  t2 = true;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
