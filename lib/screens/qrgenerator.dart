import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGenerate extends StatefulWidget {
  const QRGenerate({Key? key}) : super(key: key);

  @override
  State<QRGenerate> createState() => _QRGenerateState();
}

class _QRGenerateState extends State<QRGenerate> {

  String qrData = "";
  final eventNameEditingController = new TextEditingController();
  final eventAddressEditingController = new TextEditingController();

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
            qrData = eventNameEditingController.text+eventAddressEditingController.text;
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
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImage(
                  embeddedImage: NetworkImage(
                    "https://avatars1.githubusercontent.com/u/41328571?s=280&v=4",
                  ),
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
}
