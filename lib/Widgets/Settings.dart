import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

int colorIndex = 3;
Color primaryColor = Colors.blueAccent;
Color bgColor = Colors.white;
TextEditingController weekdayHourController = TextEditingController();
TextEditingController weekdayMinuteController = TextEditingController();

TextEditingController weekendHourController = TextEditingController();
TextEditingController weekendMinuteController = TextEditingController();

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController nameController = TextEditingController();
  void saveData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setInt("colorIndex", colorIndex);
      prefs.setString("name", nameController.text);
      prefs.setInt("weekdayHour", int.parse(weekdayHourController.text));
      prefs.setInt("weekdayMinute", int.parse(weekdayMinuteController.text));
      prefs.setInt("weekendHour", int.parse(weekendHourController.text));
      prefs.setInt("weekendMinute", int.parse(weekendMinuteController.text));
      prefs.setBool("setupState", true);
    });

    Navigator.pop(context);
    setState(() {});
  }

  void getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString("name")!;
      weekdayHourController.text =
          (prefs.getInt("weekdayHour") ?? "").toString();
      weekdayMinuteController.text =
          (prefs.getInt("weekdayMinute") ?? "").toString();
      weekendHourController.text =
          (prefs.getInt("weekendHour") ?? "").toString();
      weekendMinuteController.text =
          (prefs.getInt("weekendMinute") ?? "").toString();
    });

    setState(() {
      colorIndex = prefs.getInt("colorIndex")!;
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
  void initState() {
    getSharedPrefs();
    super.initState();
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
                          child: Text(
                            "Beállítások",
                            style: TextStyle(
                                color: bgColor,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width / 10),
                          ))),
                ),
                SizedBox(height: 25),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.95,
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
                          Text("\nNév megváltoztatása",
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
                              Text("\nSzín megváltoztatása\n",
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
                          Text("\nHétköznapi értesítések",
                              textAlign: TextAlign.center,
                              style: statusTextStyle),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: weekdayHourController,
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
                                  controller: weekdayMinuteController,
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
                          Text("\nHétvégi értesítések",
                              textAlign: TextAlign.center,
                              style: statusTextStyle),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: weekendHourController,
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
                                  controller: weekendMinuteController,
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
                          SizedBox(
                            height: 18,
                          ),
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
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Vissza",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold),
                              )),
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
