import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myshop/Updatepage.dart';
import 'package:myshop/splashscreen.dart';
import 'dart:developer' as developer;

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  // @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int cnt = 1;
  List<Widget> list1 = [Addproduct(), Viewproduct()];
  String? name;
  String? email;
  String? imagepath;
  bool stat = false;
  @override
  void initState() {
    super.initState();

    name = Mysplash.pref!.getString("name") ?? "";
    email = Mysplash.pref!.getString("email") ?? "";
    imagepath = Mysplash.pref!.getString("imagename") ?? "";

    print("=====$imagepath");
    setState(() {
      stat = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return stat
        ? Scaffold(
            appBar: AppBar(title: Text("Myshop")),
            body: list1[cnt],
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                      currentAccountPicture: Image.network(
                          "https://tonal-phase.000webhostapp.com/APIcalling/$imagepath"),
                      accountName: Text("$name"),
                      accountEmail: Text("$email")),
                  // const DrawerHeader(
                  //     decoration: BoxDecoration(color: Colors.blue),
                  //     child: Text("Home")),
                  ListTile(
                    leading: Icon(Icons.add_rounded),
                    title: const Text('Add Product'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        cnt = 0;
                      });
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.remove_red_eye),
                    title: const Text('View Product'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        cnt = 1;
                      });
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}

//Add product

class Addproduct extends StatefulWidget {
  const Addproduct({Key? key}) : super(key: key);

  @override
  State<Addproduct> createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {
  String? userid;
  String imgg = "";
  @override
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    setState(() {
      userid = Mysplash.pref!.getString("id");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 40,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return home();
                },
              ));
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 110,
                      child: InkWell(
                        onTap: () async {
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            imgg = image!.path;
                          });
                        },
                        child: Container(
                          child: imgg != ""
                              ? CircleAvatar(
                                  maxRadius: 60,
                                  backgroundImage: FileImage(File(imgg)),
                                )
                              : Icon(
                                  Icons.add_a_photo,
                                  size: 100,
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
                        child: TextField(
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
                        child: TextField(
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
                      debugPrint("Yes");
                      String pname = proname.text;
                      String pprice = proprice.text;
                      String pdesctription = prodesctription.text;
                      List<int> iii = File(imgg).readAsBytesSync();
                      String imagg = base64Encode(iii);

                      Map map = {
                        "userid": userid,
                        "pronname": pname,
                        "proprize": pprice,
                        "prodes": pdesctription,
                        "imagdata": imagg
                      };

                      var url = Uri.parse(
                          'https://tonal-phase.000webhostapp.com/APIcalling/Addproduct.php'); //enter my table/view url
                      var response = await http.post(url, body: map);
                      debugPrint(
                          "Yes${response.body}    yy${response.statusCode}");
                      debugPrint('Response status: ${response.statusCode}');
                      print('Response body: ${response.body}');

                      var jsonn = jsonDecode(response.body);
                      addpro addpr = addpro.fromJson(jsonn);
                      setState(() {
                        print("${addpr.connection}");
                      });

                      if (addpr.connection == 1) {
                        if (addpr.result == 1) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Product Added Successfully"),
                            duration: Duration(seconds: 10),
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
                      "Add Product",
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
                      "Update product>>",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    MaterialButton(
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(
                        //   builder: (context) {
                        //     return updateproduct();
                        //   },
                        // ));
                      },
                      color: Color(0xff0095ff),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child:
                          //
                          Text(
                        "Update",
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

  bool pronm = false;
  bool proprc = false;
  bool prodesc = false;
}

class addpro {
  int? connection;
  int? result;

  addpro({this.connection, this.result});

  addpro.fromJson(Map<String, dynamic> json) {
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

//view product....

class Viewproduct extends StatefulWidget {
  const Viewproduct({Key? key}) : super(key: key);

  @override
  State<Viewproduct> createState() => _ViewproductState();
}

class _ViewproductState extends State<Viewproduct> {
  String? userid;      //null
  String imggg = "";   //blank
  @override
  final ImagePicker _picker = ImagePicker();

  String? loginid;
  viewdata? myproduct;
  bool stats = false;

  String all = 'loginId';

  @override
  void initState() {
    super.initState();
    setState(() {
      loginid = Mysplash.pref!.getString("id") ?? "";
    });

    setState(() {
      userid = Mysplash.pref!.getString("id");
    });

    getproduct();
  }

  getproduct() async {
    var url = Uri.parse(
        "https://tonal-phase.000webhostapp.com/APIcalling/viewproduct.php");
    var response = await http.post(url, body: {"userid": loginid});
    print('Response status: ${response.statusCode}');
    print('Response status: ${response.body}');
    debugPrint('Response status: ${response.statusCode}');
    developer.log('Response status: ${response.body}');
    var jd = jsonDecode(response.body);
    myproduct = viewdata.fromJson(jd);
    setState(() {
      stats = true;
    });
  }

  Widget build(BuildContext context) {
    return stats
        ? Scaffold(
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: myproduct!.productdata!.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(3),
                  color: Colors.brown,
                  height: 150,
                  width: 150,
                  child: Card(
                    elevation: 5,
                    color: Colors.deepPurpleAccent,
                    shadowColor: Colors.blueGrey,
                    child: ListTile(
                      title: Text(
                          "Uid: ${myproduct!.productdata![index].loginId}"),
                      subtitle: Text(
                          "Pname: ${myproduct!.productdata![index].proname}"),

                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == 1) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return Updatepage(
                                  myproduct!.productdata![index].productId!,
                                  myproduct!.productdata![index].proimage!,
                                  myproduct!.productdata![index].proprize!,
                                  myproduct!.productdata![index].prodes!,
                                  myproduct!.productdata![index].proname!,
                                  myproduct!.productdata![index].loginId!
                                );
                              },
                            ));
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                                onTap: () async {
                                  debugPrint("Yes");

                                  String? deleteproduct =
                                      myproduct!.productdata![index].productId;

                                  var url = Uri.parse(
                                      'https://tonal-phase.000webhostapp.com/APIcalling/deleteproduct.php'); //enter my table/view url
                                  var response = await http.post(url,
                                      body: {"productid": deleteproduct});
                                  debugPrint(
                                      "res${response.body}${response.statusCode}");
                                  debugPrint(
                                      'Response status: ${response.statusCode}');
                                  print('Response body: ${response.body}');

                                  var jsonn = jsonDecode(response.body);
                                  deleteclass addpr =
                                      deleteclass.fromJson(jsonn);
                                  setState(() {
                                    print("${addpr.connection}");
                                  });

                                  if (addpr.connection == 1) {
                                    if (addpr.result == 1) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Product DELETE Successfully",
                                            softWrap: true,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.redAccent)),
                                        duration: Duration(seconds: 7),
                                      ));
                                    }
                                  }
                                },
                                value: 0,
                                child: Text("Delete")),
                            PopupMenuItem(
                                onTap: () {
                                  print("Update clicked");
                                },
                                value: 1,
                                child: Text("Update")),
                          ];
                        },
                      ),

                      // trailing: IconButton(
                      //     onPressed: () async {
                      //       debugPrint("Yes");
                      //
                      //         String? deleteproduct =
                      //            myproduct!.productdata![index].productId;
                      //
                      //
                      //       var url = Uri.parse(
                      //           'https://tonal-phase.000webhostapp.com/APIcalling/deleteproduct.php'); //enter my table/view url
                      //       var response = await http
                      //           .post(url, body: {"productid": deleteproduct});
                      //       debugPrint(
                      //           "res${response.body}${response.statusCode}");
                      //       debugPrint(
                      //           'Response status: ${response.statusCode}');
                      //       print('Response body: ${response.body}');
                      //
                      //       var jsonn = jsonDecode(response.body);
                      //       deleteclass addpr = deleteclass.fromJson(jsonn);
                      //       setState(() {
                      //         print("${addpr.connection}");
                      //       });
                      //
                      //       if (addpr.connection == 1) {
                      //         if (addpr.result == 1) {
                      //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //             content: Text("Product DELETE Successfully",softWrap: true,style: TextStyle(fontSize: 20,color: Colors.redAccent)),
                      //             duration: Duration(seconds: 7),
                      //           ));
                      //         }
                      //       }
                      //
                      //       // var jsonn = jsonDecode(response.body);
                      //       // deletepro remove = deletepro.fromJson(jsonn);
                      //       // setState(() {
                      //       //   print("${remove.connection}");
                      //       // });
                      //       //
                      //       // if (remove.connection == 1) {
                      //       //   if (remove.result == 1) {
                      //       //     ScaffoldMessenger.of(context)
                      //       //         .showSnackBar(SnackBar(
                      //       //       content: Text("Delete Success"),
                      //       //       duration: Duration(seconds: 10),
                      //       //     ));
                      //       //   }
                      //       // }
                      //     },
                      //     icon: Icon(
                      //       Icons.delete,
                      //       color: Colors.redAccent,
                      //     )),
                      // trailing: Container(
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(1),
                      //       border: Border()),
                      //   child: MaterialButton(
                      //       minWidth: 1,
                      //       height: 10,
                      //       onPressed: () async {
                      //         debugPrint("Yes");
                      //
                      //         var url = Uri.parse(
                      //             'https://tonal-phase.000webhostapp.com/APIcalling/deleteproduct.php'); //enter my table/view url
                      //         // var response = await http.post(url, body: delete);
                      //         // debugPrint(
                      //         //     "Yes${response.body}    yy${response.statusCode}");
                      //         // debugPrint(
                      //         //     'Response status: ${response.statusCode}');
                      //         // print('Response body: ${response.body}');
                      //       },
                      //       color: Color(0xff0095ff),
                      //       elevation: 0,
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(50),
                      //       ),
                      //       child: Icon(Icons.delete)),
                      // ),
                      leading: Image.network(
                          'https://tonal-phase.000webhostapp.com/APIcalling/${myproduct!.productdata![index].proimage}'),
                      textColor: Colors.lightGreen,
                    ),
                  ),
                );
              },
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  TextEditingController proname1 = TextEditingController();
  TextEditingController proprice1 = TextEditingController();
  TextEditingController prodesctription1 = TextEditingController();
}

class deleteclass {
  int? connection;
  int? result;

  deleteclass({this.connection, this.result});

  deleteclass.fromJson(Map<String, dynamic> json) {
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

class viewdata {
  int? connection;
  int? result;
  List<Productdata>? productdata;

  viewdata({this.connection, this.result, this.productdata});

  viewdata.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    result = json['result'];
    if (json['productdata'] != null) {
      productdata = <Productdata>[];
      json['productdata'].forEach((v) {
        productdata!.add(new Productdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connection'] = this.connection;
    data['result'] = this.result;
    if (this.productdata != null) {
      data['productdata'] = this.productdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Productdata {
  String? productId;
  String? loginId;
  String? proname;
  String? proprize;
  String? prodes;
  String? proimage;

  Productdata(
      {this.productId,
      this.loginId,
      this.proname,
      this.proprize,
      this.prodes,
      this.proimage});

  Productdata.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    loginId = json['login_id'];
    proname = json['proname'];
    proprize = json['proprize'];
    prodes = json['prodes'];
    proimage = json['proimage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['login_id'] = this.loginId;
    data['proname'] = this.proname;
    data['proprize'] = this.proprize;
    data['prodes'] = this.prodes;
    data['proimage'] = this.proimage;
    return data;
  }
}
//
// // update product
// //
// class updateproduct extends StatefulWidget {
//   const updateproduct({Key? key}) : super(key: key);
//
//   @override
//   State<updateproduct> createState() => _updateproductState();
// }
//
// class _updateproductState extends State<updateproduct> {
//   String? userid;
//   String imggg = "";
//   @override
//   final ImagePicker _picker = ImagePicker();
//
//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       userid = Mysplash.pref!.getString("id");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 40,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pushReplacement(context, MaterialPageRoute(
//                 builder: (context) {
//                   return home();
//                 },
//               ));
//             },
//             icon: Icon(
//               Icons.arrow_back_ios,
//               size: 20,
//               color: Colors.black,
//             )),
//       ),
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             width: double.infinity,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Column(
//                   children: [
//                     SizedBox(
//                       height: 110,
//                       child: InkWell(
//                         onTap: () async {
//                           final XFile? image = await _picker.pickImage(
//                               source: ImageSource.gallery);
//                           setState(() {
//                             imggg = image!.path;
//                           });
//                         },
//                         child: Container(
//                           child: imggg != ""
//                               ? CircleAvatar(
//                                   maxRadius: 60,
//                                   backgroundImage: FileImage(File(imggg)),
//                                 )
//                               : Icon(
//                                   Icons.add_a_photo,
//                                   size: 100,
//                                 ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: Container(
//                       padding: EdgeInsets.only(top: 5, left: 1),
//                       child: Container(
//                         margin: EdgeInsets.all(20),
//                         child: TextField(
//                           controller: proname1,
//                           decoration: InputDecoration(
//                               labelText: "Product name",
//                               hintText: "Enter Product",
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(50))),
//                         ),
//                       )),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: Container(
//                       padding: EdgeInsets.only(top: 5, left: 1),
//                       child: Container(
//                         margin: EdgeInsets.all(20),
//                         child: TextField(
//                           controller: proprice1,
//                           decoration: InputDecoration(
//                               labelText: "Set Price",
//                               hintText: "Enter Price",
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(50))),
//                         ),
//                       )),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: Container(
//                       padding: EdgeInsets.only(top: 5, left: 1),
//                       child: Container(
//                         margin: EdgeInsets.all(20),
//                         child: TextField(
//                           controller: prodesctription1,
//                           decoration: InputDecoration(
//                               labelText: "Add Desctription",
//                               hintText: " Enter Desctription ",
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(50))),
//                         ),
//                       )),
//                 ),
//                 Container(
//                   padding: EdgeInsets.only(top: 3, left: 3),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(50),
//                       border: Border()),
//                   child: MaterialButton(
//                     minWidth: double.infinity,
//                     height: 40,
//                     onPressed: () async {
//                       debugPrint("Yes");
//                       String pname = proname1.text;
//                       String pprice = proprice1.text;
//                       String pdesctription = prodesctription1.text;
//                       List<int> iii = File(imggg).readAsBytesSync();
//                       String imagg = base64Encode(iii);
//
//                       Map map = {
//                         "userid": userid,
//                         "pronname": pname,
//                         "proprize": pprice,
//                         "prodes": pdesctription,
//                         "imagdata": imagg
//                       };
//
//                       var url = Uri.parse(
//                           'https://tonal-phase.000webhostapp.com/APIcalling/updateproduct.php'); //enter my table/view url
//                       var response = await http.post(url, body: map);
//                       debugPrint(
//                           "Yes${response.body}    ${response.statusCode}");
//                       debugPrint('Response status: ${response.statusCode}');
//                       print('Response body: ${response.body}');
//                     },
//                     color: Color(0xff0095ff),
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                     child: Text(
//                       "Update Product",
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Back to Product>>",
//                       style:
//                           TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
//                     ),
//                     MaterialButton(
//                       onPressed: () {
//                         Navigator.push(context, MaterialPageRoute(
//                           builder: (context) {
//                             return Viewproduct();
//                           },
//                         ));
//                       },
//                       color: Color(0xff0095ff),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(50)),
//                       child:
//                           //
//                           Text(
//                         "Product",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 18),
//                       ),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   TextEditingController proname1 = TextEditingController();
//   TextEditingController proprice1 = TextEditingController();
//   TextEditingController prodesctription1 = TextEditingController();
// }
