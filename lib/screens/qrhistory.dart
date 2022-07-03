import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:web_qr_system/screens/attendancelist.dart';

class QRHistory extends StatefulWidget {
  const QRHistory({Key? key}) : super(key: key);

  @override
  State<QRHistory> createState() => _QRHistoryState();
}

class _QRHistoryState extends State<QRHistory> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final newTextController = new TextEditingController();
  GlobalKey globalKey = new GlobalKey();
  String dataLength = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("My Events"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 10,
                vertical: MediaQuery.of(context).size.height / 10),
            child: StreamBuilder<QuerySnapshot>(
                stream: firebaseFirestore
                    .collection("users")
                    .doc(user!.uid)
                    .collection("events")
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot event = snapshot.data.docs[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 20,
                            vertical: 10,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.red.shade900.withOpacity(.5),
                                      blurRadius: 10.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(5.0, 5.0,)
                                  ),
                                ]
                            ),
                            child: Card(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: ListTile(
                                        leading: Icon(Icons.event,
                                            size: 40,
                                            color: index.isEven
                                                ? Colors.red.shade900
                                                : Colors.red.shade300),
                                        title: Text(event['eventName'] + ", " + event['eventAddress']),
                                        subtitle: Text("QR Created @ " + event['timeStamp']),
                                        trailing: Icon(
                                            Icons.double_arrow_outlined,
                                            color: index.isEven
                                                ? Colors.red.shade900
                                                : Colors.red.shade300),
                                        onTap: () {
                                          newTextController.text =
                                              event['eventName'];
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AttendanceList(
                                                          newTextController.text
                                                      )
                                              )
                                          );
                                        }
                                    ),
                                  ),
                                  //getLength(),
                                  Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          TextButton.icon(
                                              onPressed: () {},
                                              icon: Icon(Icons.qr_code_2),
                                              label: Text("dd")
                                          ),
                                          TextButton.icon(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => Center(
                                                    child: SingleChildScrollView(
                                                      child: AlertDialog(
                                                        content: Container(
                                                          width: 300,
                                                          //height: 200,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            //crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: <Widget>[
                                                              Align(
                                                                alignment: Alignment.topRight,
                                                                child: IconButton(
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                    icon: Icon(
                                                                        Icons.close,
                                                                        color: Colors.grey)),
                                                              ),
                                                              RepaintBoundary(
                                                                key: globalKey,
                                                                child: QrImage(
                                                                  version: QrVersions.auto,
                                                                  data: event['qrData'],
                                                                  size: 200,
                                                                  backgroundColor:
                                                                      Colors.white,
                                                                ),
                                                              ),
                                                              TextButton.icon(
                                                                  onPressed: () {
                                                                    downloadQR();
                                                                  },
                                                                  icon: Icon(Icons.download),
                                                                  label: Text("Download QR"),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: Icon(Icons.qr_code_2,
                                                  color: Colors.grey),
                                              label: Text("Show QR Code",
                                                  style: TextStyle(
                                                      color: Colors.grey))),
                                          TextButton.icon(onPressed: () {
                                            showDialog(context: context, builder: (context) => Center(
                                              child: SingleChildScrollView(
                                                child: AlertDialog(
                                                  title: Text("Confirm Delete?"),
                                                  content: Text("You are deleting '" + event['eventName'] + "' & all of the information related to the event!"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text("Cancel")
                                                    ),
                                                    TextButton(
                                                        onPressed: () async {
                                                          var collection = firebaseFirestore
                                                              .collection("users")
                                                              .doc(user!.uid)
                                                              .collection("events")
                                                              .doc(event['eventName'])
                                                              .collection("attendance");

                                                          var snapshots = await collection.get();
                                                          for (var doc in snapshots.docs) {
                                                            await doc.reference.delete();
                                                          }
                                                          firebaseFirestore
                                                              .collection("users")
                                                              .doc(user!.uid)
                                                              .collection("events")
                                                              .doc(event['eventName'])
                                                              .delete();
                                                          Fluttertoast.showToast(
                                                              msg: "Event successfully deleted!", timeInSecForIosWeb: 5);
                                                          Navigator.of(context).pop();
                                                          },
                                                        child: Text("Confirm")
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                            );
                                            },
                                              icon: Icon(Icons.delete), label: Text("Delete Event")),
                                        ],
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }),
          ),
        ),
      ),
    );
  }

  void downloadQR() async {
    RenderRepaintBoundary? boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    ui.Image? image = await boundary?.toImage(pixelRatio: 3.0);
    ByteData? byteData =
        await image?.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();

    final base64data = base64Encode(pngBytes!);
    final AnchorElement a =
        AnchorElement(href: 'data:image/png;base64,$base64data');
    a.download = 'QR.png';
    a.click();
    a.remove();
  }


}
