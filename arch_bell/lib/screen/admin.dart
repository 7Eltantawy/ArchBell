import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../pages/news_add.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> with SingleTickerProviderStateMixin {
  TabController _controller;

  final _formKeySubject = GlobalKey<FormState>();
  final _formKeyLec = GlobalKey<FormState>();
  final _formKeyWeek = GlobalKey<FormState>();
  final _formKeyTask = GlobalKey<FormState>();
  String useryear = "";
  String userterm = "";
  bool y1 = true;
  bool y2 = false;
  bool y3 = false;
  bool y4 = false;
  bool t1 = true;
  bool t2 = false;

  //* subject
  TextEditingController subjectNameController = TextEditingController();
  TextEditingController subjectDrController = TextEditingController();
  TextEditingController subjectImgController = TextEditingController();
  TextEditingController lectureIdController = TextEditingController();
  TextEditingController lectureTilteController = TextEditingController();
  TextEditingController lectureSubtilteController = TextEditingController();
  TextEditingController lectureImgController = TextEditingController();
  TextEditingController lectureUrlController = TextEditingController();
  TextEditingController lecturePdfController = TextEditingController();

  //* Task
  TextEditingController weekController = TextEditingController();
  TextEditingController weekImgController = TextEditingController();
  TextEditingController taskIdController = TextEditingController();
  TextEditingController taskTilteController = TextEditingController();
  TextEditingController taskSubtilteController = TextEditingController();
  TextEditingController taskImgController = TextEditingController();
  TextEditingController taskUrlController = TextEditingController();
  TextEditingController taskPdfController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
  }

  addSubject() async {
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
    if (_formKeySubject.currentState.validate()) {
      _status(true);
      String uniqueCode =
          subjectNameController.text.replaceAll(new RegExp(r"\s+"), "");
      DocumentReference reference = Firestore.instance
          .document('$useryear/' + '$userterm/' + 'subject/' + uniqueCode);

      Firestore.instance.runTransaction((Transaction tx) async {
        await reference.setData(
          {
            'subject': subjectNameController.text,
            'dr': subjectDrController.text,
            'imgs': subjectImgController.text,
          },
        );
      });

      Navigator.pop(context);
      _status(false);
    }
  }

  addLec() async {
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
    if (_formKeyLec.currentState.validate()) {
      _status(true);
      String uniqueCode =
          subjectNameController.text.replaceAll(new RegExp(r"\s+"), "");
      await Firestore.instance
          .document('$useryear/' + '$userterm/' + 'subject/' + '$uniqueCode')
          .collection('lectures')
          .add(
        {
          'id': lectureIdController.text,
          'title': lectureTilteController.text,
          'subTitle': lectureSubtilteController.text,
          'pdf': lecturePdfController.text,
          'url': lectureUrlController.text,
          'img': lectureImgController.text,
        },
      );

      Navigator.pop(context);
      _status(false);
    }
  }

  void addWeek() async {
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
    if (_formKeyWeek.currentState.validate()) {
      _status(true);
      String uniqueCode =
          weekController.text.replaceAll(new RegExp(r"\s+"), "");

//* work
      await Firestore.instance
          .document('$useryear/' + '$userterm/' + 'tasks/' + '$uniqueCode')
          .setData(
        {
          'week': weekController.text,
          'img': weekImgController.text,
        },
      );

      Navigator.pop(context);
      _status(false);
    }
  }

  void addTask() async {
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
    if (_formKeyTask.currentState.validate()) {
      _status(true);
      String uniqueCode =
          weekController.text.replaceAll(new RegExp(r"\s+"), "");

//* work

      /*   await Firestore.instance
          .document('$useryear/' + '$userterm/' + 'tasks/' + '$uniqueCode')
          .updateData(
        {
          'week': weekController.text,
        },
      );*/

////
      await Firestore.instance
          .document('$useryear/' + '$userterm/' + 'tasks/' + '$uniqueCode')
          .collection('tasks')
          .add(
        {
          'id': taskIdController.text,
          'title': taskTilteController.text,
          'subTitle': taskSubtilteController.text,
          'pdf': taskPdfController.text,
          'url': taskUrlController.text,
          'img': taskImgController.text,
        },
      );

      Navigator.pop(context);
      _status(false);
    }
  }

  _status(bool load) async {
    await showDialog(
        context: context,
        child: CupertinoAlertDialog(
          content: Center(
              child: load
                  ? LinearProgressIndicator()
                  : Icon(FontAwesomeIcons.cloud, color: Colors.green)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Admin Dashboard"),
        bottom: TabBar(
          controller: _controller,
          tabs: [
            Tab(child: Text("Subject")),
            Tab(child: Text("Lecture")),
            Tab(child: Text("Week")),
            Tab(child: Text("Tasks")),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          //* ////////////////////////////////////////////
          //* Subject add
          Scaffold(
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  mini: true,
                  onPressed: () {
                    addSubject();
                  },
                  child: Icon(
                    FontAwesomeIcons.upload,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            //*
            body: ListView(
              children: [
                Form(
                    key: _formKeySubject,
                    child: Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          yearTerm(),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: subjectImgController,
                            decoration: InputDecoration(
                              labelText: 'Subject Image',
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: subjectNameController,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please Fill';
                              }
                              return null;
                            },
                            maxLength: 25,
                            decoration: InputDecoration(
                              labelText: 'Subject Name',
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: subjectDrController,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please Fill';
                              }
                              return null;
                            },
                            maxLength: 25,
                            decoration: InputDecoration(
                              labelText: 'Subject Dr',
                              hintText: 'Exapmel Dr/ Eng. ******',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ))
              ],
            ),
          ),

          //* ////////////////////////////////////////////
          //* Lec & Sec add
          Scaffold(
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  mini: true,
                  onPressed: () {
                    addLec();
                  },
                  child: Icon(
                    FontAwesomeIcons.upload,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            //*
            body: ListView(
              children: [
                Form(
                    key: _formKeyLec,
                    child: Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          yearTerm(),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: subjectNameController,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please Fill';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Subject Name',
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            maxLength: 2,
                            controller: lectureIdController,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please Fill';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Lecture ID',
                              hintText: 'Exampel: 1 2 3 ...',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: lectureTilteController,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please Fill';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Lecture Title',
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: lectureSubtilteController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: 'Lecture Subtitle',
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: lectureImgController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: 'lecture Img attach',
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: lecturePdfController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: 'Lecture PDF attach',
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: lectureUrlController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: 'Lecture URL',
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ))
              ],
            ),
          ),

          //* ////////////////////////////////////////////
          //* week add
          Scaffold(
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  mini: true,
                  onPressed: () {
                    addWeek();
                  },
                  child: Icon(
                    FontAwesomeIcons.upload,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            //*
            body: ListView(
              children: [
                Form(
                    key: _formKeyWeek,
                    child: Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          yearTerm(),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: weekController,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please Fill';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Week',
                              hintText: 'Exampel: Week1 or Summer Training',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: weekImgController,
                            decoration: InputDecoration(
                              labelText: 'Week Image url',
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ))
              ],
            ),
          ),

          //* ////////////////////////////////////////////
          //* Task add
          Scaffold(
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  mini: true,
                  onPressed: () {
                    addTask();
                  },
                  child: Icon(
                    FontAwesomeIcons.upload,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            //*
            body: ListView(
              children: [
                Form(
                    key: _formKeyTask,
                    child: Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          yearTerm(),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: weekController,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please Fill';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Week',
                              hintText: 'Exampel: Week1 or Summer Training',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            maxLength: 2,
                            keyboardType: TextInputType.number,
                            //inputFormatters:
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: taskIdController,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please Fill';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Task ID',
                              hintText: 'Exampel: 1 2 3 ...',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: taskTilteController,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please Fill';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Task Title',
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: taskSubtilteController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: 'Task Subtitle',
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: taskImgController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: 'Task Img',
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: taskPdfController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: 'Task PDF',
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: taskUrlController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: 'Task URL',
                              hintText: '',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

//*
  yearTerm() {
    return Column(
      children: [
        divider("Choose Year"),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                iconSize: 40,
                icon: CircleAvatar(
                  backgroundColor:
                      y1 ? Colors.blue : Theme.of(context).backgroundColor,
                  child: Text("1st", style: TextStyle(color: Colors.white)),
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
                  backgroundColor:
                      y2 ? Colors.blue : Theme.of(context).backgroundColor,
                  child: Text("2nd", style: TextStyle(color: Colors.white)),
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
                  backgroundColor:
                      y3 ? Colors.blue : Theme.of(context).backgroundColor,
                  child: Text("3rd", style: TextStyle(color: Colors.white)),
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
                  backgroundColor:
                      y4 ? Colors.blue : Theme.of(context).backgroundColor,
                  child: Text("4th", style: TextStyle(color: Colors.white)),
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
                backgroundColor:
                    t1 ? Colors.blue : Theme.of(context).backgroundColor,
                child: Text("1st", style: TextStyle(color: Colors.white)),
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
                backgroundColor:
                    t2 ? Colors.blue : Theme.of(context).backgroundColor,
                child: Text("2nd", style: TextStyle(color: Colors.white)),
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
    );
  }
}
