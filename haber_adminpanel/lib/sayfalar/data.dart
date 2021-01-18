import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haber_adminpanel/sayfalar/haber_ekleme.dart';

final List<String> sayfalar = [
  "İstatistik",
  "İtem Ekle",
  "Tüm Data",
];

int sayi = 1;
deletePost(id) {
  try {
    FirebaseFirestore.instance.collection("veriler").doc(id).delete();
    haberSayiDegistir(-1);
  } catch (r) {
    return false;
  }
}

yorumSil(id) {
  try {
    FirebaseFirestore.instance.collection("comments").doc(id).delete();
  } catch (r) {
    return false;
  }
}

haberSayiDegistir(sayi) async {
  await FirebaseFirestore.instance
      .collection('ayarlar')
      .doc('ayarlar')
      .update({"dataCount": FieldValue.increment(sayi)});
}

class AdminPanel {
  Future<void> addData(blogData) async {
    FirebaseFirestore.instance.collection("veriler").add(blogData);
    haberSayiDegistir(1);
  }
}
