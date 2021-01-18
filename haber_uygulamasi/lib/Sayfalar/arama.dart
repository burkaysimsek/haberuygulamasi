import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haber_uygulamasi/Sayfalar/haber_detay.dart';
import 'package:haber_uygulamasi/data/admobIslemleri.dart';
import 'package:haber_uygulamasi/data/data.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

final Controller c = Get.put(Controller());
BannerAd mybannerAd;

class _SearchState extends State<Search> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final TextEditingController searchController = TextEditingController();
  QuerySnapshot snapshotData;
  bool isExcecuted = false;
  String name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme ? Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        leading: Container(),
        leadingWidth: 0,
        backgroundColor: theme ? Color(0xFF121212) : Colors.white,
        elevation: 0,
        primary: false,
        title: TextField(
          decoration: InputDecoration(
              hintText: "Arama yapın...",
              hintStyle: TextStyle(color: theme ? Colors.white : Colors.black),
              suffixIcon: IconButton(
                  icon: Icon(Icons.search,
                      color: theme ? Colors.white : Colors.black),
                  onPressed: () {})),
          onChanged: (val) => initiateSearch(val),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: StreamBuilder<QuerySnapshot>(
          stream: name != "" && name != null
              ? FirebaseFirestore.instance
                  .collection('veriler')
                  .where("aramaAnahtar", isGreaterThanOrEqualTo: name)
                  .where('aramaAnahtar', isLessThan: name + "z")
                  .snapshots()
              : FirebaseFirestore.instance
                  .collection("veriler")
                  .limit(5)
                  .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return new ListView(
                  shrinkWrap: true,
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(HaberDetay(
                            id: document.id,
                            baslik: document['baslik'],
                          ));
                        },
                        child: new ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              document['kapakResim'],
                            ),
                          ),
                          title: new Text(
                            document['baslik'],
                            style: TextStyle(
                                color: theme ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
            }
          },
        ),
      ),
    );
  }

  void initiateSearch(String val) {
    setState(() {
      name = val.trim().toLowerCase();
    });
  }
}
