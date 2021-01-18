import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber_uygulamasi/Sayfalar/haber_detay.dart';
import 'package:haber_uygulamasi/data/data.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class GundemSayfasi extends StatefulWidget {
  @override
  _GundemSayfasiState createState() => _GundemSayfasiState();
}

class _GundemSayfasiState extends State<GundemSayfasi> {
  final controller = PageController();
  bool yorum;
  @override
  void initState() {
    super.initState();
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

  liste(
    resim,
    baslik,
    kategori,
    id,
  ) {
    return GestureDetector(
        onTap: () async {
          Get.to(HaberDetay(
            id: id,
            baslik: baslik,
          ));
        },
        child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xFF424242),
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
                        height: 150,
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
                      padding: EdgeInsets.all(10),
                      child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            baslik,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          )),
                    ),
                  ),
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xFF121212), body: veriler());
  }

  veriler() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 20),
        child: PaginateFirestore(

            //item builder type is compulsory.
            itemBuilderType: PaginateBuilderType.listView,
            itemBuilder: (index, context, documentSnapshot) => liste(
                documentSnapshot['kapakResim'],
                documentSnapshot['baslik'],
                documentSnapshot['kategori'],
                documentSnapshot.id),

            // orderBy is compulsory to enable pagination
            query: FirebaseFirestore.instance
                .collection("veriler")
                .where("tarih", isGreaterThan: gunonce.seconds * 1000)
                .orderBy('tarih', descending: true)));
  }

  header() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "En çok okunan haberler",
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Divider(
          height: 30,
          thickness: 0.5,
          color: Colors.white.withOpacity(0.3),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
