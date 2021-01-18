import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber_uygulamasi/Sayfalar/haber_detay.dart';
import 'package:haber_uygulamasi/data/admobIslemleri.dart';
import 'package:haber_uygulamasi/data/data.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class KDetaySayfasi extends StatefulWidget {
  @override
  String kategori;
  String resimx;

  KDetaySayfasi({this.kategori, this.resimx});

  _KDetaySayfasiState createState() => _KDetaySayfasiState();
}

class _KDetaySayfasiState extends State<KDetaySayfasi> {
  final controller = PageController();
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
                padding: const EdgeInsets.only(left: 10, bottom: 10),
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
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  backgroundColor: Colors.grey,
                  title: Text(
                    widget.kategori,
                    style:
                        TextStyle(color: theme ? Colors.white70 : Colors.white),
                  ),
                  leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      color: theme ? Colors.white70 : Colors.black),
                  expandedHeight: 120.0,
                  floating: true,
                  snap: true,
                  pinned: true,
                  flexibleSpace: Stack(
                    children: <Widget>[
                      Positioned.fill(
                          child: Image.network(
                        widget.resimx,
                        fit: BoxFit.cover,
                      ))
                    ],
                  ),
                ),
              ];
            },
            body: verilerAna()));
  }

  header() {
    return Column(
      children: [
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
              height: 20,
            ),

            //item builder type is compulsory.
            itemBuilderType:
                PaginateBuilderType.listView, //Change types accordingly
            itemBuilder: (index, context, documentSnapshot) => Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: liste(
                    documentSnapshot['kapakResim'],
                    documentSnapshot['baslik'],
                    documentSnapshot['kategori'],
                    documentSnapshot.id,
                    documentSnapshot['tarih'],
                    documentSnapshot['begeni'],
                  ),
                ),

            // orderBy is compulsory to enable pagination
            query: FirebaseFirestore.instance
                .collection("veriler")
                .orderBy("tarih", descending: true)
                .where("kategori", isEqualTo: widget.kategori)));
  }
}
