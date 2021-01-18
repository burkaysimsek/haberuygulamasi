import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:haber_uygulamasi/Sayfalar/anasayfa.dart';
import 'package:haber_uygulamasi/data/sharedprefs.dart';
import 'package:provider/provider.dart';
import 'package:haber_uygulamasi/data/data.dart';
import 'package:flutter/material.dart';
import 'package:haber_uygulamasi/data/data.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Color> colors = [Colors.teal, Colors.blue];
  int _index = 0;
  var kadiikontrol;
  bool basildimi = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email1.text = "";
    kadi.text = "";
    email.text = "";
    sifre2.text = "";
    sifre1.text = "";
    sifre.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: Get.back,
        ),
        backgroundColor: Colors.white,
      ),
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Tabs(context),
                AnimatedCrossFade(
                  duration: Duration(milliseconds: 150),
                  firstChild: Login(context),
                  secondChild: SignUp(context),
                  crossFadeState: _index == 0
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget Login(BuildContext context) {
    final controller = Get.put(LoginIslemleri());
    return Form(
      key: _formKey2,
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 15, right: 15),
        child: Column(
          children: <Widget>[
            Column(children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, left: 15, right: 15, bottom: 15),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: email,
                        validator: (String email) {
                          return validateEmail(email);
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.grey,
                            ),
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.black87),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent))),
                      ),
                      Divider(color: Colors.grey, height: 8),
                      TextFormField(
                        controller: sifre,
                        validator: (String sifre) {
                          return validateSifre(sifre);
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            labelText: "Şifre",
                            labelStyle: TextStyle(color: Colors.black87),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent))),
                      ),
                      Divider(
                        color: Colors.transparent,
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if (basildimi == false) {
                      if (_formKey2.currentState.validate()) {
                        setState(() {
                          basildimi = true;
                        });
                        _formKey2.currentState.save();
                        try {
                          final result = await FirebaseFirestore.instance
                              .collection('users')
                              .where('email', isEqualTo: email.text)
                              .get();

                          girisisim = result.docs[0]['kullaniciAdi'];

                          if (girisisim != null) {
                            await controller.girisYap(email.text, sifre.text);

                            Get.offAll(AnaSayfa());
                          }
                        } catch (e) {
                          setState(() {
                            basildimi = false;
                          });
                        }
                      }
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: colors,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Center(
                          child: basildimi == false
                              ? Text(
                                  "GİRİŞ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )
                              : CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.green),
                                )),
                    ),
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 45.0),
              child: GestureDetector(
                child: Center(
                    child: Text(
                  "Şifrenimi unuttun ? ",
                  style: TextStyle(color: Colors.grey[800], fontSize: 16),
                )),
                onTap: () {},
              ),
            ) /*
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 55,
                    height: 1,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      "Veya",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 55,
                    height: 1,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset('assets/google.png'),
                      ),
                    ),
                    onTap: () {},
                  ),
                  Container(
                    width: 55,
                  ),
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset('assets/fb.png'),
                      ),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            */
          ],
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  Widget SignUp(BuildContext context) {
    final controller = Get.put(LoginIslemleri());
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 15, right: 15),
        child: Column(
          children: <Widget>[
            Column(children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, left: 15, right: 15, bottom: 15),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: email1,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.grey,
                            ),
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.black87),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent))),
                        validator: (String email) {
                          return validateEmail(email);
                        },
                      ),
                      Divider(color: Colors.grey, height: 8),
                      TextFormField(
                        controller: kadi,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.grey,
                            ),
                            labelText: "Kullanıcı adı",
                            labelStyle: TextStyle(color: Colors.black87),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent))),
                        validator: (kadi) {
                          if (kadiikontrol == false) {
                            return 'Farklı bir kullanıcı adı seçin';
                          }
                        },
                      ),
                      Divider(color: Colors.grey, height: 8),
                      TextFormField(
                        controller: sifre1,
                        validator: (String sifre) {
                          return validateSifre1(sifre);
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            labelText: "Şifre",
                            labelStyle: TextStyle(color: Colors.black87),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent))),
                      ),
                      Divider(color: Colors.grey, height: 8),
                      TextFormField(
                        controller: sifre2,
                        validator: (String sifre) {
                          return validateSifre2(sifre);
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            labelText: "Onayla",
                            labelStyle: TextStyle(color: Colors.black87),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent))),
                      ),
                      Divider(
                        color: Colors.transparent,
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    await run();
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      await controller.hesapOlustur(
                          email1.text, sifre2.text, kadi.text);

                      Map<String, String> veriMap = {
                        "kullaniciAdi": kadi.text,
                        "email": email1.text,
                        "profilResim": "null"
                      };

                      await addData(veriMap);
                      Get.offAll(AnaSayfa());
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: colors,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Center(
                          child: Text(
                        "KAYIT OL",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )),
                    ),
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 55,
                    height: 1,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      "Veya",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 55,
                    height: 1,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset('assets/google.png'),
                      ),
                    ),
                    onTap: () {},
                  ),
                  Container(
                    width: 55,
                  ),
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset('assets/fb.png'),
                      ),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Tabs(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30.0, left: 15, right: 15),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.12),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Container(
                      decoration: BoxDecoration(
                          color: _index == 0
                              ? Colors.grey[350]
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(25)),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Giriş Yap",
                          style: TextStyle(
                              color: _index == 0 ? Colors.black : Colors.grey,
                              fontSize: 18,
                              fontWeight: _index == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ))),
                  onTap: () {
                    setState(() {
                      _index = 0;
                    });
                  },
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                      decoration: BoxDecoration(
                          color: _index == 1
                              ? Colors.grey[350]
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(25)),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Üye Ol",
                          style: TextStyle(
                              color: _index == 1 ? Colors.black : Colors.grey,
                              fontSize: 18,
                              fontWeight: _index == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ))),
                  onTap: () {
                    setState(() {
                      _index = 1;
                    });
                  },
                ),
              )
            ],
          )),
    );
  }

  Future run() async {
    var response = await kadiKontrol(kadi.text);
    if (this.mounted) {
      setState(() {
        kadiikontrol = response;
      });
    }
  }
}
