import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage1;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber_uygulamasi/Sayfalar/anasayfa.dart';
import 'package:haber_uygulamasi/Sayfalar/ayarlar.dart';
import 'package:haber_uygulamasi/Sayfalar/detay.dart';
import 'package:flutter/foundation.dart';
import 'package:haber_uygulamasi/Sayfalar/giris.dart';
import 'package:haber_uygulamasi/Sayfalar/kategori_detay.dart';
import 'package:haber_uygulamasi/Sayfalar/haber_detay.dart';
import 'package:haber_uygulamasi/data/sharedprefs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'menu_item.dart';

bool girisyapmismi, theme;
String girisisim, giriseposta, girisresim, girisId, girisloginId;
String sifree;
String sifree1;
String isim;
String profilresim;
String icerik, baslik, resim;

final email = TextEditingController();
final email1 = TextEditingController();
final sifre = TextEditingController();
final sifre1 = TextEditingController();
final sifre2 = TextEditingController();
final kadi = TextEditingController();
DateTime today = new DateTime.now();
DateTime fiftyDaysAgo = today.subtract(new Duration(days: 30));
final gunonce =
    Timestamp.fromMillisecondsSinceEpoch(fiftyDaysAgo.millisecondsSinceEpoch);

List<String> kategoriler = [];
List<String> kategoriResim = [];
String kategori = "";
int currentPage = 0;
List list1 = [];
List list2 = [];
List list3 = [];
List list4 = [];
List list5 = [];
int kackere = 0, kackere2 = 0, kackere3 = 0;
List colors = [Colors.blue, Colors.green, Colors.yellow, Colors.green];
Random random = new Random();
Future listBuilder() async {
  List<DocumentSnapshot> list = [];
  FirebaseFirestore.instance
      .collection('comments')
      .snapshots()
      .listen((data) => data.docs.forEach((doc) => list.add(doc)));

  return list;
}

Future<void> resetPassword(String email) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}

onerilenler2(kategori) {
  return FutureBuilder<dynamic>(
    future: onerilenler(), // function where you call your api
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      // AsyncSnapshot<Your object type>
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container();
      } else {
        if (snapshot.hasError)
          return Center(child: Text('Error: ${snapshot.error}'));
        else
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "İlginizi Çekebilir",
                style: TextStyle(
                    color: theme ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: 70,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Colors.deepPurple,
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return new ListTile(
                        contentPadding: EdgeInsets.all(5),
                        leading: Container(
                          width: 100.0,
                          height: 150.0,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                          ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    snapshot.data.docs[index]['kapakResim'])),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            color: Colors.redAccent,
                          ),
                        ),
                        title: Text(
                          snapshot.data.docs[index]['baslik'],
                          style: TextStyle(
                              color: theme ? Colors.white70 : Colors.grey[900]),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HaberDetay(
                                      baslik: snapshot.data.docs[index]
                                          ['baslik'],
                                      id: snapshot.data.docs[index].id,
                                    )),
                          );
                        });
                  }),
            ],
          );
      }
    },
  );
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class Controller extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File _image;
  int sayi = 0;
  List resim = [];

  String urll, deneme;

  eskisifreKontrol(eskisifre, yenisifre) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: giriseposta, password: eskisifre);
      sifreDegistir(yenisifre);
    } catch (e) {
      Get.snackbar("Hata", "Eski şifreniz hatalı",
          snackPosition: SnackPosition.TOP, margin: EdgeInsets.all(20));
    }
  }

  Future queryData(String queryString) async {
    return FirebaseFirestore.instance
        .collection('veriler')
        .where('baslik', isGreaterThanOrEqualTo: queryString)
        .get();
  }

  yorumEkle(id, text) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where("kullaniciAdi", isEqualTo: girisisim)
        .get();

    Map<String, String> veriMapp = {
      "postId": id,
      "id": result.docs.first.id,
      "profilresim": result.docs[0]['profilResim'] == null
          ? "https://assets.stickpng.com/images/585e4bf3cb11b227491c339a.png"
          : result.docs[0]['profilResim'],
      "yorumicerik": text,
      "yorumYapan": girisisim,
      "tarih": DateTime.now().millisecondsSinceEpoch.toString()
    };

    await yorumEklee(veriMapp);
  }

  Future<void> yorumEklee(yorumData) async {
    FirebaseFirestore.instance.collection("comments").add(yorumData);
    update();
  }

  yorumProfil(girisisim) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection('users')
          .where("kullaniciAdi", isEqualTo: girisisim)
          .get();
      resim.add(result.docs[0]['profilResim']);
      update();
    } catch (e) {}
  }

  Future chooseFile() async {
    try {
      await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      ).then((image) async {
        _image = image;
        await uploadPic();
      });
    } catch (e) {
      Get.snackbar("Hata", "Resim Seçilmedi.");
    }
  }

  Future uploadPic() async {
    try {
      storage1.FirebaseStorage storage = storage1.FirebaseStorage.instance;

      storage1.Reference ref =
          storage.ref().child("image1" + DateTime.now().toString());
      storage1.UploadTask uploadTask = ref.putFile(_image);
      uploadTask.whenComplete(() async {
        urll = await ref.getDownloadURL();
        girisresim = urll;
        SharedPrefs.savePhoto(girisresim);
        sayi++;
        profilResmiKaydet(giriseposta);
        update();
      }).catchError((onError) {
        print(onError);
      });
    } catch (e) {
      Get.snackbar("Hata", "Resim Seçilmedi.");
    }
  }
}

profilResmiKaydet(email) async {
  final result = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email)
      .get();
  await FirebaseFirestore.instance
      .collection('users')
      .doc(result.docs.first.id)
      .update({"profilResim": girisresim});
}

sifreDegistir(yenisifre) async {
  //Create an instance of the current user.
  User user = FirebaseAuth.instance.currentUser;

  //Pass in the password to updatePassword.
  user.updatePassword(yenisifre).then((_) {
    Get.snackbar("Başarılı", "Şifreniz Değiştirildi",
        snackPosition: SnackPosition.TOP, margin: EdgeInsets.all(20));
  }).catchError((error) {
    print("Password can't be changed" + error.toString());
    //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
  });
}

tiklananBildirim(id) async {
  Get.to(HaberDetay(
    id: id,
    baslik: baslik,
  ));
}

girisKontrol() {
  girisisim = SharedPrefs.getName;
  giriseposta = SharedPrefs.getMail;
  girisresim = SharedPrefs.getPhoto;
  girisId = SharedPrefs.getId;
  girisloginId = SharedPrefs.getloginId;
  girisyapmismi = SharedPrefs.getLogin;
  theme = SharedPrefs.getTheme;
}

Future getDocs(context) async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection("kategoriler").get();
  for (int i = 0; i < querySnapshot.docs.length; i++) {
    var a = querySnapshot.docs[i];

    kategoriler.add(a.id);

    kategoriResim.add(a['resim']);
  }
  kategori = kategoriler[0];
}

veriGetir() async {
  final result = await FirebaseFirestore.instance
      .collection('veriler')
      .where('kart', isEqualTo: "true")
      .get();

  list1.clear();
  list2.clear();
  list3.clear();
  list4.clear();

  for (int i = 0; i < result.docs.length; i++) {
    var a = result.docs[i];

    list1.add(a.get("baslik"));
    list2.add(a.get("kapakResim"));
    list3.add(a.get("kategori"));
    list4.add(a.id);
  }
}

kontrolKullanici(email) async {
  final result = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email)
      .get();
  if (result.docs.isEmpty) {
    girisresim = result.docs[0].toString();
  }
  return result.docs.isEmpty;
}

onerilenler() async {
  int sayi;
  var rng = new Random();
  sayi = rng.nextInt(1);
  final result = await FirebaseFirestore.instance
      .collection('veriler')
      .where("begeni", isGreaterThanOrEqualTo: sayi)
      .limit(5)
      .get();
  return result;
}

class LoginIslemleri extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  hesapOlustur(email, sifre, name) async {
    try {
      UserCredential _user = await _auth.createUserWithEmailAndPassword(
          email: email, password: sifre);
      SharedPrefs.saveMail(email1.text);
      SharedPrefs.saveName(kadi.text);
      SharedPrefs.saveId(_user.user.uid);
      SharedPrefs.login();
      return true;
    } catch (e) {
      Get.snackbar("Hata", "$e");
      return false;
    }
  }

  girisYap(email, sifre) async {
    UserCredential _user =
        await _auth.signInWithEmailAndPassword(email: email, password: sifre);
    SharedPrefs.saveMail(email);
    SharedPrefs.saveloginId(_user.user.uid);

    SharedPrefs.saveName(girisisim);
    SharedPrefs.saveId(_user.user.uid);

    SharedPrefs.login();
    profilresmiGetir(email);

    return true;
  }
}

profilresmiGetir(email) async {
  final result = await FirebaseFirestore.instance
      .collection('users')
      .where("email", isEqualTo: email)
      .get();
  girisresim = result.docs[0]['profilResim'].toString();
  SharedPrefs.savePhoto(girisresim);
}

kullaniciSayiDegistir(sayi) async {
  await FirebaseFirestore.instance
      .collection('ayarlar')
      .doc('ayarlar')
      .update({"userCount": FieldValue.increment(sayi)});
}

String validateEmail(String email) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (email.isEmpty)
    return 'Email alanı boş bırakılamaz';
  else if (!regex.hasMatch(email))
    return 'Geçerli bir email adresi giriniz';
  else
    return null;
}

Future<void> addData(blogData) async {
  FirebaseFirestore.instance.collection("users").add(blogData);
  await kullaniciSayiDegistir(1);
}

String validateSifre1(String sifre) {
  if (sifre.isEmpty) {
    return 'Şifre alanı boş bırakılamaz';
  } else if (sifre.length < 6) {
    return "Şifreniz 6'dan küçük olamaz";
  } else {
    sifree = sifre1.text;
  }
}

haberKayit(userId, haberId) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(girisloginId)
      .update({
    "kayitliHaberler": FieldValue.arrayUnion([haberId])
  });
}

kullaniciAdi(String kadi) {
  if (kadi.isEmpty) {
    return 'Kullanıcı adı boş bırakılamaz';
  } else if (kadi.length < 3) {
    return "Kullanıcı adı 3'den küçük olamaz";
  } else {}
}

Future<bool> kadiKontrol(String username) async {
  final result = await FirebaseFirestore.instance
      .collection('users')
      .where('kullaniciAdi', isEqualTo: username)
      .get();
  return result.docs.isEmpty;
}

String validateSifre2(String sifre) {
  if (sifre.isEmpty) {
    return 'Şifre alanı boş bırakılamaz';
  } else if (sifre.length < 6) {
    return "Şifreniz 6'dan küçük olamaz";
  } else {
    if (sifre == sifree) {
      sifree1 = sifre;
    } else {
      return 'Şifreleriniz uyuşmuyor';
    }
  }
}

String validateSifre(String sifre) {
  if (sifre.isEmpty) {
    return 'Şifre alanı boş bırakılamaz';
  } else if (sifre.length < 6) {
    return "Şifreniz 6'dan küçük olamaz";
  }
}

likeArttir(id, userId) async {
  await FirebaseFirestore.instance
      .collection('veriler')
      .doc(id)
      .update({"begeni": FieldValue.increment(1)});

  await FirebaseFirestore.instance.collection('veriler').doc(id).update({
    "begenenler": FieldValue.arrayUnion([userId])
  });
}

likeDelete(id, userId) async {
  await FirebaseFirestore.instance
      .collection('veriler')
      .doc(id)
      .update({"begeni": FieldValue.increment(-1)});

  await FirebaseFirestore.instance.collection('veriler').doc(id).update({
    "begenenler": FieldValue.arrayRemove([userId])
  });
}

Widget chipdetay(String label, Color color) {
  return Opacity(
    opacity: 0.8,
    child: Transform(
      transform: new Matrix4.identity()..scale(0.9),
      child: Chip(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(5),
          topLeft: Radius.circular(5),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
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

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: theme ? Color(0xFF212121) : Colors.white,
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: theme ? Color(0xFF121212) : Color(0xFFced6e0),
                ),
                accountName: girisyapmismi == true
                    ? Text(
                        girisisim,
                        style: TextStyle(
                            color: theme ? Colors.white : Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )
                    : null,
                accountEmail: girisyapmismi == true
                    ? Text(
                        giriseposta,
                        style: TextStyle(
                            color: theme ? Colors.grey[400] : Colors.black54,
                            fontSize: 13),
                      )
                    : GestureDetector(
                        onTap: () {
                          Get.to(Home());
                        },
                        child: Text(
                          "Giriş yapın veya üye olun.",
                          style: TextStyle(
                              color: theme ? Colors.white : Colors.grey),
                        ),
                      ),
                currentAccountPicture: girisyapmismi == true
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(girisresim),
                      )
                    : Icon(
                        Icons.supervised_user_circle,
                        color: theme ? Colors.white : Colors.black,
                        size: 80,
                      )),
            Expanded(
              child: ListView.builder(
                  itemCount: kategoriler.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        onTap: () {
                          Get.to(KDetaySayfasi(
                            kategori: kategoriler[index],
                            resimx: kategoriResim[index],
                          ));
                        },
                        splashColor: colors[index],
                        child: ListTile(
                          leading: Icon(
                            Icons.category,
                            color: colors[index],
                          ),
                          title: Text(
                            kategoriler[index],
                            style: TextStyle(
                                color: theme ? Colors.white : Colors.black),
                          ),
                          trailing: Icon(Icons.chevron_right,
                              color: theme ? Colors.white : Colors.black),
                        ));
                  }),
            ),
            Divider(
              height: 64,
              thickness: 0.5,
              color: Colors.black.withOpacity(0.4),
              indent: 32,
              endIndent: 32,
            ),
            MenuItem(
              icon: Icons.settings,
              title: "Ayarlar",
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
