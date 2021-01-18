import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:haber_uygulamasi/data/admobIslemleri.dart';
import 'package:haber_uygulamasi/data/data.dart';
import 'package:timeago/timeago.dart' as timeago;

class Yorumlar extends StatelessWidget {
  final id;
  Yorumlar(this.id);

  @override
  Widget build(BuildContext context) {
    try {
      return ScrollConfiguration(
          behavior: MyBehavior(),
          child: Scaffold(
            backgroundColor: theme ? Color(0xFF121212) : Colors.white,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: theme ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
              backgroundColor: theme ? Color(0xFF212121) : Colors.white,
              title: Text(
                "Yorumlar",
                style: TextStyle(color: theme ? Colors.white : Colors.black),
              ),
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("comments")
                          .where("postId", isEqualTo: id)
                          .orderBy('tarih', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            'Yükleniyor',
                          );
                        }
                        if (snapshot.data.documents.length == 0 ||
                            snapshot.hasError == true) {
                          return Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Henüz yorum yok',
                            ),
                          );
                        } else if (snapshot.data.documents.length != 0) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot ds =
                                    snapshot.data.documents[index];
                                if (snapshot.hasError) {
                                  print(snapshot.hasError);
                                }
                                return _listeyorum(context, ds, index);
                              });
                        }
                      },
                    ),
                  ],
                ),
                yorumKismi(id)
              ],
            ),
          ));
    } catch (e) {}
  }
}

final yorumalani = TextEditingController();

Widget _listeyorum(BuildContext context, DocumentSnapshot snapshot, int index) {
  final Controller c = Get.find();
  try {
    return GetBuilder<Controller>(
        builder: (_) => Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: theme
                        ? Border.all(color: Colors.grey.withOpacity(0.4))
                        : Border.all(color: Colors.grey.withOpacity(0.2)),
                    color: theme ? Color(0xFF212121) : Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(snapshot["profilresim"]),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                snapshot["yorumYapan"],
                                style: TextStyle(
                                    color: theme ? Colors.white : Colors.black,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                timeago.format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(snapshot['tarih']),
                                  ),
                                  locale: 'tr',
                                ),
                                style: TextStyle(
                                  color: theme
                                      ? Colors.grey
                                      : Colors.grey.withOpacity(0.5),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            snapshot['yorumicerik'],
                            style: TextStyle(
                                color:
                                    theme ? Colors.white70 : Colors.grey[900]),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  } catch (e) {}
}

final border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(90.0)),
    borderSide: BorderSide(
      color: Colors.transparent,
    ));

yorumKismi(id) {
  InterstitialAd myInterstitialAd;
  final Controller c = Get.find();
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      color: theme ? Colors.grey[900] : Colors.grey[400],
      height: 60,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: TextFormField(
            textInputAction: TextInputAction.done,
            style: TextStyle(color: theme ? Colors.white : Colors.black),
            inputFormatters: [
              LengthLimitingTextInputFormatter(400),
            ],
            controller: yorumalani,
            decoration: InputDecoration(
                focusedBorder: border,
                enabledBorder: border,
                border: border,
                disabledBorder: border,
                suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    color: Colors.white,
                    onPressed: () {
                      if (girisId != null) {
                        c.yorumEkle(id, yorumalani.text);
                        yorumalani.text = "";
                        if (kackere == 0) {
                          myInterstitialAd =
                              AdmobIslemleri.buildInterstitialAd();
                          myInterstitialAd
                            ..load()
                            ..show();
                          kackere++;
                        }
                      } else {
                        Future.delayed(Duration(milliseconds: 500), () {
                          if (kackere3 == 0) {
                            myInterstitialAd =
                                AdmobIslemleri.buildInterstitialAd();
                            myInterstitialAd
                              ..load()
                              ..show();
                            kackere3++;
                          }
                        });

                        Get.snackbar("Hata", "Giriş yapın veya üye olun",
                            margin: EdgeInsets.all(20),
                            snackPosition: SnackPosition.TOP);
                      }
                    }),
                contentPadding: EdgeInsets.all(10),
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                filled: true,
                fillColor: theme ? Colors.grey[800] : Colors.grey[350],
                hintText: "Yorumunuz..."),
          ),
        ),
      ),
    ),
  );
}
