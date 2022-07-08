import 'dart:core';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web_qr_system/model/qrgenmodel.dart';
import 'package:web_qr_system/screens/qrhistory.dart';
import '../model/usermodel.dart';
import 'package:intl/intl.dart';

class QRGenerate extends StatefulWidget {
  const QRGenerate({Key? key}) : super(key: key);

  @override
  State<QRGenerate> createState() => _QRGenerateState();
}

class _QRGenerateState extends State<QRGenerate> {
  final _formKey = GlobalKey<FormState>();
  String qrData = "";
  final eventNameEditingController = TextEditingController();
  final eventAddressEditingController = TextEditingController();
  final eventDateTimeEditingController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventName = TextFormField(
      autofocus: false,
      controller: eventNameEditingController,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      onSaved: (value) {
        eventNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter an event name!");
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.drive_file_rename_outline),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Event Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final eventAddress = TextFormField(
      autofocus: false,
      controller: eventAddressEditingController,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      onSaved: (value) {
        eventAddressEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter the location of your event!");
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.location_pin),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Event Location Name",
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
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          generateQR(eventNameEditingController.text,
              eventAddressEditingController.text, eventDateTimeEditingController.text);
        },
        child: const Text(
          "Generate QR Code",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final eventDate = TextFormField(
      readOnly: true,
      controller: eventDateTimeEditingController,
      onTap: () async {
        await pickDateTime();
      },
      autofocus: false,
      onSaved: (value) {
        eventDateTimeEditingController.text = value!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please select the date & time of your event!");
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.calendar_month),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Event Date & Time",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 1,
        title: const Text('QR Code Generator'),
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
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 10,
                        vertical: MediaQuery.of(context).size.height / 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        QrImage(
                          version: QrVersions.auto,
                          data: qrData,
                          size: 200,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 60),
                        SizedBox(width: 800, child: eventName),
                        const SizedBox(height: 20),
                        SizedBox(width: 800, child: eventAddress),
                        const SizedBox(height: 20),
                        SizedBox(width: 800, child: eventDate),
                        const SizedBox(height: 40),
                        SizedBox(width: 800, child: generateQRButton),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future pickDateTime() async {
    final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365))
    );
    if (date == null) return;
    final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now()
    );
    if (time == null) return;
    final newDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute
    );
    setState(() => dateTime = newDateTime);
    setState(() {
      eventDateTimeEditingController.text = DateFormat('dd MMMM yyyy hh:mm a').format(dateTime);
    });
  }

  void generateQR(String eventName, String eventAddress, String eventDate) {
    if (_formKey.currentState!.validate()) {
      setState(() {
        qrData =
            "${loggedInUser.uid}:${eventNameEditingController.text}:${eventAddressEditingController.text}:${eventDateTimeEditingController.text}";
      });
      postDetailsToFirestore();
    }
  }

  postDetailsToFirestore(){

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    EventCreateModel eventCreateModel = EventCreateModel();

    //writing all the values
    eventCreateModel.eventName = eventNameEditingController.text;
    eventCreateModel.eventAddress = eventAddressEditingController.text;
    eventCreateModel.eventDate = dateTime;
    eventCreateModel.qrData = qrData;

    final eventsRef = firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .collection("events")
        .doc(qrData);

    eventsRef.get().then((docSnapshot) async => {
      if (docSnapshot.exists)
        {
          Fluttertoast.showToast(
              msg: "Error! You have already created this event!",
              timeInSecForIosWeb: 5)
        }
      else
        {
          await eventsRef.set(eventCreateModel.toMap()),
          Fluttertoast.showToast(
              msg: "QR successfully generated!", timeInSecForIosWeb: 5),
          Navigator.push(context, MaterialPageRoute(builder: (context) => const QRHistory()))
        }
    });
  }

}
