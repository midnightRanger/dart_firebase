 import 'package:firebase_auth/firebase_auth.dart';

class getAcs {
  
  static final ActionCodeSettings acs = ActionCodeSettings(
    // URL you want to redirect back to. The domain (www.example.com) for this
    // URL must be whitelisted in the Firebase Console.
    url: 'https://flutterfirebasesample.page.link/iGuj?email',
    // This must be true
    handleCodeInApp: true,
    iOSBundleId: 'com.example.flutter_firebase',
    androidPackageName: 'com.example.flutter_firebase',
    // installIfNotAvailable
    androidInstallApp: true,
    // minimumVersion
    androidMinimumVersion: '12');



}