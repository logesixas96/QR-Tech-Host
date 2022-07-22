import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_qr_system/screens/login.dart';
import 'package:web_qr_system/screens/userdashboard.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 60));
      setState(() => canResendEmail = true);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Verification link has sent previously. Please try again later!",
          timeInSecForIosWeb: 5);
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const UserDashboard()
      : Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 1,
              title: const Text("Email Verification"),
              centerTitle: true),
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/bg.png"), fit: BoxFit.fill),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 10,
                          vertical: MediaQuery.of(context).size.height / 10),
                      child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.red.shade900.withOpacity(.5),
                            blurRadius: 10.0,
                            spreadRadius: 0.0,
                            offset: const Offset(5.0, 5.0),
                          )
                        ]),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(35.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const CircularProgressIndicator(),
                                const SizedBox(height: 25),
                                const Text(
                                  'A verification link has been sent to your email. Please verify your account!',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 45),
                                SizedBox(
                                  width: 500,
                                  child: ElevatedButton.icon(
                                      icon: const Icon(Icons.email),
                                      label: const Text('Resend Link'),
                                      onPressed: canResendEmail ? sendVerificationEmail : null),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: 500,
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.close),
                                    label: const Text('Verify Later'),
                                    onPressed: () => {
                                      FirebaseAuth.instance.signOut(),
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                                          builder: (context) => const LoginScreen()))
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
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
