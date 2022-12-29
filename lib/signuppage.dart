import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'loginpage.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String img = "";
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: InkWell(
                      onTap: () async {
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        setState(() {
                          img = image!.path;
                        });
                      },
                      child: Container(
                        child: img != ""
                            ? CircleAvatar(
                                maxRadius: 60,
                                backgroundImage: FileImage(File(img)),
                              )
                            : Icon(
                                Icons.account_circle,
                                size: 150,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                    padding: EdgeInsets.only(top: 5, left: 1),
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: TextField(
                        controller: name,
                        decoration: InputDecoration(
                            labelText: "Your name",
                            hintText: "Enter Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50))),
                      ),
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                    padding: EdgeInsets.only(top: 5, left: 1),
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: TextField(
                        controller: email,
                        decoration: InputDecoration(
                            labelText: "Your Email",
                            hintText: "Enter Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50))),
                      ),
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                    padding: EdgeInsets.only(top: 5, left: 1),
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: TextField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                            suffix: Icon(Icons.visibility_off),
                            labelText: "Your Password",
                            hintText: "Enter Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50))),
                      ),
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                    padding: EdgeInsets.only(top: 5, left: 1),
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: TextField(
                        controller: mobile,
                        decoration: InputDecoration(
                            labelText: "Mobile Number",
                            hintText: "Enter Mobile No.",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50))),
                      ),
                    )),
              ),
              Container(
                padding: EdgeInsets.only(top: 3, left: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), border: Border()),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 40,
                  onPressed: () async {
                    debugPrint("Yes");

                    String namei = name.text;
                    String emaili = email.text;
                    String mobilei = mobile.text;
                    String passi = password.text;
                    List<int> iii = File(img).readAsBytesSync();
                    String imag = base64Encode(iii);

                    if (namei.isEmpty ||
                        emaili.isEmpty ||
                        mobilei.isEmpty ||
                        passi.isEmpty) {
                      setState(() {
                        namme = true;
                        eemail = true;
                        pasword = true;
                        mmobile = true;
                      });
                    } else {
                      Map map = {
                        "name": namei,
                        "email": emaili,
                        "mobile": mobilei,
                        "pass": passi,
                        "imagdata": imag
                      };

                      var url = Uri.parse(
                          'https://tonal-phase.000webhostapp.com/APIcalling/register.php'); //enter my table/view url
                      var response = await http.post(url, body: map);
                      debugPrint("Yes");
                      debugPrint('Response status: ${response.statusCode}');
                      print('Response body: ${response.body}');

                      var jsonn = jsonDecode(response.body);

                      MyRegister regi = MyRegister.fromJson(jsonn);

                      print("${regi.connection}");

                      if (regi.connection == 1) {
                        if (regi.result == 1) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("register success"),
                            duration: Duration(seconds: 10),
                          ));
                        } else if (regi.result == 2) {
                          Fluttertoast.showToast(
                              msg: "email alredy exist",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 10.0);
                        } else {
                          Fluttertoast.showToast(
                              msg: "internet connection error",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 10.0);
                        }
                      }
                    }
                  },
                  color: Color(0xff0095ff),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Back to Login>>>",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Login();
                        },
                      ));
                    },
                    color: Color(0xff0095ff),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child:
                        //
                        Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController mobile = TextEditingController();

  bool namme = false;
  bool eemail = false;
  bool pasword = false;
  bool mmobile = false;
}

class MyRegister {
  int? connection;
  int? result;

  MyRegister({this.connection, this.result});

  MyRegister.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connection'] = this.connection;
    data['result'] = this.result;
    return data;
  }
}
