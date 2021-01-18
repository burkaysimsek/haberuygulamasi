import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber_uygulamasi/Sayfalar/haber_detay.dart';
import 'package:haber_uygulamasi/data/admobIslemleri.dart';
import 'package:haber_uygulamasi/data/data.dart';
import 'package:haber_uygulamasi/data/sharedprefs.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';

import 'package:timeago/timeago.dart' as timeago;

class DetaySayfasi extends StatefulWidget {
  @override
  _DetaySayfasiState createState() => _DetaySayfasiState();
}

class _DetaySayfasiState extends State<DetaySayfasi> {
  final controller = PageController();
  bool yorum;
  static const _adUnitID = "ca-app-pub-3940256099942544/2247696110";
  double _height;

  final _nativeAdController = NativeAdmobController();
  StreamSubscription _subscription;
  @override
  void initState() {
    super.initState();
    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    _nativeAdController
        .setTestDeviceIds(["ecd76ed9-28b5-43c8-bf1b-8a1a09a8ca47"]);
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          _height = 0;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          _height = 200;
        });
        break;

      default:
        break;
    }
  }

  Widget chipp(String label, Color color) {
    return Opacity(
      opacity: 0.8,
      child: Transform(
        transform: new Matrix4.identity()..scale(0.9),
        child: Chip(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2))),
          labelPadding: EdgeInsets.symmetric(horizontal: 10),
          label: Text(
            label,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
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
              color: theme ? Color(0xFF303030) : Colors.white,
              border: theme
                  ? Border.all(width: 0.2, color: Colors.grey)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: theme ? Color(0xFF121212) : Colors.white,
        body: verilerAna());
  }

  header() {
    return Column(
      children: [
        Container(
          height: 250,
          child: PageIndicatorContainer(
            child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: list1.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(HaberDetay(
                        id: list4[index],
                        baslik: list1[index],
                      ));
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 230,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: NetworkImage(
                                list2[index],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black.withOpacity(0.5),
                              ),
                              height: 130,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 5, 0),
                            child: chipp(list3[index], Colors.cyan),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      list1[index],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  );
                }),
            align: IndicatorAlign.bottom,
            indicatorSpace: 8.0,
            padding: EdgeInsets.all(5.0),
            indicatorColor: Colors.grey,
            indicatorSelectorColor: Colors.yellow,
            shape: IndicatorShape.circle(size: 5.0),
            length: list2.length,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            height: 35,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
            ),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Son Haberler",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: theme ? Colors.white : Color(0xFF2c3e50),
                        )),
                  ),
                ),
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Divider(
            height: 30,
            thickness: 0.7,
            color: theme
                ? Colors.white.withOpacity(0.2)
                : Colors.black.withOpacity(0.2)),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  verilerAna() {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: PaginateFirestore(
            header: header(),
            footer: SizedBox(
              height: 50,
            ),
            shrinkWrap: true,
            //item builder type is compulsory.
            itemBuilderType:
                PaginateBuilderType.listView, //Change types accordingly
            itemBuilder: (index, context, documentSnapshot) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Column(
                  children: [
                    liste(
                      documentSnapshot['kapakResim'],
                      documentSnapshot['baslik'],
                      documentSnapshot['kategori'],
                      documentSnapshot.id,
                      documentSnapshot['tarih'],
                      documentSnapshot['begeni'],
                    ),
                    index == 100
                        ? Container(
                            height: _height,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(bottom: 20.0),
                            child: NativeAdmob(
                              numberAds: 2,
                              // Your ad unit id
                              adUnitID: _adUnitID,
                              loading: Container(),
                              error: Container(),
                              controller: _nativeAdController,
                              type: NativeAdmobType.full,
                            ),
                          )
                        : Container(),
                  ],
                )),

            // orderBy is compulsory to enable pagination
            query: FirebaseFirestore.instance
                .collection("veriler")
                .orderBy("tarih", descending: true)));
  }
}
