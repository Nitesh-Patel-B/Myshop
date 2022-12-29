import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myshop/signuppage.dart';
import 'package:myshop/splashscreen.dart';
import 'loginpage.dart';

void main() {
  runApp(MaterialApp(
    home: Mysplash(),
  ));
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    double theight = MediaQuery.of(context).size.height;
    double twidth = MediaQuery.of(context).size.width;
    double statusheight = MediaQuery.of(context).padding.top;
    double tbodyheight = theight - twidth;

    return Scaffold(
      body: SafeArea(
          child: Container(
        width: double.infinity,
        //  height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  "Login/Signup",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Select Below", textAlign: TextAlign.center),
              ],
            ),
            Container(
              height: 50,
              // height: tbodyheight * 0.2,
              // MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: AssetImage("images/login.jpg"))),
            ),
            Column(
              children: [
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Login();
                      },
                    ));
                  },
                  color: Color(0xff0095ff),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Signup();
                      },
                    ));
                  },
                  child: Text("SignUp"),


                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
