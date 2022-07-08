import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceList extends StatefulWidget {
  final String qrDataTextController;
  final String newEventNameTextController;

  const AttendanceList(this.qrDataTextController, this.newEventNameTextController, {Key? key}) : super(key: key);

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  get timeStamp => DateFormat('dd MMMM yyyy hh:mm a');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 1,
          title: Text("Attendance List: ${widget.newEventNameTextController}"),
          centerTitle: true,
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/bg.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 10,
                            vertical: MediaQuery.of(context).size.height / 25),
                        child: SingleChildScrollView(
                            child:
                                ListView(shrinkWrap: true, children: <Widget>[
                          StreamBuilder<QuerySnapshot>(
                              stream: firebaseFirestore
                                  .collection("users")
                                  .doc(user!.uid)
                                  .collection("events")
                                  .doc(widget.qrDataTextController)
                                  .collection("attendance")
                                  .snapshots(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return const SizedBox(
                                      height: 150,
                                      child: Center(
                                          child: CircularProgressIndicator()));
                                }
                                return Center(
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 70, 0, 30),
                                        child: Text(
                                            "Total Attendance: ${snapshot.data.docs.length}",
                                            style: const TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold))));
                              }),
                          StreamBuilder<QuerySnapshot>(
                              stream: firebaseFirestore
                                  .collection("users")
                                  .doc(user!.uid)
                                  .collection("events")
                                  .doc(widget.qrDataTextController)
                                  .collection("attendance")
                                  .orderBy('timeStamp')
                                  .snapshots(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return const SizedBox(
                                      height: 280,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ));
                                }
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot event =
                                          snapshot.data.docs[index];
                                      return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25,
                                              vertical: 5),
                                          child: Container(
                                              decoration:
                                                  BoxDecoration(boxShadow: [
                                                BoxShadow(
                                                    color: index.isEven
                                                        ? Colors.red.shade900
                                                            .withOpacity(.5)
                                                        : Colors.red.shade300
                                                            .withOpacity(.5),
                                                    blurRadius: 10.0,
                                                    spreadRadius: 0.0,
                                                    offset:
                                                        const Offset(5.0, 5.0))
                                              ]),
                                              child: Card(
                                                  child: ListTile(
                                                      leading:
                                                          Icon(Icons.supervisor_account,
                                                              size: 40,
                                                              color: index
                                                                      .isEven
                                                                  ? Colors.red
                                                                      .shade900
                                                                  : Colors.red
                                                                      .shade300),
                                                      title: Text(
                                                          event['firstName'] +
                                                              " " +
                                                              event['lastName'] +
                                                              " - " +
                                                              event['phoneNum']),
                                                      subtitle: Text(timeStamp.format(DateTime.fromMillisecondsSinceEpoch((event['timeStamp']).millisecondsSinceEpoch))),
                                                      trailing: Icon(Icons.task_alt, color: index.isEven ? Colors.green : Colors.green.shade300, size: 40)))));
                                    });
                              })
                        ])))))));
  }
}
