import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web_qr_system/model/qrgenmodel.dart';
import '../model/usermodel.dart';

class QRGenerate extends StatefulWidget {
  const QRGenerate({Key? key}) : super(key: key);

  @override
  State<QRGenerate> createState() => _QRGenerateState();
}

class _QRGenerateState extends State<QRGenerate> {

  String qrData = "";
  final eventNameEditingController = new TextEditingController();
  final eventAddressEditingController = new TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState(){
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    final eventName = TextFormField(
      autofocus: false,
      controller: eventNameEditingController,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,

      onSaved: (value) {
        eventNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.event),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Event Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
      ),
    );

    final eventAddress = TextFormField(
      autofocus: false,
      controller: eventAddressEditingController,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,

      onSaved: (value) {
        eventAddressEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.location_pin),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Event Location",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final generateQRButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          setState(() {
            qrData = loggedInUser.uid.toString()
                +":"+eventNameEditingController.text
                +":"+eventAddressEditingController.text;
          postDetailsToFirestore();
          });
        },
        child: Text("Generate QR Code",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImage(
                  version: QrVersions.auto,
                  data: qrData,
                  size: 200,
                  backgroundColor: Colors.white
              ),
              SizedBox(height: 40),
              eventName,
              SizedBox(height: 20),
              eventAddress,
              SizedBox(height: 20),
              generateQRButton,
            ],
          ),
        ),
      ),
    );
  }

  postDetailsToFirestore() async {
    //calling firestore
    //calling user model
    //sending the values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    EventCreateModel eventCreateModel = EventCreateModel();

    //writing all the values
    eventCreateModel.eventName = eventNameEditingController.text;
    eventCreateModel.eventAddress = eventAddressEditingController.text;
    eventCreateModel.firstName = loggedInUser.firstName;
    eventCreateModel.lastName = loggedInUser.lastName;


    await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .collection("events")
        .doc(eventNameEditingController.text)
        .set(eventCreateModel.toMap());
    Fluttertoast.showToast(
        msg: "QR successfully generated!", timeInSecForIosWeb: 5);
  }


}
