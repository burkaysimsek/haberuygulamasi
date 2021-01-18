import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haber_uygulamasi/Sayfalar/ayarlar.dart';
import 'package:haber_uygulamasi/data/data.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const MenuItem({Key key, this.icon, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(SettingsPage());
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: Colors.cyan,
              size: 30,
            ),
            SizedBox(
              width: 20,
            ),
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                    color: theme ? Colors.white : Colors.black))
          ],
        ),
      ),
    );
  }
}
