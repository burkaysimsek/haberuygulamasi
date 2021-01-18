import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:haber_adminpanel/sayfalar/data.dart';

class Istatistik extends StatefulWidget {
  @override
  _IstatistikState createState() => _IstatistikState();
}

class _IstatistikState extends State<Istatistik> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    haberDetay();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  var userCount, dataCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: dataCount == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  buildStack1(
                      userCount,
                      "Toplam Kullanıcı",
                      0xFFFF27ae60,
                      Icon(
                        Icons.supervised_user_circle,
                        size: 50,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  buildStack1(
                      dataCount,
                      "Toplam Haber",
                      0xFFFFe67e22,
                      Icon(
                        Icons.view_module,
                        size: 50,
                      )),
                ],
              ),
            ),
    );
  }

  haberDetay() {
    try {
      Stream<QuerySnapshot> streamQuery =
          FirebaseFirestore.instance.collection('ayarlar').snapshots();
      streamQuery.listen((QuerySnapshot data) {
        setState(() {
          userCount = data.docs[0]['userCount'].toString();
          dataCount = data.docs[0]['dataCount'].toString();
        });
      });
    } catch (e) {
      print("hata");
    }
  }

  Stack buildStack1(sayi, yazi, renk, icon) {
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: new BoxDecoration(
            color: Color(renk),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.1), BlendMode.dstATop),
                  image: AssetImage('assets/chart.png')),
            ),
          ),
        ),
        Positioned(
            top: 80,
            left: 10,
            child: FloatingActionButton(
              elevation: 20,
              onPressed: null,
              backgroundColor: Colors.transparent,
              child: icon,
            )),
        Padding(
          padding: const EdgeInsets.only(top: 70, right: 30),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              sayi,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          top: 150,
          left: 10,
          child: Text(
            yazi,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
