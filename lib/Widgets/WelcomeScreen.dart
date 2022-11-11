import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

int colorIndex = 3;

class _WelcomeScreenState extends State<WelcomeScreen> {
  Color primaryColor = Colors.blueAccent;
  Color bgColor = Colors.white;
  TextEditingController nameController = TextEditingController();
  TextEditingController hourController = TextEditingController();
  TextEditingController minuteController = TextEditingController();

  @override
  void initState() {
    getData();

    super.initState();
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      bool setupStatus = false;
      setupStatus = prefs.getBool("setupState")!;
      print(setupStatus.toString());
      if (setupStatus == true) {
        Navigator.pushNamed(context, '/home');
      }
    });
  }

  bool showWarning = false;
  void saveData() async {
    if (nameController.text.isNotEmpty &&
        hourController.text.isNotEmpty &&
        minuteController.text.isNotEmpty) {
      if (nameController.text.contains(" ")) {
        nameController.text =
            nameController.text.substring(0, nameController.text.indexOf(" "));
      } else if (nameController.text.contains(".")) {
        nameController.text =
            nameController.text.substring(0, nameController.text.indexOf("."));
      }
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        prefs.setInt("colorIndex", colorIndex);
        prefs.setString("name", nameController.text);
        prefs.setInt("weekdayHour", int.parse(hourController.text));
        prefs.setInt("weekdayMinute", int.parse(minuteController.text));

        prefs.setBool("setupState", true);
      });
      Navigator.pushNamed(context, '/home');
    } else {
      setState(() {
        showWarning = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle statusTextStyle = TextStyle(
        color: primaryColor, fontSize: 26, fontWeight: FontWeight.bold);

    double borderWidth = 2;
    double padding = 12;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: primaryColor,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SafeArea(
                  child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(padding, padding * 2, padding, 0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Üdvözöl a \n",
                                style: TextStyle(
                                    color: bgColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            12)),
                            TextSpan(
                                text: "Zseblecke",
                                style: TextStyle(
                                    color: bgColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            10)),
                            TextSpan(
                                text: "!",
                                style: TextStyle(
                                    color: bgColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            12)),
                          ]),
                        )),
                  ),
                ),
                SizedBox(height: 25),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.8,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Írd be a keresztnevedet, vagy a becenevedet",
                              textAlign: TextAlign.center,
                              style: statusTextStyle),
                          TextField(
                            controller: nameController,
                            cursorColor: primaryColor,
                            textCapitalization: TextCapitalization.words,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Név',
                              labelStyle: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Válassz ki egy háttérszínt",
                                  textAlign: TextAlign.center,
                                  style: statusTextStyle),
                              GridView.count(
                                crossAxisCount: 6,
                                mainAxisSpacing: 6,
                                crossAxisSpacing: 6,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        primaryColor = Colors.redAccent;
                                        colorIndex = 0;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.redAccent
                                                .withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        primaryColor = Colors.orangeAccent;
                                        colorIndex = 1;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.orangeAccent,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.orangeAccent
                                                .withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        primaryColor = Colors.lightGreen;
                                        colorIndex = 2;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.lightGreen,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.lightGreen
                                                .withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        primaryColor = Colors.blueAccent;
                                        colorIndex = 3;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueAccent
                                                .withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        primaryColor = Colors.deepPurpleAccent;
                                        colorIndex = 4;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurpleAccent,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.deepPurpleAccent
                                                .withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        primaryColor = Colors.purpleAccent;
                                        colorIndex = 5;
                                        print(colorIndex);
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.purpleAccent,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.purpleAccent
                                                .withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text("Értesítést kérek ekkor:",
                              textAlign: TextAlign.center,
                              style: statusTextStyle),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: hourController,
                                  cursorColor: primaryColor,
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Óra',
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
                                width: 12,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: minuteController,
                                  cursorColor: primaryColor,
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Perc',
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
                            ],
                          ),
                          Visibility(
                              child: Text("Minden mezőt ki kell tölteni!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold)),
                              visible: showWarning),
                          GestureDetector(
                            onTap: () {
                              saveData();
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
                                  'Kész!',
                                  style: TextStyle(
                                      color: bgColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
