import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myshop/homepage.dart';
import 'package:myshop/splashscreen.dart';

class Updatepage extends StatefulWidget {
  String loginId;
  String productId;
  String proimage;
  String proprize;
  String prodes;
  String proname;

  Updatepage(this.productId, this.proimage, this.proprize, this.prodes,
      this.proname, this.loginId);

  @override
  State<Updatepage> createState() => _UpdatepageState();
}

class _UpdatepageState extends State<Updatepage> {
  String? userid;
  String? imgg = "";
  String? name;
  List<Productdata>? productdata;

  String name1 = "";
  String des = "";
  String priz = "";
  // String img = '';

  String imagepath = "";

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    setState(() {
      userid = widget.productId;

      String name1 = widget.proname;
      proname.text = name1;
      String des = widget.prodes;
      prodesctription.text = des;
      String priz = widget.proprize;
      proprice.text = priz;
      imgg = widget.proimage;
      // print('====$img');
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
        title: Text("Update product"),
      ),
      // body: Container(
      //   height: 200,
      //   width: 200,
      //   decoration: BoxDecoration(
      //       image: DecorationImage(
      //           image: NetworkImage(
      //               "https://tonal-phase.000webhostapp.com/APIcalling/$img"))),
      // ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: InkWell(
                        onTap: () async {
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            imagepath = image!.path;
                          });
                        },
                        child: Container(
                          // decoration: BoxDecoration(
                          //     image: DecorationImage(
                          //   image: NetworkImage(
                          //       "https://tonal-phase.000webhostapp.com/APIcalling/${img}"),
                          // )),

                          child: imagepath != ""
                              ? CircleAvatar(
                                  backgroundImage: FileImage(File(imagepath)),
                                )
                              : CircleAvatar(
                                  maxRadius: 50,
                                  backgroundImage: NetworkImage(
                                      "https://tonal-phase.000webhostapp.com/APIcalling/${imgg}"),
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
                        child: TextFormField(
                          controller: proname,
                          decoration: InputDecoration(
                              labelText: "Product name",
                              hintText: "Enter Product",
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
                        child: TextFormField(
                          controller: proprice,
                          decoration: InputDecoration(
                              labelText: "Set Price",
                              hintText: "Enter Price",
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
                        child: TextFormField(
                          controller: prodesctription,
                          decoration: InputDecoration(
                              labelText: "Add Desctription",
                              hintText: " Enter Desctription ",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50))),
                        ),
                      )),
                ),
                Container(
                  padding: EdgeInsets.only(top: 3, left: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border()),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 40,
                    onPressed: () async {
                      print("update clicked");

                      String prname = proname.text;
                      String prprice = proprice.text;
                      String prdesc = prodesctription.text;
                      List<int> iii = File(imagepath).readAsBytesSync();
                      String imagedata = base64Encode(iii);

                      Map map = {
                        "userid": userid,
                        "pronname": prname,
                        "proprize": prprice,
                        "prodes": prdesc,
                        "imagename": imgg, //old image
                        "imagedata": imagedata //new image
                      };

                      var url = Uri.parse(
                          'https://tonal-phase.000webhostapp.com/APIcalling/updateproduct.php'); //enter my table/view url
                      var response = await http.post(url, body: map);
                      debugPrint("Yes");
                      debugPrint('Response status: ${response.statusCode}');
                      print('Response body: ${response.body}');

                      var jsonn = jsonDecode(response.body);
                      updates updatepro = updates.fromJson(jsonn);
                      setState(() {
                        print("${updatepro.connection}");
                      });

                      if (updatepro.connection == 1) {
                        if (updatepro.result == 1) {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return home();
                            },
                          ));
                        }
                      }
                    },
                    color: Color(0xff0095ff),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "Update Product",
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
                      "Back>>",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return home();
                          },
                        ));
                      },
                      color: Color(0xff0095ff),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child:
                          //
                          Text(
                        "View product",
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
      ),
    );
  }

  TextEditingController proname = TextEditingController();
  TextEditingController proprice = TextEditingController();
  TextEditingController prodesctription = TextEditingController();
}

class updates {
  int? connection;
  int? result;

  updates({this.connection, this.result});

  updates.fromJson(Map<String, dynamic> json) {
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
