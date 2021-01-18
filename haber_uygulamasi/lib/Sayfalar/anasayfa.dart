import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber_uygulamasi/Sayfalar/arama.dart';
import 'package:haber_uygulamasi/Sayfalar/begeniler.dart';
import 'package:haber_uygulamasi/Sayfalar/detay.dart';
import 'package:haber_uygulamasi/Sayfalar/gundem.dart';
import 'package:haber_uygulamasi/Sayfalar/kategoriler.dart';
import 'package:haber_uygulamasi/data/admobIslemleri.dart';
import 'package:haber_uygulamasi/data/data.dart';
import 'package:haber_uygulamasi/data/sharedprefs.dart';
import 'package:provider/provider.dart';
import 'package:haber_uygulamasi/data/bottom.dart';

enum BottomIcons { Anasayfa, Arama, Kaydedilenler, Kategori }

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    girisKontrol();
    if (SharedPrefs.getLogin) {
      kontrolkullanici();
    }
  }

  kontrolkullanici() async {
    if (await kontrolKullanici(giriseposta)) {
      SharedPrefs.sharedClear();
    } else {
      return null;
    }
  }

  BottomIcons bottomIcons = BottomIcons.Anasayfa;
  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: theme ? Color(0xFF212121) : Colors.white,
        leadingWidth: 0,
        elevation: 10,
        leading: Container(),
        actions: [],
        title: RichText(
          text: TextSpan(children: [
            WidgetSpan(
                child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState.openDrawer();
              },
              child: Container(
                height: 17,
                child: Image.asset(
                  "assets/images/menu.png",
                ),
              ),
            )),
            WidgetSpan(
                child: SizedBox(
              width: 10,
            )),
            TextSpan(
              text: 'Siber',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: theme ? Colors.white : Colors.black,
              ),
            ),
            TextSpan(
              text: 'Hane',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
          ]),
        ),
      ),
      body: Stack(
        children: <Widget>[
          bottomIcons == BottomIcons.Anasayfa ? DetaySayfasi() : Container(),
          bottomIcons == BottomIcons.Kaydedilenler
              ? BegenilenSayfasi()
              : Container(),
          bottomIcons == BottomIcons.Arama ? Search() : Container(),
          bottomIcons == BottomIcons.Kategori ? Kategoriler() : Container(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              decoration: BoxDecoration(
                  color: theme ? Color(0xFF212121) : Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5))),
              padding:
                  EdgeInsets.only(left: 24, right: 24, bottom: 10, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  BottomBar(
                      onPressed: () {
                        setState(() {
                          bottomIcons = BottomIcons.Anasayfa;
                        });
                      },
                      bottomIcons:
                          bottomIcons == BottomIcons.Anasayfa ? true : false,
                      icons: EvaIcons.home,
                      text: "Anasayfa"),
                  BottomBar(
                      onPressed: () {
                        setState(() {
                          bottomIcons = BottomIcons.Kategori;
                        });
                      },
                      bottomIcons:
                          bottomIcons == BottomIcons.Kategori ? true : false,
                      icons: EvaIcons.menu,
                      text: "Kategoriler"),
                  BottomBar(
                      onPressed: () {
                        setState(() {
                          bottomIcons = BottomIcons.Arama;
                        });
                      },
                      bottomIcons:
                          bottomIcons == BottomIcons.Arama ? true : false,
                      icons: EvaIcons.search,
                      text: "Arama"),
                  BottomBar(
                      onPressed: () {
                        setState(() {
                          bottomIcons = BottomIcons.Kaydedilenler;
                        });
                      },
                      bottomIcons: bottomIcons == BottomIcons.Kaydedilenler
                          ? true
                          : false,
                      icons: EvaIcons.heartOutline,
                      text: "Kaydedilenler"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
