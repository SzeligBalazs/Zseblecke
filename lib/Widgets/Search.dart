import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zseblecke/utils/DatabseHelper.dart';
import 'package:zseblecke/utils/Model.dart';

class SearchForTasks extends StatefulWidget {
  SearchForTasks({Key? key}) : super(key: key);

  @override
  State<SearchForTasks> createState() => _SearchForTasksState();
}

class _SearchForTasksState extends State<SearchForTasks> {
  int? colorIndex;
  Color bgColor = Colors.white;
  Color primaryColor = Colors.blueAccent;
  double borderWidth = 3;
  double borderRadius = 15;
  double padding = 12;
  TextEditingController _searchQueryController = TextEditingController();
  String query = "";

  void getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    colorIndex = prefs.getInt("colorIndex");
    setState(() {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Keresés'),
        backgroundColor: bgColor,
        foregroundColor: primaryColor,
        elevation: 0,
      ),
      backgroundColor: bgColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: _searchQueryController,
                keyboardType: TextInputType.text,
                cursorColor: primaryColor,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Tantárgy',
                  hintStyle: TextStyle(color: primaryColor),
                  labelText: 'Keresés',
                  labelStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: primaryColor,
                      width: borderWidth,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: primaryColor,
                      width: borderWidth,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: primaryColor,
                      width: 1,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                },
              ),
              SizedBox(
                height: 64,
              ),
              Expanded(
                child: FutureBuilder<List<NoteModel>>(
                    future: DBhelper.instance.search(query),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<NoteModel>> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: Text(
                          'Keresés',
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ));
                      } else {
                        return snapshot.data!.isEmpty
                            ? Padding(
                                padding: EdgeInsets.all(padding),
                                child: Center(
                                    child: Text(
                                  'Keresés',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                )))
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
                                            color:
                                                Colors.black.withOpacity(0.1),
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
                                                  snapshot.data![index]
                                                          .subject +
                                                      " - lejárt",
                                                  style: TextStyle(
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 28))),
                                          Visibility(
                                              visible: date.isToday,
                                              child: Text(
                                                  snapshot.data![index]
                                                          .subject +
                                                      " - ma",
                                                  style: TextStyle(
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 28))),
                                          Visibility(
                                              visible: date.isTomorrow,
                                              child: Text(
                                                  snapshot.data![index]
                                                          .subject +
                                                      " - holnap",
                                                  style: TextStyle(
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 28))),
                                          Visibility(
                                              visible: !date.isTomorrow &&
                                                  !date.isToday &&
                                                  !date.isYesterday &&
                                                  now.isAtSameMomentAs(date),
                                              child: Text(
                                                  snapshot.data![index]
                                                          .subject +
                                                      " - " +
                                                      snapshot
                                                          .data![index].month +
                                                      " " +
                                                      snapshot.data![index].day,
                                                  style: TextStyle(
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
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
            ],
          ),
        ),
      ),
    );
  }
}
