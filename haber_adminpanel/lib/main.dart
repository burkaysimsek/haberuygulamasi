import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haber_adminpanel/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber_adminpanel/sayfalar/data.dart';
import 'package:haber_adminpanel/sayfalar/haber_ekleme.dart';
import 'package:haber_adminpanel/sayfalar/istatistik.dart';
import 'package:haber_adminpanel/sayfalar/tum_haberler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SiberHane Admin Panel',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  PageController _controller = PageController(
    initialPage: 0,
  );
  int currentPage = 0;

  double boyut;
  String boyutt;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: appBar,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              height: 50,
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  width: 10,
                ),
                shrinkWrap: true,
                itemBuilder: (ctx, i) {
                  return Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: FlatButton(
                        onPressed: () {
                          _controller.animateToPage(i,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        },
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                sayfalar[i],
                                style: TextStyle(
                                    color: currentPage == i
                                        ? Color(0xFFFF6236ff)
                                        : Colors.black.withOpacity(0.6)),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            currentPage == i
                                ? Container(
                                    height: 3,
                                    width: sayfalar[i].length * 6.toDouble(),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5)),
                                      color: Color(0xFFFF6236ff),
                                    ),
                                  )
                                : Container()
                          ],
                        )),
                  );
                },
                itemCount: sayfalar.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
            Expanded(
                child: PageView(
              controller: _controller,
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              children: [
                Istatistik(),
                ItemEkle(),
                TumData(),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

final appBar = AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    actions: [
      Icon(
        Icons.settings,
        color: Colors.black,
      ),
    ],
    title: RichText(
      text: TextSpan(children: [
        WidgetSpan(
            child: Container(
          height: 17,
          child: Image.asset('assets/menu.png'),
        )),
        WidgetSpan(
            child: SizedBox(
          width: 10,
        )),
        TextSpan(
          text: 'Haber',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        TextSpan(
          text: '24',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.red,
          ),
        ),
      ]),
    ));
