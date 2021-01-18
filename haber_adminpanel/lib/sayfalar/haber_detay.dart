import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber_adminpanel/sayfalar/data.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:timeago/timeago.dart' as timeago;

class HaberDetay extends StatefulWidget {
  String baslik;
  String id;

  HaberDetay({this.baslik, this.id});
  @override
  _HaberDetayState createState() => _HaberDetayState();
}

class _HaberDetayState extends State<HaberDetay> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    haberDetay(widget.baslik);
  }

  bool yorum = false;
  final yorumalani = TextEditingController();
  String _baslik, _icerik, _resim, _begeni = "0", _tarih;
  bool begenilmis = false;
  int sayi = 0;
  FocusNode _focus = new FocusNode();

  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xFF121212),
        body: yorum == false
            ? SingleChildScrollView(
                child: Container(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    overflow: Overflow.visible,
                    children: <Widget>[
                      //Main Image
                      mainImageWidget(height),

                      //Bottom Sheet
                      Container(
                        //Bottom Sheet Dimensions
                        margin: EdgeInsets.only(top: height / 2.3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),

                        child: bottomContent(height, width),
                      ),
                    ],
                  ),
                ),
              )
            : yorumlar());
  }

  Widget mainImageWidget(height) => Container(
        height: height / 2,
        decoration: BoxDecoration(
          image:
              DecorationImage(image: NetworkImage(_resim), fit: BoxFit.cover),
        ),
        child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 48, left: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.share, color: Colors.white),
                        onPressed: () {})
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget bottomContent(height, width) => Container(
        margin: EdgeInsets.only(top: height / 20),
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Category
              Text(
                "TEKNOLOJİ",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange),
              ),

              SizedBox(
                height: 12,
              ),

              //Title
              Text(
                _baslik,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),

              SizedBox(
                height: 12,
              ),

              //like and duration
              Row(
                children: <Widget>[
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
                        int.parse(_tarih),
                      ),
                      locale: 'tr',
                    ),
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),

              SizedBox(
                height: 20,
              ),

              //Profile Pic
              Row(
                children: <Widget>[
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://images.unsplash.com/photo-1506919258185-6078bba55d2a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"))),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Admin",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),

              SizedBox(
                height: 30,
              ),

              //Paragraph
              HtmlWidget(
                _icerik,
                textStyle: TextStyle(color: Colors.black54, height: 1.4),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      yorum = true;
                    });
                  },
                  child: Container(
                    width: width / 1,
                    height: 35,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.teal,
                          Colors.teal[200],
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(5, 5),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.comment, color: Colors.white70),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Yorumlar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _listeyorum(BuildContext context, DocumentSnapshot snapshot) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.4)),
              color: Colors.white60,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Row(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(snapshot['profilresim']),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            snapshot['yorumYapan'] + "  ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            timeago.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                int.parse(snapshot['tarih']),
                              ),
                              locale: 'tr',
                            ),
                            style: TextStyle(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        snapshot['yorumicerik'],
                        style: TextStyle(color: Colors.grey[900]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () {
                    yorumSil(snapshot.id);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    setState(() {
      yorum = false;
    });
    return false; // return true if the route to be popped
  }

  deneme() {
    setState(() {
      yorum = false;
    });
  }

  yorumlar() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: deneme,
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Yorumlar",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
          ),
        ),
      ),
      body: WillPopScope(
          onWillPop: _willPopCallback,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("comments")
                    .where("postId", isEqualTo: widget.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text(
                        'Yükleniyor',
                      ),
                    );
                  }
                  if (snapshot.data.documents.length == 0) {
                    return Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Henüz yorum yok',
                      ),
                    );
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.documents[index];

                          return _listeyorum(context, ds);
                        });
                  }
                },
              ),
            ],
          )),
    );
  }

  haberDetay(baslik) {
    try {
      Stream<QuerySnapshot> streamQuery = FirebaseFirestore.instance
          .collection('veriler')
          .where('baslik', isEqualTo: widget.baslik)
          .snapshots();
      streamQuery.listen((QuerySnapshot data) {
        if (this.mounted) {
          setState(() {
            _icerik = data.docs[0]['icerik'].toString();
            _baslik = data.docs[0]['baslik'].toString();
            _resim = data.docs[0]['kapakResim'].toString();
            _tarih = data.docs[0]['tarih'].toString();
          });
        }
      });
    } catch (e) {
      print("hata");
    }
  }
}
