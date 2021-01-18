import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haber_uygulamasi/Sayfalar/anasayfa.dart';
import 'package:haber_uygulamasi/Sayfalar/hakkimda.dart';
import 'package:haber_uygulamasi/data/sharedprefs.dart';
import 'package:haber_uygulamasi/main.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:haber_uygulamasi/data/data.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

final eskisifre = TextEditingController();
final yenisifre = TextEditingController();
final yenisifre2 = TextEditingController();

class _SettingsPageState extends State<SettingsPage> {
  bool showPassword = false;
  int sayi = 0;
  bool isActive = true, isActive2 = false, isDark = SharedPrefs.getTheme;
  final Controller c = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      backgroundColor: theme ? Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: theme ? Color(0xFF121212) : Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
        ),
      ),
      body: GetBuilder<Controller>(
        builder: (_) => Container(
          padding: EdgeInsets.only(left: 16, top: 25, right: 16),
          child: ListView(
            children: [
              Text(
                "Ayarlar",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: theme ? Colors.white : Colors.black),
              ),
              Center(
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 10))
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            girisresim,
                          ))),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Hesap",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme ? Colors.white : Colors.black),
                  ),
                ],
              ),
              Divider(
                height: 15,
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (girisId != null) {
                    c.sayi > 3
                        ? Get.snackbar(
                            "Hata", "Çok hızlı fotoğraf değiştiriyosunuz.")
                        : c.chooseFile();
                  } else {
                    Get.snackbar("Hata", "Giriş yapın veya üye olun",
                        margin: EdgeInsets.all(20),
                        snackPosition: SnackPosition.TOP);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Profil Fotoğrafını Değiştir.",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: theme ? Colors.grey[350] : Colors.grey[600],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              buildAccountOptionRow(context, "Şifreni Değiştir", 1),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Icon(
                    Icons.volume_up_outlined,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Bildirimler",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme ? Colors.white : Colors.black),
                  ),
                ],
              ),
              Divider(
                height: 15,
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Önemli Bildirimler",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: theme ? Colors.grey[350] : Colors.grey[600],
                        ),
                      ),
                      Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            trackColor: Colors.grey,
                            value: isActive,
                            onChanged: (value) {
                              setState(() {
                                isActive = value;
                              });
                            },
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tüm Bildirimler",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: theme ? Colors.grey[350] : Colors.grey[600],
                        ),
                      ),
                      Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            trackColor: Colors.grey,
                            value: isActive2,
                            onChanged: (value) {
                              setState(() {
                                isActive2 = value;
                              });
                            },
                          ))
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Icon(
                    Icons.code,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Uygulama",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              Divider(
                height: 15,
                thickness: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Siyah Tema",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: theme ? Colors.grey[350] : Colors.grey[600],
                    ),
                  ),
                  Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        trackColor: Colors.grey,
                        value: isDark,
                        onChanged: (value) {
                          isDark = value;
                          if (isDark == true) {
                            SharedPrefs.saveTheme(isDark);
                            Get.to(AnaSayfa());
                          } else {
                            SharedPrefs.saveTheme(isDark);
                            Get.to(AnaSayfa());
                          }
                        },
                      ))
                ],
              ),
              buildAccountOptionRow(context, "Hakkımda", 3),
              buildAccountOptionRow(context, "Privacy and security", 2),
              SizedBox(
                height: 30,
              ),
              Center(
                child: OutlineButton(
                  borderSide: BorderSide(
                    color: theme
                        ? Colors.white.withOpacity(0.4)
                        : Colors.black.withOpacity(0.4),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    SharedPrefs.sharedClear();
                    girisyapmismi = false;
                    girisresim = null;
                    giriseposta = null;
                    girisisim = null;
                    girisyapmismi = false;
                    Get.offAll(AnaSayfa());
                  },
                  child: Text(
                    "ÇIKIŞ YAP",
                    style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 2.2,
                        color: theme ? Colors.white : Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

GestureDetector buildAccountOptionRow(
    BuildContext context, String title, int secilen) {
  return GestureDetector(
    onTap: () {
      switch (secilen) {
        case 1:
          {
            if (girisisim != null) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(title),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: eskisifre,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Eski Şifre',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: yenisifre,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Yeni Şifre',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: yenisifre2,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Yeni Şifre Tekrarla',
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            child: RaisedButton(
                              padding: const EdgeInsets.all(8.0),
                              textColor: Colors.white,
                              color: Colors.blue,
                              onPressed: () async {
                                final Controller c = Get.find();
                                if (yenisifre.text == yenisifre2.text) {
                                  yenisifre.text = "";
                                  eskisifre.text = "";
                                  yenisifre2.text = "";
                                  await c.eskisifreKontrol(
                                      eskisifre.text, yenisifre.text);
                                } else {
                                  Get.snackbar("Hata", "Şifreleriniz uyuşmuyor",
                                      snackPosition: SnackPosition.TOP,
                                      margin: EdgeInsets.all(20));
                                }
                              },
                              child: Text("Değiştir"),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Kapat")),
                      ],
                    );
                  });
            } else {
              Get.snackbar("Hata", "Giriş yapın veya üye olun",
                  snackPosition: SnackPosition.TOP, margin: EdgeInsets.all(20));
            }
          }
          break;
        case 2:
          {
            _launchURL();
          }
          break;
        case 3:
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Hakkimda()),
            );
          }
      }
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: theme ? Colors.grey[350] : Colors.grey[600],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          ),
        ],
      ),
    ),
  );
}

_launchURL() async {
  const url =
      'https://www.privacypolicies.com/live/41e3b7d3-3616-4cc1-a56a-7e025b174b73';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
