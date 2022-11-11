import 'dart:async';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zseblecke/utils/DatabseHelper.dart';
import 'package:zseblecke/utils/Model.dart';
import 'package:zseblecke/utils/pushNotifications.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? taskCount;
  double padding = 12;
  double borderRadius = 35;
  String name = "       ";
  int? hour;
  int? minute;
  bool horray = false;
  double borderWidth = 3;

  TextEditingController _searchQueryController = TextEditingController();

  void getDataFromDB() async {
    await DBhelper.instance.getTasks().then((value) {
      setState(() {
        taskCount = value.length;
      });
    });
  }

  void getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name")!;
      colorIndex = prefs.getInt("colorIndex");
      DateTime.now().weekday >= 6
          ? hour = prefs.getInt('weekendHour')
          : hour = prefs.getInt('weekdayHour');
      DateTime.now().weekday >= 6
          ? minute = prefs.getInt('weekendMinute')
          : minute = prefs.getInt('weekdayMinute');

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
    getDataFromDB();
    setState(() {});
    Timer.periodic(Duration(seconds: 1), (timer) {
      getDataFromDB();
      getSharedPrefs();

      pushNotification(
        title: "Zseblecke",
        body:
            "${name}, ${taskCount == null ? "nulla" : taskCount.toString()} elkészítetlen házi feladatod van!",
      );
    });

    super.initState();
  }

  int? colorIndex;
  Color primaryColor = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    Color bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SafeArea(
            child: Padding(
                padding: EdgeInsets.all(padding),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 6,
                  color: primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Szia, \n",
                              style: TextStyle(
                                  color: bgColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 12)),
                          TextSpan(
                              text: name.substring(0, 1).toUpperCase() +
                                  name.substring(1, name.length),
                              style: TextStyle(
                                  color: bgColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 10)),
                          TextSpan(
                              text: "!",
                              style: TextStyle(
                                  color: bgColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 12)),
                        ]),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "/settings");
                              },
                              icon: Icon(
                                Icons.settings,
                                color: bgColor,
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width / 4,
                            decoration: BoxDecoration(
                                color: bgColor, shape: BoxShape.circle),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "/search");
                                },
                                icon: Icon(
                                  Icons.search,
                                  color: primaryColor,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.45,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
              ),
            ),
            child: Center(
              child: FutureBuilder<List<NoteModel>>(
                  future: DBhelper.instance.getTasks(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<NoteModel>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Jelenleg nincs elmentve semmi.',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: horray == true
                                    ? MediaQuery.of(context).size.width / 5
                                    : 30,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '\n\n',
                          ),
                          TextSpan(
                            text: 'Kattints az "Új feladat" gombra.',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.normal),
                          ),
                        ]),
                        textAlign: TextAlign.center,
                      ));
                    } else {
                      return snapshot.data!.isEmpty
                          ? Padding(
                              padding: EdgeInsets.all(padding),
                              child: Center(
                                  child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: horray == true
                                        ? 'Hurrááá!'
                                        : 'Jelenleg nincs elmentve semmi.',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: horray == true
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5
                                            : 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: '\n\n',
                                  ),
                                  TextSpan(
                                    text: horray == true
                                        ? 'Minden feladatot elkészítettél.'
                                        : 'Kattints az "Új feladat" gombra.',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ]),
                                textAlign: TextAlign.center,
                              )),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              reverse: false,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                DateTime now = DateTime.now();

                                var month = snapshot.data![index].month;

                                switch (month) {
                                  case 'Január':
                                    month = '1';
                                    break;
                                  case 'Február':
                                    month = '2';
                                    break;
                                  case 'Március':
                                    month = '3';
                                    break;
                                  case 'Április':
                                    month = '4';
                                    break;
                                  case 'Május':
                                    month = '5';
                                    break;
                                  case 'Június':
                                    month = '6';
                                    break;
                                  case 'Július':
                                    month = '7';
                                    break;
                                  case 'Augusztus':
                                    month = '8';
                                    break;
                                  case 'Szeptember':
                                    month = '9';
                                    break;
                                  case 'Október':
                                    month = '10';
                                    break;
                                  case 'November':
                                    month = '11';
                                    break;
                                  case 'December':
                                    month = '12';
                                    break;
                                }

                                final date = DateTime(
                                    int.parse(snapshot.data![index].year),
                                    int.parse(month),
                                    int.parse(snapshot.data![index].day));

                                return Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(padding + 5),
                                  child: Container(
                                    padding: EdgeInsets.all(padding * 1.5),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius:
                                          BorderRadius.circular(borderRadius),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 20,
                                          spreadRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Visibility(
                                            visible: date.isBefore(now) &&
                                                !date.isToday,
                                            child: Text(
                                                snapshot.data![index].subject +
                                                    " - lejárt",
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 28))),
                                        Visibility(
                                            visible: date.isToday,
                                            child: Text(
                                                snapshot.data![index].subject +
                                                    " - ma",
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 28))),
                                        Visibility(
                                            visible: date.isTomorrow,
                                            child: Text(
                                                snapshot.data![index].subject +
                                                    " - holnap",
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 28))),
                                        Visibility(
                                            visible: !date.isTomorrow &&
                                                !date.isToday &&
                                                !date.isYesterday,
                                            child: Text(
                                                snapshot.data![index].subject +
                                                    " - " +
                                                    snapshot
                                                        .data![index].month +
                                                    " " +
                                                    snapshot.data![index].day,
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 28))),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                snapshot.data![index].where ==
                                                            "Füzet" ||
                                                        snapshot.data![index]
                                                                .where ==
                                                            "Egyéb"
                                                    ? snapshot.data![index]
                                                            .where +
                                                        ": " +
                                                        snapshot.data![index]
                                                            .pageNumber
                                                    : snapshot.data![index]
                                                            .where +
                                                        ": " +
                                                        snapshot.data![index]
                                                            .pageNumber +
                                                        ". oldal, " +
                                                        snapshot.data![index]
                                                            .taskNumber +
                                                        ". feladat.",
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        DBhelper.instance
                                                            .delete(snapshot
                                                                .data![index]
                                                                .id!);
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.redAccent,
                                                      size: 34,
                                                    )),
                                                IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        DBhelper.instance
                                                            .delete(snapshot
                                                                .data![index]
                                                                .id!);
                                                        horray = true;
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.done_rounded,
                                                      color: Colors.green,
                                                      size: 34,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                              });
                    }
                  }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/newNote');
        },
        label: Text(
          'Új feladat',
          style: TextStyle(color: bgColor),
        ),
        icon: Icon(
          Icons.add,
          color: bgColor,
        ),
        backgroundColor: primaryColor,
      ),
    );
  }
}
