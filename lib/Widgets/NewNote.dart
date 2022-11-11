import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zseblecke/utils/DatabseHelper.dart';
import 'package:zseblecke/utils/Model.dart';
import 'dart:math';

class NewNote extends StatefulWidget {
  NewNote({Key? key}) : super(key: key);

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  String? subject;
  String? where;
  String? month;
  String? day;

  String? image;

  TextEditingController _pageNumberController = TextEditingController();
  TextEditingController _taskNumberController = TextEditingController();

  TextEditingController _yearController = TextEditingController();
  TextEditingController _dayController = TextEditingController();

  Color primaryColor = Colors.blueAccent;
  int? colorIndex;

  String title = 'Új feladat';
  double borderRadius = 25;
  double borderWidth = 3;

  bool isExerciseBook = false;
  bool emptyFields = false;

  @override
  void initState() {
    getInitValues();

    super.initState();
  }

  void getInitValues() async {
    final prefs = await SharedPreferences.getInstance();
    _yearController.text = DateTime.now().year.toString();
    month = DateTime.now().month.toString();
    switch (month) {
      case '1':
        month = 'Január';
        break;
      case '2':
        month = 'Február';
        break;
      case '3':
        month = 'Március';
        break;
      case '4':
        month = 'Április';
        break;
      case '5':
        month = 'Május';
        break;
      case '6':
        month = 'Június';
        break;
      case '7':
        month = 'Július';
        break;
      case '8':
        month = 'Augusztus';
        break;
      case '9':
        month = 'Szeptember';
        break;
      case '10':
        month = 'Október';
        break;
      case '11':
        month = 'November';
        break;
      case '12':
        month = 'December';
        break;
    }
    int d = DateTime.now().day;
    setState(() {
      _dayController.text = d.toString();
      day = d.toString();
    });

    print(day);

    setState(() {
      colorIndex = prefs.getInt("colorIndex");
      if (colorIndex == 0) {
        primaryColor = Colors.redAccent;
      } else if (colorIndex == 1) {
        primaryColor = Colors.orangeAccent;
      } else if (colorIndex == 2) {
        primaryColor = Colors.lightGreen;
      } else if (colorIndex == 3) {
        primaryColor = Colors.blueAccent;
      } else if (colorIndex == 4) {
        primaryColor = Colors.deepPurpleAccent;
      } else if (colorIndex == 5) {
        primaryColor = Colors.purpleAccent;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = Theme.of(context).scaffoldBackgroundColor;

    void saveNote() async {
      setState(() {
        switch (month) {
          case '1':
            month = 'Január';
            break;
          case '2':
            month = 'Február';
            break;
          case '3':
            month = 'Március';
            break;
          case '4':
            month = 'Április';
            break;
          case '5':
            month = 'Május';
            break;
          case '6':
            month = 'Június';
            break;
          case '7':
            month = 'Július';
            break;
          case '8':
            month = 'Augusztus';
            break;
          case '9':
            month = 'Szeptember';
            break;
          case '10':
            month = 'Október';
            break;
          case '11':
            month = 'November';
            break;
          case '12':
            month = 'December';
            break;
        }
      });
      print(where);
      if (isExerciseBook == false
          ? _pageNumberController.text.isEmpty ||
              _taskNumberController.text.isEmpty ||
              _yearController.text.isEmpty ||
              month == null ||
              _dayController.text.isEmpty
          : _pageNumberController.text.isEmpty ||
              _yearController.text.isEmpty ||
              month == null ||
              _dayController.text.isEmpty) {
        setState(() {
          emptyFields = true;
          return;
        });
      } else {
        setState(() async {
          switch (month) {
            case '1':
              month = 'Január';
              break;
            case '2':
              month = 'Február';
              break;
            case '3':
              month = 'Március';
              break;
            case '4':
              month = 'Április';
              break;
            case '5':
              month = 'Május';
              break;
            case '6':
              month = 'Június';
              break;
            case '7':
              month = 'Július';
              break;
            case '8':
              month = 'Augusztus';
              break;
            case '9':
              month = 'Szeptember';
              break;
            case '10':
              month = 'Október';
              break;
            case '11':
              month = 'November';
              break;
            case '12':
              month = 'December';
              break;
          }
          emptyFields = false;

          DateTime now = DateTime.now();
          DateTime tomorrow = DateTime.now().add(Duration(days: 1));
          setState(() {
            day = _dayController.text;
          });

          await DBhelper.instance.add(
            NoteModel(
              pageNumber: _pageNumberController.text.toString(),
              taskNumber: _taskNumberController.text.toString(),
              subject: subject!.toString(),
              where: where!.toString(),
              year: _yearController.text.toString(),
              month: month!.toString(),
              day: _dayController.text.toString(),
            ),
          );
          setState(() {
            subject = null;
            where = null;
            day = null;
            month = null;
            _pageNumberController.clear();
            _taskNumberController.clear();
            _yearController.clear();
            _dayController.clear();
            emptyFields = false;
          });
          Navigator.pushNamed(context, '/home');
        });
      }
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
        backgroundColor: bgColor,
        foregroundColor: primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButton<String>(
                        dropdownColor: bgColor,
                        focusColor: bgColor,
                        isExpanded: true,
                        hint: Text(
                          subject ?? 'Válassz egy tantárgyat',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: primaryColor,
                        ),
                        items: <String>[
                          'Magyar nyelv és irodalom',
                          'Idegen nyelv',
                          'Matematika',
                          'Történelem',
                          'Hon- és népismeret',
                          'Erkölcstan/hittan',
                          'Természetismeret',
                          'Biológia',
                          'Fizika',
                          'Kémia',
                          'Földrajz',
                          'Ének-zene',
                          'Vizuális kultúra/Rajz',
                          'Informatika',
                          'Technika',
                          'Testnevelés',
                          'Művészetek',
                          'Filozófia',
                          'Dráma és tánc',
                          'Tánc és mozgás'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                        onChanged: (_subject) {
                          setState(() {
                            subject = _subject!;

                            print(subject);
                          });
                        },
                      ),
                    ),
                    DropdownButton<String>(
                      dropdownColor: bgColor,
                      focusColor: bgColor,
                      isExpanded: true,
                      hint: Text(
                        where ?? 'Hol található a feladat?',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: primaryColor,
                      ),
                      items: <String>[
                        'Tankönyv',
                        'Munkafüzet',
                        'Füzet',
                        'Gyakorló',
                        'Egyéb',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                      onChanged: (_where) {
                        setState(() {
                          where = _where;
                          print(where);
                          if (where == "Füzet" || where == "Egyéb") {
                            isExerciseBook = true;
                          } else {
                            isExerciseBook = false;
                          }
                        });
                      },
                    ),
                    TextField(
                      controller: _pageNumberController,
                      cursorColor: primaryColor,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: isExerciseBook == false
                            ? 'Hányadik oldalon található a feladat?'
                            : 'Jegyzet / Cím / Témakör',
                        labelStyle: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                            width: borderWidth,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                            width: borderWidth,
                          ),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !isExerciseBook,
                      child: TextField(
                        controller: _taskNumberController,
                        cursorColor: primaryColor,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: '1,2 a,b,c...',
                          hintStyle: TextStyle(color: primaryColor),
                          labelText: 'Feladat(ok)',
                          labelStyle: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: borderWidth,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: borderWidth,
                            ),
                          ),
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '\nHatáridő',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _yearController,
                            cursorColor: primaryColor,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Év',
                              labelStyle: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: borderWidth,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: borderWidth,
                                ),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 28, 0, 0),
                            child: DropdownButton<String>(
                              dropdownColor: bgColor,
                              focusColor: bgColor,
                              isExpanded: true,
                              hint: Text(
                                month ?? 'Hónap',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: primaryColor,
                              ),
                              items: <String>[
                                'Január',
                                'Február',
                                'Március',
                                'Április',
                                'Május',
                                'Június',
                                'Július',
                                'Augusztus',
                                'Szeptember',
                                'Október',
                                'November',
                                'December',
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }).toList(),
                              onChanged: (_month) {
                                setState(() {
                                  month = _month ?? 'Hónap';
                                  print("m:" + month!);
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _dayController,
                            cursorColor: primaryColor,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Nap',
                              labelStyle: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: borderWidth,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: borderWidth,
                                ),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 1,
                                ),
                              ),
                            ),
                            onSubmitted: (value) {
                              setState(() {
                                day = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: emptyFields,
                      child: Text(
                        "Az összes mező kitöltése kötelező!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        saveNote();
                      },
                      child: Container(
                        width: 130,
                        height: 42,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            'Mentés',
                            style: TextStyle(
                                color: bgColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
