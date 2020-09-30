import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'calendar_tile.dart';
import 'package:date_utils/date_utils.dart';
import 'time_schedule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:booking_app/main.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flushbar/flushbar.dart';


typedef DayBuilder(BuildContext context, DateTime day);

class Calendar extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<Tuple2<DateTime, DateTime>> onSelectedRangeChange;
  final bool isExpandable;
  final DayBuilder dayBuilder;
  final bool showChevronsToChangeRange;
  final bool showTodayAction;
  final bool showCalendarPickerIcon;
  final DateTime initialCalendarDateOverride;

  Calendar(
      {this.onDateSelected,
        this.onSelectedRangeChange,
        this.isExpandable: true,
        this.dayBuilder,
        this.showTodayAction: true,
        this.showChevronsToChangeRange: true,
        this.showCalendarPickerIcon: true,
        this.initialCalendarDateOverride});

  @override
  _CalendarState createState() => new _CalendarState();
}

class _CalendarState extends State<Calendar> {

  final calendarUtils = new Utils();
  List<DateTime> selectedMonthsDays;
  Iterable<DateTime> selectedWeeksDays;
  DateTime _selectedDate = new DateTime.now();
  String currentMonth;
  bool isExpanded = true;
  String displayMonth;
  DateTime get selectedDate => _selectedDate;

  void initState() {
    super.initState();
    if (widget.initialCalendarDateOverride != null)
      _selectedDate = widget.initialCalendarDateOverride;
    selectedMonthsDays = Utils.daysInMonth(_selectedDate);
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(_selectedDate);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(_selectedDate);
    selectedWeeksDays =
        Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
            .toList()
            .sublist(0, 7);
    displayMonth = Utils.formatMonth(_selectedDate);
  }

  Widget get nameAndIconRow {
    var leftInnerIcon;
    var rightInnerIcon;
    var leftOuterIcon;
    var rightOuterIcon;

    if (widget.showCalendarPickerIcon) {
      rightInnerIcon = new IconButton(
        onPressed: () => selectDateFromPicker(),
        icon: new Icon(Icons.calendar_today),
      );
    } else {
      rightInnerIcon = new Container();
    }

    if (widget.showChevronsToChangeRange) {
      leftOuterIcon = new IconButton(
        onPressed: isExpanded ? previousMonth : previousWeek,
        icon: new Icon(Icons.chevron_left),
      );
      rightOuterIcon = new IconButton(
        onPressed: isExpanded ? nextMonth : nextWeek,
        icon: new Icon(Icons.chevron_right),
      );
    } else {
      leftOuterIcon = new Container();
      rightOuterIcon = new Container();
    }

    if (widget.showTodayAction) {
      leftInnerIcon = new InkWell(
        child: new Text('Today'),
        onTap: resetToToday,
      );
    } else {
      leftInnerIcon = new Container();
    }
    final UserState userState = Provider.of<UserState>(context);
    final auth.User user = userState.user;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            leftOuterIcon ?? new Container(),
            leftInnerIcon ?? new Container(),
            new Text(
              '${_selectedDate.year}年${_selectedDate.month}月${_selectedDate.day}日',
              style: new TextStyle(
                fontSize: 20.0,
              ),
            ),
//        rightInnerIcon ?? new Container(),
            rightOuterIcon ?? new Container(),
          ],
        ),
      ],
    );
  }

  Widget get calendarGridView {
    return new Container(
      child: new GestureDetector(
        onHorizontalDragStart: (gestureDetails) => beginSwipe(gestureDetails),
        onHorizontalDragUpdate: (gestureDetails) =>
            getDirection(gestureDetails),
        onHorizontalDragEnd: (gestureDetails) => endSwipe(gestureDetails),
        child: new GridView.count(
          shrinkWrap: true,
          crossAxisCount: 7,
          padding: new EdgeInsets.only(bottom: 0.0),
          children: calendarBuilder(),
        ),
      ),
    );
  }

  List<Widget> calendarBuilder() {
    List<String> weekDays = ['日', '月', '火', '水', '木', '金', '土'];
    List<Widget> dayWidgets = [];
    List<DateTime> calendarDays =
    isExpanded ? selectedMonthsDays : selectedWeeksDays;

    weekDays.forEach(
          (day) {
        dayWidgets.add(
          new CalendarTile(
            isDayOfWeek: true,
            dayOfWeek: day,
          ),
        );
      },
    );

    bool monthStarted = false;
    bool monthEnded = false;

    calendarDays.forEach(
          (day) {
        if (monthStarted && day.day == 01) {
          monthEnded = true;
        }

        if (Utils.isFirstDayOfMonth(day)) {
          monthStarted = true;
        }

        if (this.widget.dayBuilder != null) {
          dayWidgets.add(
              CalendarTile(
                child: this.widget.dayBuilder(context, day),
                date: day,
                onDateSelected: () => handleSelectedDateAndUserCallback(day),
              ),
          );
        } else {
          dayWidgets.add(
            new CalendarTile(
              onDateSelected: () => handleSelectedDateAndUserCallback(day),
              date: day,
              dateStyles: configureDateStyle(monthStarted, monthEnded),
              isSelected: Utils.isSameDay(selectedDate, day),
            ),
          );
        }
      },
    );
    return dayWidgets;
  }


  TextStyle configureDateStyle(monthStarted, monthEnded) {
    TextStyle dateStyles;
    final TextStyle body1Style = Theme.of(context).textTheme.bodyText1;

    if (isExpanded) {
      final TextStyle body1StyleDisabled = body1Style.copyWith(
          color: Color.fromARGB(
            100,
            body1Style.color.red,
            body1Style.color.green,
            body1Style.color.blue,
          )
      );

      dateStyles = monthStarted && !monthEnded
          ? body1Style
          : body1StyleDisabled;
    } else {
      dateStyles = body1Style;
    }
    return dateStyles;
  }

  Widget get expansionButtonRow {
    if (widget.isExpandable) {
      return  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(Utils.fullDayFormat(selectedDate)),
          new IconButton(
            iconSize: 20.0,
            padding: new EdgeInsets.all(0.0),
            onPressed: toggleExpanded,
            icon: isExpanded
                ? new Icon(Icons.arrow_drop_up)
                : new Icon(Icons.arrow_drop_down),
          ),
        ],
      );
    } else {
      return new Container();
    }
  }
  List<String> timeList = [' 9:00',' 9:30','10:00','10:30','11:00','11:30','12:00','12:30','13:00','13:30','14:00','14:30','15:00','15:30','16:00','16:30','17:00','17:30','18:00','18:30','19:00','19:30','20:00','21:00'];

  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    showAlertDialog(BuildContext context){
      AlertDialog alert=AlertDialog(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        content: new Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(50),
            ),
            CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.green))
          ],
          ),
      );
      showDialog(barrierDismissible: false,
        context:context,
        builder:(BuildContext context){

          return Container(
            height: 400,
            width: 400,
            child: alert,
          );
        },
      );
    }

    final UserState userState = Provider.of<UserState>(context);
    final auth.User user = userState.user;
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          nameAndIconRow,
          new ExpansionCrossFade(
            collapsed: calendarGridView,
            expanded: calendarGridView,
            isExpanded: isExpanded,
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(3.0),
          ),
          Container(
            child: Column(
              children: <Widget>[
                RaisedButton(
                  color: Colors.lightGreen,
                  textColor: Colors.white,
                  padding: EdgeInsets.only(top: 13, right: 55, left: 55, bottom: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text("この日付で予約",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, fontFamily: 'GenJyuuGothic'),),
                  onPressed: ()async{
                    showAlertDialog(context);

                    try {
                      final result = await InternetAddress.lookup('google.com');
                      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                        print('connected');
                        DocumentSnapshot docSnapshot = await FirebaseFirestore
                            .instance.collection('holiday')
                            .doc("${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}")
                            .get();

                        Map<String, dynamic> record = docSnapshot
                            .data();
                        DocumentSnapshot docSnapshot2 = await FirebaseFirestore
                            .instance.collection('holiday_delete')
                            .doc("${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}")
                            .get();

                        Map<String, dynamic> record2 = docSnapshot2
                            .data();
                        DocumentSnapshot docSnapshot3 = await FirebaseFirestore
                            .instance.collection('maintenance')
                            .doc("maintenance")
                            .get();

                        Map<String, dynamic> record3 = docSnapshot3
                            .data();


                        if(record3 == null){
                          if(record != null){
                            return holiday2();
                          }
                          if(_selectedDate.day / 7 != 1 && (_selectedDate.day ~/ 7 == 1 || _selectedDate.day ~/ 7 == 2 || _selectedDate.day / 7 == 3) && _selectedDate.weekday == 2){

                            if(record2 != null){
                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => TimeSchedule(dayData: _selectedDate)
                              )
                              );
                            }else{
                              return holiday();
                            }
                          }
                          if(_selectedDate.weekday == 1){
                            if(record2 != null){
                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => TimeSchedule(dayData: _selectedDate)
                              )
                              );
                            }else{
                              return holiday();
                            }
                          }

                          if(_selectedDate.compareTo(DateTime.now()) == -1){
                            return error(context);
                          }else{
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => TimeSchedule(dayData: _selectedDate)
                            )
                            );

                          }
                        }else{
                          _maintenance();
                        }



                      }
                    } on SocketException catch (_) {
                      print('not connected');
                      Navigator.of(context, rootNavigator: true).pop();
                      Flushbar(
                        message: "インターネットに接続されていません",
                        backgroundColor: Colors.red,
                        margin: EdgeInsets.all(8),
                        borderRadius: 8,
                        duration: Duration(seconds: 3),
                      )..show(context);
                    }





                  },
                ),

                Padding(
                  padding: EdgeInsets.all(10),
                ),
                if(user.email == 'land12riku@gmail.com')
                  RaisedButton(
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    padding: EdgeInsets.only(top: 15, right: 75, left: 75, bottom: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text("休業日の設定",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    onPressed: ()async{
                      showAlertDialog(context);
                      try {
                        final result = await InternetAddress.lookup('google.com');
                        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                          print('connected');
                          DocumentSnapshot docSnapshot = await FirebaseFirestore
                              .instance.collection('holiday')
                              .doc("${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}")
                              .get();

                          Map<String, dynamic> record = docSnapshot
                              .data();
                          DocumentSnapshot docSnapshot2 = await FirebaseFirestore
                              .instance.collection('holiday_delete')
                              .doc("${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}")
                              .get();

                          Map<String, dynamic> record2 = docSnapshot2
                              .data();


                          if(_selectedDate.day / 7 != 1 && (_selectedDate.day ~/ 7 == 1 || _selectedDate.day ~/ 7 == 2 || _selectedDate.day / 7 == 3) && _selectedDate.weekday == 2){
                            if(record2 != null){
                              return _holiday2Delete();
                            }else{
                              return _holiday2();
                            }
                          }
                          if(_selectedDate.weekday == 1){
                            if(record2 != null){
                              return _holiday2Delete();
                            }else{
                              return _holiday2();
                            }
                          }
                          if(_selectedDate.compareTo(DateTime.now()) == -1){
                            return error(context);
                          }else{
                            if(record != null){
                              return _holidayDelete();
                            }else{
                              return _holiday();

                            }
                          }
                        }
                      } on SocketException catch (_) {
                        print('not connected');
                        Navigator.of(context, rootNavigator: true).pop();
                        Flushbar(
                          message: "インターネットに接続されていません",
                          backgroundColor: Colors.red,
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                          duration: Duration(seconds: 3),
                        )..show(context);
                      }


                    },
                  ),
                if(user.email == 'land07riku@gmail.com')
                  RaisedButton(
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    padding: EdgeInsets.only(top: 15, right: 75, left: 75, bottom: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text("メンテナンス",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    onPressed: ()async{
                      showAlertDialog(context);
                      DocumentSnapshot docSnapshot = await FirebaseFirestore
                          .instance.collection('maintenance')
                          .doc("maintenance")
                          .get();

                      Map<String, dynamic> record = docSnapshot
                          .data();
                      try {
                        final result = await InternetAddress.lookup('google.com');
                        if(record == null){
                          Navigator.of(context, rootNavigator: true).pop();
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(
                                          Radius.circular(10.0))),
                                  content: Text("メンテナンス中にしますか？"),
                                  actions: <Widget>[
                                    FlatButton(
                                        child: Text("はい"),
                                        onPressed: () {
                                          FirebaseFirestore.instance.collection('maintenance').doc('maintenance').set({
                                          });
                                          Navigator.of(context, rootNavigator: true).pop();
                                        }
                                    ),
                                    FlatButton(
                                      child: Text("いいえ"),
                                      onPressed: () =>
                                          Navigator.of(context, rootNavigator: true)
                                              .pop(),
                                    ),

                                  ],
                                );
                              }
                          );

                        }else{
                          Navigator.of(context, rootNavigator: true).pop();
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(
                                          Radius.circular(10.0))),
                                  content: Text("メンテナンス中を解除しますか？"),
                                  actions: <Widget>[
                                    FlatButton(
                                        child: Text("はい"),
                                        onPressed: () {
                                          FirebaseFirestore.instance.collection('maintenance').doc('maintenance').delete();
                                          Navigator.of(context, rootNavigator: true).pop();
                                        }
                                    ),
                                    FlatButton(
                                      child: Text("いいえ"),
                                      onPressed: () =>
                                          Navigator.of(context, rootNavigator: true)
                                              .pop(),
                                    ),

                                  ],
                                );
                              }
                          );

                        }
                      } on SocketException catch (_) {
                        print('not connected');
                        Navigator.of(context, rootNavigator: true).pop();
                        Flushbar(
                          message: "インターネットに接続されていません",
                          backgroundColor: Colors.red,
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                          duration: Duration(seconds: 3),
                        )..show(context);
                      }


                    },
                  ),


              ],
            )
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
          ),
        ],
      ),
    );
  }

  _holiday(){
    Navigator.of(context, rootNavigator: true).pop();

    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(10.0))),
            content: Text("${_selectedDate.month}月${_selectedDate.day}日を休業日にしますか？"),
            actions: <Widget>[
              FlatButton(
                  child: Text("はい"),
                  onPressed: () {
                    FirebaseFirestore.instance.collection("holiday").doc("${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}").set({
                    }).then((val) {
                      print("成功です");
                    }).catchError((err) {
                      print(err);
                    });
                    Navigator.of(context, rootNavigator: true).pop();
                  }
              ),
              FlatButton(
                child: Text("いいえ"),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true)
                        .pop(),
              ),

            ],
          );
        }
    );
  }
  _holidayDelete(){
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(10.0))),
            content: Text("${_selectedDate.month}月${_selectedDate.day}日の休業を解除しますか？"),
            actions: <Widget>[
              FlatButton(
                  child: Text("はい"),
                  onPressed: () {
                    FirebaseFirestore.instance.collection("holiday").doc("${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}").delete().then((val) {
                      print("成功です");
                    }).catchError((err) {
                      print(err);
                    });
                    Navigator.of(context, rootNavigator: true).pop();
                  }
              ),
              FlatButton(
                child: Text("いいえ"),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true)
                        .pop(),
              ),

            ],
          );
        }
    );
  }
  _holiday2(){
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(10.0))),
            content: Text("${_selectedDate.month}月${_selectedDate.day}日の休みを解除しますか？"),
            actions: <Widget>[
              FlatButton(
                  child: Text("はい"),
                  onPressed: () {
                    FirebaseFirestore.instance.collection("holiday_delete").doc("${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}").set({
                    }).then((val) {
                      print("成功です");
                    }).catchError((err) {
                      print(err);
                    });
                    Navigator.of(context, rootNavigator: true).pop();
                  }
              ),
              FlatButton(
                child: Text("いいえ"),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true)
                        .pop(),
              ),

            ],
          );
        }
    );
  }
  _holiday2Delete(){
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(10.0))),
            content: Text("${_selectedDate.month}月${_selectedDate.day}日を定休日に戻しますか？"),
            actions: <Widget>[
              FlatButton(
                  child: Text("はい"),
                  onPressed: () {
                    FirebaseFirestore.instance.collection("holiday_delete").doc("${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}").delete().then((val) {
                      print("成功です");
                    }).catchError((err) {
                      print(err);
                    });
                    Navigator.of(context, rootNavigator: true).pop();
                  }
              ),
              FlatButton(
                child: Text("いいえ"),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
              ),

            ],
          );
        }
    );
  }

  _maintenance() {
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(10.0))),
            content: Text("メンテナンス中です。"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              ),
            ],
          );
        }
    );
  }



  holiday() {
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(10.0))),
            content: Text("定休日です。"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              ),
            ],
          );
        }
    );
  }
  holiday2() {
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(10.0))),
            content: Text("休業日です。"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              ),
            ],
          );
        }
    );
  }
  error(context) {
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(10.0))),
            content: Text("過去への予約または当日予約はできません。"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              ),
            ],
          );
        }
    );
  }
//  _handleSubmit(DateTime dayData, List<String> timeList) {
//
//      var db = Firestore.instance;
//      db.collection("${dayData.year}-${dayData.month}-${dayData.day}").set({
//      }).then((val) {
//        print("保存しました");
//      }).catchError((err) {
//        print(err);
//      });
//
//  }

  void resetToToday() {
    _selectedDate = new DateTime.now();
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(_selectedDate);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(_selectedDate);

    setState(() {
      selectedWeeksDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList();
      selectedMonthsDays = Utils.daysInMonth(_selectedDate);
      displayMonth = Utils.formatMonth(_selectedDate);
    });

    _launchDateSelectionCallback(_selectedDate);
  }

  void nextMonth() {
    setState(() {
      _selectedDate = Utils.nextMonth(_selectedDate);
      var firstDateOfNewMonth = Utils.firstDayOfMonth(_selectedDate);
      var lastDateOfNewMonth = Utils.lastDayOfMonth(_selectedDate);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = Utils.daysInMonth(_selectedDate);
      displayMonth = Utils.formatMonth(_selectedDate);
    });
  }

  void previousMonth() {
    setState(() {
      _selectedDate = Utils.previousMonth(_selectedDate);
      var firstDateOfNewMonth = Utils.firstDayOfMonth(_selectedDate);
      var lastDateOfNewMonth = Utils.lastDayOfMonth(_selectedDate);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = Utils.daysInMonth(_selectedDate);
      displayMonth = Utils.formatMonth(_selectedDate);
    });
  }

  void nextWeek() {
    setState(() {
      _selectedDate = Utils.nextWeek(_selectedDate);
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(_selectedDate);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(_selectedDate);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList()
              .sublist(0, 7);
      displayMonth = Utils.formatMonth(_selectedDate);
    });
    _launchDateSelectionCallback(_selectedDate);
  }

  void previousWeek() {
    setState(() {
      _selectedDate = Utils.previousWeek(_selectedDate);
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(_selectedDate);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(_selectedDate);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList()
              .sublist(0, 7);
      displayMonth = Utils.formatMonth(_selectedDate);
    });
    _launchDateSelectionCallback(_selectedDate);
  }

  void updateSelectedRange(DateTime start, DateTime end) {
    var selectedRange = new Tuple2<DateTime, DateTime>(start, end);
    if (widget.onSelectedRangeChange != null) {
      widget.onSelectedRangeChange(selectedRange);
    }
  }

  Future<Null> selectDateFromPicker() async {
    DateTime selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );

    if (selected != null) {
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(selected);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(selected);

      setState(() {
        _selectedDate = selected;
        selectedWeeksDays =
            Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
                .toList();
        selectedMonthsDays = Utils.daysInMonth(selected);
        displayMonth = Utils.formatMonth(selected);
      });
      // updating selected date range based on selected week
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      _launchDateSelectionCallback(selected);
    }
  }

  var gestureStart;
  var gestureDirection;

  void beginSwipe(DragStartDetails gestureDetails) {
    gestureStart = gestureDetails.globalPosition.dx;
  }

  void getDirection(DragUpdateDetails gestureDetails) {
    if (gestureDetails.globalPosition.dx < gestureStart) {
      gestureDirection = 'rightToLeft';
    } else {
      gestureDirection = 'leftToRight';
    }
  }

  void endSwipe(DragEndDetails gestureDetails) {
    if (gestureDirection == 'rightToLeft') {
      if (isExpanded) {
        nextMonth();
      } else {
        nextWeek();
      }
    } else {
      if (isExpanded) {
        previousMonth();
      } else {
        previousWeek();
      }
    }
  }

  void toggleExpanded() {
    if (widget.isExpandable) {
      setState(() => isExpanded = !isExpanded);
    }
  }

  void handleSelectedDateAndUserCallback(DateTime day) {
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(day);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(day);
    setState(() {
      _selectedDate = day;
      selectedWeeksDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList();
      selectedMonthsDays = Utils.daysInMonth(day);
    });
    _launchDateSelectionCallback(day);
  }

  void _launchDateSelectionCallback(DateTime day) {
    if (widget.onDateSelected != null) {
      widget.onDateSelected(day);
    }
  }
}

class ExpansionCrossFade extends StatelessWidget {
  final Widget collapsed;
  final Widget expanded;
  final bool isExpanded;

  ExpansionCrossFade({this.collapsed, this.expanded, this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return new Flexible(
      flex: 1,
      child: new AnimatedCrossFade(
        firstChild: collapsed,
        secondChild: expanded,
        firstCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.decelerate,
        crossFadeState:
        isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}