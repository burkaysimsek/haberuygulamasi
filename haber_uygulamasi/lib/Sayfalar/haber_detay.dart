import 'dart:async';

import 'package:animated_button/animated_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:haber_uygulamasi/Sayfalar/detay.dart';
import 'package:haber_uygulamasi/Sayfalar/yorumlar.dart';
import 'package:haber_uygulamasi/data/admobIslemleri.dart';
import 'package:haber_uygulamasi/data/data.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:share/share.dart';

import 'package:timeago/timeago.dart' as timeago;

class HaberDetay extends StatefulWidget {
  String baslik;
  String id;

  HaberDetay({this.baslik, this.id});
  @override
  _HaberDetayState createState() => _HaberDetayState();
}

InterstitialAd myInterstitialAd;

class _HaberDetayState extends State<HaberDetay> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      if (AdmobIslemleri.mybannerAd != null) {
        AdmobIslemleri.mybannerAd.dispose();
        AdmobIslemleri.mybannerAd = null;
      }
      AdmobIslemleri.mybannerAd.dispose();
    });
    if (kackere2 == 0) {
      myInterstitialAd = AdmobIslemleri.buildInterstitialAd();
      myInterstitialAd
        ..load()
        ..show();
      kackere2++;
    }

    haberDetay(widget.baslik);
    begenilmismi(widget.id, girisId);
  }

  bool yorum = false;

  String _baslik, _icerik, _resim, _begeni = "0", _tarih, _kategori;
  bool begenilmis = false;
  int sayi = 0;

  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Stack(
          alignment: Alignment.topCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            //Main Image
            mainImageWidget(height),

            //Bottom Sheet
            Container(
              //Bottom Sheet Dimensions
              margin: EdgeInsets.only(top: height / 2.3),
              decoration: BoxDecoration(
                color: theme ? Color(0xFF121212) : Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),

              child: bottomContent(height, width),
            ),
          ],
        ),
      ),
    ));
  }

  Widget mainImageWidget(height) => _resim == null
      ? CircularProgressIndicator()
      : Container(
          height: height / 2,
          decoration: BoxDecoration(
            image:
                DecorationImage(image: NetworkImage(_resim), fit: BoxFit.cover),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 48, left: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: theme ? Colors.black : Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Row(
                    children: [
                      IconButton(
                          enableFeedback: false,
                          icon: Icon(
                              begenilmis
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: begenilmis ? Colors.red : Colors.white),
                          onPressed: () async {
                            if (sayi != 1) {
                              sayi = 1;
                              await calistir();
                            }
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Share.share(widget.baslik);
                          })
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

  calistir() async {
    if (girisId == null) {
      Get.snackbar("Hata", "Giriş yapın veya üye olun",
          margin: EdgeInsets.all(20), snackPosition: SnackPosition.BOTTOM);
    } else if (begenilmis == false) {
      await likeArttir(widget.id, girisId);
      await begenilmismi(widget.id, girisId);
      sayi = 0;
    } else if (begenilmis == true) {
      await likeDelete(widget.id, girisId);
      await begenilmismi(widget.id, girisId);
      sayi = 0;
    }
  }

  begenilmismi(postId, userId) async {
    try {
      Future<DocumentSnapshot> docSnapshot =
          FirebaseFirestore.instance.collection('veriler').doc(postId).get();
      DocumentSnapshot doc = await docSnapshot;
      if (doc['begenenler'].contains(userId)) {
        setState(() {
          begenilmis = true;
        });
      } else {
        setState(() {
          begenilmis = false;
        });
      }
    } catch (e) {
      print("hata");
    }
  }

  Widget bottomContent(height, width) => _kategori == null
      ? CircularProgressIndicator()
      : Container(
          margin: EdgeInsets.only(top: height / 20),
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _kategori.toUpperCase(),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange),
                ),

                SizedBox(
                  height: 12,
                ),
                Text(
                  _baslik,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: theme ? Colors.white : Colors.black),
                ),

                SizedBox(
                  height: 12,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      color: Colors.grey,
                      size: 16,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      timeago.format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(_tarih),
                        ),
                        locale: 'tr',
                      ),
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    IconButton(
                        iconSize: 20,
                        icon: Icon(
                            begenilmis
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: begenilmis ? Colors.red : Colors.grey),
                        onPressed: () async {
                          if (sayi != 1) {
                            sayi = 1;
                            await calistir();
                          }
                        }),
                    Text(
                      _begeni,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    )
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                //Profile Pic
                Row(
                  children: <Widget>[
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://img.freepik.com/free-vector/flat-design-vector-male-coder-working_23-2148269033.jpg?size=338&ext=jpg"))),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Admin",
                      style: TextStyle(
                          fontSize: 14,
                          color: theme ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),

                SizedBox(
                  height: 30,
                ),

                //Paragraph
                HtmlWidget(
                  _icerik,
                  textStyle: TextStyle(
                      color: theme ? Colors.white : Colors.black54,
                      height: 1.4),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(Yorumlar(widget.id));
                    },
                    child: Container(
                      width: width / 1,
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
                            Icon(Icons.comment, color: Colors.white70),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Yorumlar',
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
                ),
                SizedBox(
                  height: 40,
                ),
                onerilenler2(_kategori)
              ],
            ),
          ),
        );

  haberDetay(baslik) {
    try {
      Stream<QuerySnapshot> streamQuery = FirebaseFirestore.instance
          .collection('veriler')
          .where('baslik', isEqualTo: widget.baslik)
          .snapshots();
      streamQuery.listen((QuerySnapshot data) {
        if (this.mounted) {
          setState(() {
            _icerik = data.docs[0]['icerik'].toString();
            _baslik = data.docs[0]['baslik'].toString();
            _resim = data.docs[0]['kapakResim'].toString();
            _tarih = data.docs[0]['tarih'].toString();
            _begeni = data.docs[0]['begeni'].toString();
            _kategori = data.docs[0]['kategori'].toString();
          });
        }
      });
    } catch (e) {
      print("hata");
    }
  }
}
