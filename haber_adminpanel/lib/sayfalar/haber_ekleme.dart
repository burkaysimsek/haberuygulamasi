import 'dart:async';
import 'package:get/get.dart';
import 'package:haber_adminpanel/sayfalar/data.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_editor/html_editor.dart';
import 'package:timeago/timeago.dart' as timeago;

class ItemEkle extends StatefulWidget {
  @override
  _ItemEkleState createState() => _ItemEkleState();
}

String category;

class _ItemEkleState extends State<ItemEkle> {
  String selected;
  var _queryCat;
  GlobalKey<HtmlEditorState> keyEditor = GlobalKey();
  String result = "";

  List<String> kategoriler = [];

  final ScrollController _scrollController = ScrollController();
  final baslikk = TextEditingController();
  final resim = TextEditingController();
  bool focused = false;
  var dropDown;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocs();
  }

  final formKey = GlobalKey<FormState>();
  String resimUrl;
  String baslik;
  bool validate = false;
  AdminPanel adminPanel = new AdminPanel();

  var checkedValue = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    void _value1Changed(bool value) => setState(() => checkedValue = value);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            buildStreamBuilder(screenSize),
            Container(
              padding: EdgeInsets.all(18),
              child: Form(
                autovalidate: validate,
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(100),
                      ],
                      controller: resim,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Kapak Resim Url",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      validator: (String girilenVeri) {
                        if (girilenVeri == "" || girilenVeri == null) {
                          validate = true;
                          return "Resim Alanı Boş Bırakılamaz";
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(100),
                      ],
                      validator: (String girilenVeri) {
                        if (girilenVeri == "" || girilenVeri == null) {
                          validate = true;
                          return "Başlık Alanı Boş Bırakılamaz";
                        }
                      },
                      controller: baslikk,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Başlık",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.all(0),
                      value: checkedValue,
                      onChanged: _value1Changed,
                      title: new Text('Kartlara ekle'),
                      controlAffinity: ListTileControlAffinity.leading,
                      subtitle: new Text('Ana sayfadaki kartlara ekler.'),
                      activeColor: Colors.green,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Focus(
                      child: HtmlEditor(
                        hint: "Your text here...",
                        //value: "text content initial, if any",
                        key: keyEditor,
                        height: 400,
                      ),
                      onFocusChange: (hasFocus) {
                        if (hasFocus) {
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeInOut);
                        }
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final txt = await keyEditor.currentState.getText();
                        setState(() {
                          result = txt;
                          _kontrol();
                        });
                        if (formKey.currentState.validate() &&
                            category != null) {
                          baslik = baslikk.text;
                          resimUrl = resim.text;
                          Map<String, dynamic> veriMap = {
                            "kapakResim": resimUrl,
                            "icerik": result,
                            "baslik": baslik,
                            "kategori": category,
                            "begeni": "0",
                            "kart": checkedValue.toString(),
                            "tarih":
                                (Timestamp.now().seconds * 1000).toString(),
                            "aramaAnahtar": baslik
                                .toLowerCase()
                                .replaceAll(new RegExp(r"\s+"), "")
                          };

                          adminPanel.addData(veriMap);

                          Get.snackbar("Başarılı", "Veri eklendi",
                              margin: EdgeInsets.all(20),
                              snackPosition: SnackPosition.BOTTOM);
                        } else {
                          Get.snackbar("Hata", "Bir hata oluştu",
                              margin: EdgeInsets.all(20),
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1,
                        height: 35,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.teal,
                              Colors.teal[200],
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(5, 5),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save, color: Colors.white70),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                'Yayınla',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildStreamBuilder(Size screenSize) {
    return Center(
      child: new Container(
        width: screenSize.width * 0.9,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 0.5, //                   <--- border width here
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: new Row(
            children: <Widget>[
              new Expanded(
                  flex: 2,
                  child: new Container(
                    padding: EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
                    child: new Text(
                      "Kategori : ",
                    ),
                  )),
              new Expanded(
                flex: 4,
                child: new InputDecorator(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    //labelText: 'Activity',
                    hintText: 'Kategori seçin',
                    hintStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 16.0,
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  isEmpty: category == null,
                  child: DropdownButton(
                    isDense: true,
                    isExpanded: true,
                    value: category,
                    items: kategoriler.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        category = newValue;
                        dropDown = false;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getDocs() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("kategoriler").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      if (this.mounted) {
        setState(() {
          kategoriler.add(a.id);
        });
      }
    }
  }

  void _kontrol() {
    if (result != "") {
      formKey.currentState.validate();
    }
  }
}
