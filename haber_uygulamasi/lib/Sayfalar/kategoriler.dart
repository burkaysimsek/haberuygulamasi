import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haber_uygulamasi/Sayfalar/kategori_detay.dart';
import 'package:haber_uygulamasi/data/admobIslemleri.dart';
import 'package:haber_uygulamasi/data/data.dart';

final List<IconData> icons = [
  Icons.new_releases,
  Icons.computer,
  Icons.drafts,
];

class Kategoriler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme ? Color(0xFF121212) : Colors.white,
      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(kategoriResim.length, (index) {
          return kategori(index);
        }),
      ),
    );
  }
}

kategori(index) {
  return InkWell(
    onTap: () {
      Get.to(KDetaySayfasi(
        kategori: kategoriler[index],
        resimx: kategoriResim[index],
      ));
    },
    child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 15, 5, 10),
        child: Container(
          width: 100.0,
          height: 150.0,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  kategoriler[index],
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: NetworkImage(kategoriResim[index])),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.redAccent,
          ),
        )),
  );
}
