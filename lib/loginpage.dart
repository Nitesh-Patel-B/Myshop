import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myshop/homepage.dart';
import 'package:myshop/signuppage.dart';
import 'package:myshop/splashscreen.dart';
import 'dart:developer';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Login Now",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    )
                  ],
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 10),
                //   child: Column(
                //     children: [
                //       input(label: "Email"),
                //       input(label: "Password",obstext: true)
                //     ],
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                      padding: EdgeInsets.only(top: 5, left: 1),
                      child: Container(
                        margin: EdgeInsets.all(20),
                        child: TextField(
                          controller: email,
                          decoration: InputDecoration(
                              labelText: "Enter Email",
                              hintText: "Email",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50))),
                        ),
                      )),
                  // MaterialButton(
                  //   minWidth: double.infinity,
                  //   onPressed: () {},
                  //   color: Color(0xff0095ff),
                  //   elevation: 0,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(50),
                  //   ),
                  //   child: Text(
                  //     "Login",
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 18,
                  //         color: Colors.white),
                  //   ),
                  // ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: TextField(
                      obscureText: true,
                      controller: password,
                      decoration: InputDecoration(
                          labelText: "password",
                          // errorText: "enter valid password",
                          hintText: "Enter your password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50))),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      String umail = email.text;
                      String upassword = password.text;
                      // if (umail.isEmpty && upassword.isEmpty) {
                      //   passtatus = true;
                      //   emailstatus = true;
                      // }

                      Map mapp = {"email": umail, "password": upassword};

                      var url = Uri.parse(
                          'https://tonal-phase.000webhostapp.com/APIcalling/login.php'); //enter my table/view url

                      var response = await http.post(url, body: mapp);
                      debugPrint('Response status: ${response.statusCode}');

                      print('Response status: ${response.statusCode}');
                      print('Response body: ${response.body}');

                      log('====${response.body}');

                      var lg = jsonDecode(response.body);

                      Loginn lgn = Loginn.fromJson(lg);

                      setState(() {});

                      setState(() {
                        if (lgn.connection == 1) {
                          if (lgn.result == 1) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return home();
                              },
                            ));

                            log("=====${lgn.connection}");
                            log("=====${lgn.result}");

                            String? id = lgn.userdata!.id;
                            String? name = lgn.userdata!.name;
                            String? eemail = lgn.userdata!.email;
                            String? ppassword = lgn.userdata!.password;
                            String? mobile = lgn.userdata!.mobile;
                            String? imagename = lgn.userdata!.imagename;

                            Mysplash.pref!.setBool("loginstatus", true);

                            Mysplash.pref!.setString("id", id!);
                            Mysplash.pref!.setString("name", name!);
                            Mysplash.pref!.setString("password", ppassword!);
                            Mysplash.pref!.setString("email", eemail!);
                            Mysplash.pref!.setString("mobile", mobile!);
                            Mysplash.pref!.setString("imagename", imagename!);

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Yahh...Login Granted"),
                              duration: Duration(seconds: 10),
                              backgroundColor: Colors.green,
                            ));
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "you are new user >>> goto registration page",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.SNACKBAR,
                                timeInSecForIosWeb: 10,
                                backgroundColor: Colors.white,
                                textColor: Colors.red,
                                fontSize: 30.0,
                                webShowClose: true);
                          }
                        }
                      });

                      // Fluttertoast.showToast(msg: "${lgn.userdata!.name}",
                      // toastLength: Toast.LENGTH_SHORT,
                      // gravity: ToastGravity.CENTER,
                      // timeInSecForIosWeb: 2,
                      // backgroundColor: Colors.green,
                      // textColor: Colors.black,
                      // fontSize: 15.0
                      // );

                      // var log=jsonDecode(response.body);
                      // Login logg=login.fromJson(log);
                      //
                      // String id=logg.userdata!.id;
                      // String name=logg.userdata!.name;
                      // String eemail=logg.userdata!.email;
                      // String ppassword=logg.userdata!.password;
                      // String mobile=logg.userdata!.mobile;
                      // String imagename=logg.userdata!.imagepath;

                      //    Mysplash.pref.setBool("loginstatus", true);

                      // Mysplash.pref!.setString("id",id!);
                      // Mysplash.pref!.setString("name",name!);
                      // Mysplash.pref!.setString("password",ppassword!);
                      // Mysplash.pref!.setString("email",eemail!);
                      // Mysplash.pref!.setString("mobile",mobile!);
                      // Mysplash.pref!.setString("imagename",imagename!);
                      //
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      //   return home();
                      // },));
                      //
                      // setState(() {
                      //   String namme = name.text;
                      //   String pass = password.text;
                      //   if (namme.isEmpty || pass.isEmpty) {
                      //     namests = true;
                      //     passts = true;
                      //   }
                      // });
                    },
                    child: Text("Login Now")),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Account not exist "),
                    MaterialButton(
                      onPressed: () {
                        // setState(() {
                        //   String namme = name.text;
                        //   String pass = password.text;
                        //
                        //
                        //   if (namme.isEmpty || pass.isEmpty) {
                        //     namests = true;
                        //     passts = true;
                        //   }
                        // });
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Signup();
                          },
                        ));
                      },
                      color: Color(0xff0095ff),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Create Now",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    )
                  ],
                ),
                // Container(
                //   padding: EdgeInsets.only(top: 100),
                //   height: 200,
                //
                // )
              ],
            ))
          ],
        ),
      ),
    );
  }
}

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

bool emailstatus = false;
bool passtatus = false;

class Loginn {
  int? connection;
  int? result;
  Userdata? userdata;

  Loginn({this.connection, this.result, this.userdata});

  Loginn.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    result = json['result'];
    userdata = json['userdata'] != null
        ? new Userdata.fromJson(json['userdata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connection'] = this.connection;
    data['result'] = this.result;
    if (this.userdata != null) {
      data['userdata'] = this.userdata!.toJson();
    }
    return data;
  }
}

class Userdata {
  String? id;
  String? name;
  String? email;
  String? mobile;
  String? password;
  String? imagename;

  Userdata(
      {this.id,
      this.name,
      this.email,
      this.mobile,
      this.password,
      this.imagename});

  Userdata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    password = json['password'];
    imagename = json['imagename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    data['imagename'] = this.imagename;
    return data;
  }
}
