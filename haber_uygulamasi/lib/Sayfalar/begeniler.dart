import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haber_uygulamasi/Sayfalar/haber_detay.dart';
import 'package:haber_uygulamasi/data/admobIslemleri.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:haber_uygulamasi/data/data.dart';
import 'package:timeago/timeago.dart' as timeago;

class BegenilenSayfasi extends StatefulWidget {
  @override
  _BegenilenSayfasiState createState() => _BegenilenSayfasiState();
}

InterstitialAd myInterstitialAd;

class _BegenilenSayfasiState extends State<BegenilenSayfasi> {
  @override
  void initState() {
    if (kackere == 0) {
      myInterstitialAd = AdmobIslemleri.buildInterstitialAd();
      myInterstitialAd
        ..load()
        ..show();
      kackere++;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme ? Color(0xFF121212) : Colors.white,
      body: verilerAna(),
    );
  }

  Widget chipp(String label, Color color) {
    return Opacity(
      opacity: 0.8,
      child: Transform(
        transform: new Matrix4.identity()..scale(0.9),
        child: Chip(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(5),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(20),
          )),
          labelPadding: EdgeInsets.symmetric(horizontal: 10),
          label: Text(
            label,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: color.withOpacity(0.5),
        ),
      ),
    );
  }

  liste(resim, baslik, kategori, id, tarih, begeni) {
    return GestureDetector(
        onTap: () async {
          Get.to(HaberDetay(
            id: id,
            baslik: baslik,
          ));
        },
        child: Container(
          decoration: BoxDecoration(
              color: theme ? Color(0xFF424242) : Colors.white,
              border: theme
                  ? Border.all(
                      width: 0.5,
                      color: Colors.white.withOpacity(
                        0.4,
                      ),
                    )
                  : Border.all(
                      width: 1,
                      color: Colors.grey.withOpacity(
                        0.4,
                      ),
                    ),
              borderRadius: BorderRadius.all(Radius.circular(3))),
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(3),
                          topRight: Radius.circular(3)),
                      image: DecorationImage(
                          fit: BoxFit.cover, image: NetworkImage(resim)),
                    ),
                    height: 170,
                    width: double.infinity,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: chipp(kategori, Colors.cyan),
                    ),
                  )
                ],
              ),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        baslik,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: theme ? Colors.white : Colors.black87),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.grey,
                          size: 16,
                        ),
                        SizedBox(
                          height: 30,
                          width: 5,
                        ),
                        Text(
                          timeago.format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(tarih),
                            ),
                            locale: 'tr',
                          ),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.thumb_up,
                          size: 18,
                          color: Colors.grey[400],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          begeni.toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  verilerAna() {
    if (girisId != null) {
      return Padding(
          padding: const EdgeInsets.all(10.0),
          child: PaginateFirestore(
              footer: SizedBox(
                height: 100,
              ),

              //item builder type is compulsory.
              itemBuilderType:
                  PaginateBuilderType.listView, //Change types accordingly
              itemBuilder: (index, context, documentSnapshot) => liste(
                    documentSnapshot['kapakResim'],
                    documentSnapshot['baslik'],
                    documentSnapshot['kategori'],
                    documentSnapshot.id,
                    documentSnapshot['tarih'],
                    documentSnapshot['begeni'],
                  ),

              // orderBy is compulsory to enable pagination
              query: FirebaseFirestore.instance
                  .collection("veriler")
                  .where("begenenler", arrayContains: girisId)));
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Giriş yapın veya üye olun",
              style: TextStyle(color: theme ? Colors.white : Colors.black),
            ),
          ],
        ),
      );
    }
  }
}
