import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haber_adminpanel/sayfalar/data.dart';
import 'package:haber_adminpanel/sayfalar/haber_detay.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class TumData extends StatefulWidget {
  @override
  _TumDataState createState() => _TumDataState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
PaginateRefreshedChangeListener refreshChangeListener =
    PaginateRefreshedChangeListener();

class _TumDataState extends State<TumData> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: verilerAna(),
    );
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
              color: Colors.white54,
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 9,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(20))),
          padding: EdgeInsets.only(bottom: 10),
          child: Column(children: [
            Stack(
              children: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 50, left: 10, bottom: 10),
                        child: Container(
                            width: 100.00,
                            height: 100.00,
                            decoration: new BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              image: new DecorationImage(
                                image: NetworkImage(resim),
                                fit: BoxFit.fitHeight,
                              ),
                            )),
                      ),
                    ),
                    VerticalDivider(
                      width: 20,
                      thickness: 3,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 5, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            RawMaterialButton(
                              onPressed: () {},
                              elevation: 2.0,
                              fillColor: Colors.grey,
                              child: Icon(
                                Icons.edit,
                                size: 30.0,
                              ),
                              padding: EdgeInsets.all(15.0),
                              shape: CircleBorder(),
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                Get.dialog(
                                  AlertDialog(
                                      title: Text(
                                        "Uyarı",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: Text(
                                        "Silmek istediğinizden eminmisiniz ? \n(Geri alınamaz)",
                                        style: TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                            child: Text(
                                              "SİL",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  letterSpacing: 2),
                                            ),
                                            onPressed: () {
                                              Get.back();
                                              Get.snackbar(
                                                  "Başarılı", "Veri silindi.",
                                                  margin: EdgeInsets.all(20),
                                                  snackPosition:
                                                      SnackPosition.BOTTOM);

                                              deletePost(id);
                                              refreshChangeListener.refreshed =
                                                  true;
                                            }),
                                        FlatButton(
                                          child: Text("İPTAL"),
                                          onPressed: () {
                                            Get.back();
                                          },
                                        ),
                                      ]),
                                );
                              },
                              elevation: 2.0,
                              fillColor: Colors.red,
                              child: Icon(
                                Icons.delete_outline,
                                size: 30.0,
                              ),
                              padding: EdgeInsets.all(15.0),
                              shape: CircleBorder(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(baslik,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
                ),
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
                        timeago
                            .format(
                              DateTime.fromMillisecondsSinceEpoch(
                                int.parse(tarih),
                              ),
                              locale: 'tr',
                            )
                            .toString(),
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
            )
          ])));
}

verilerAna() {
  return Padding(
      padding: const EdgeInsets.all(10.0),
      child: RefreshIndicator(
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
              .orderBy("tarih", descending: true),

          listeners: [
            refreshChangeListener,
          ],
        ),
        onRefresh: () async {
          refreshChangeListener.refreshed = true;
        },
      ));
}
