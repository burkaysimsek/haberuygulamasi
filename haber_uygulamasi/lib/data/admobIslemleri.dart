import 'package:firebase_admob/firebase_admob.dart';

class AdmobIslemleri {
  static BannerAd mybannerAd;
  static final String admobTestId = FirebaseAdMob.testAppId;
  static admobIni() {
    FirebaseAdMob.instance.initialize(appId: admobTestId);
  }

  static reklamBanner() {
    mybannerAd = AdmobIslemleri.buildBannerAd();
    mybannerAd.load();
  }

  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['blog', 'news app'],
    childDirected: false,
    testDevices: <String>[
      "ecd76ed9-28b5-43c8-bf1b-8a1a09a8ca47",
      "578FB3D680F288A70781109F24275F24"
    ], // Android emulators are considered test devices
  );
  static BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.fullBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
          print("Banner yüklendi");
        }
      },
    );
  }

  static InterstitialAd buildInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
  }
}
