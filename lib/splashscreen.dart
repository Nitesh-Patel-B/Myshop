import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myshop/homepage.dart';
import 'package:myshop/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mysplash extends StatefulWidget {
  static SharedPreferences? pref;
  @override
  State<Mysplash> createState() => _MysplashState();
}

class _MysplashState extends State<Mysplash> {
  bool loginstatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200,
          width: 200,
          child: Lottie.asset("row/83548-online-shopping-black-friday.json"),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getshare();
  }

  getshare() async {
    Mysplash.pref = await SharedPreferences.getInstance();
    setState(() {
      loginstatus = Mysplash.pref!.getBool("loginstatus") ?? false;
    });
    Future.delayed(Duration(seconds: 5)).then((value) {
      if (loginstatus) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return home();
          },
        ));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Main();
          },
        ));
      }
    });
  }
}
