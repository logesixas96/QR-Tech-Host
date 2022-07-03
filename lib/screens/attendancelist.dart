import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AttendanceList extends StatefulWidget {
  final String newTextController;
  const AttendanceList(this.newTextController, {Key? key}) : super(key: key);

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Attendance List: "+widget.newTextController),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 1000,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width/10,
                vertical: MediaQuery.of(context).size.height/10),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: firebaseFirestore
                          .collection("users")
                          .doc(user!.uid)
                          .collection("events")
                          .doc(widget.newTextController)
                          .collection("attendance")
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot){
                        if (!snapshot.hasData){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index){
                              DocumentSnapshot event = snapshot.data.docs[index];
                              return Padding(
                                  padding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width / 20,
                                  vertical: 5
                                  ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: index.isEven? Colors.red.shade900.withOpacity(.5):Colors.red.shade300.withOpacity(.5),
                                            blurRadius: 10.0,
                                            spreadRadius: 0.0,
                                            offset: Offset(5.0, 5.0,)
                                        ),
                                      ]
                                  ),
                                  child: Card(
                                    child: Container(
                                      width: 1000,
                                      child: ListTile(
                                      leading: Icon(Icons.supervisor_account, size: 40, color: index.isEven? Colors.red.shade900:Colors.red.shade300),
                                      title: Text(event['firstName']+" "+event['lastName']+" @ "+event['phoneNum']),
                                      subtitle: Text(event['timeStamp']),
                                      trailing: Icon(Icons.task_alt, color: index.isEven? Colors.green:Colors.green.shade300, size: 40),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                        );
                      }
                  ),

          ),
        ),
      ),

    );
  }
}
