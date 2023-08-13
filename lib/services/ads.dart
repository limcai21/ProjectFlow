// import 'dart:io';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AdState {
//   Future<InitializationStatus> initialization;
//   AdState(this.initialization);

//   // USING INTERSTITIAL
//   String getBannerAdUnitID = Platform.isAndroid
//       ? 'ca-app-pub-3940256099942544/1033173712'
//       : 'ca-app-pub-3940256099942544/4411468910';

//   AdListener listener = AdListener(
//     onAdLoaded: (Ad ad) {
//       print('Ad loaded.');
//     },
//     onAdFailedToLoad: (Ad ad, LoadAdError error) {
//       ad.dispose();
//       print('Ad failed to load: $error');
//     },
//     onAdOpened: (Ad ad) {
//       print('Ad opened.');
//     },
//     onAdClosed: (Ad ad) {
//       ad.dispose();
//       print('Ad closed.');
//     },
//     onApplicationExit: (Ad ad) {
//       print('Left application.');
//     },
//   );
// }
