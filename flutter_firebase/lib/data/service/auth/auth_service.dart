import 'package:flutter_firebase/data/service/auth/shared_pref_service.dart';
import 'package:flutter_firebase/data/utils/exception_codes.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../model/AppResponse.dart';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class AuthService {
  final _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  Future<AppResponse> sendEmailLink({
    required String email,
  }) async {
    print('sendEmailLink[$email]');
    try {
         final actionCodeSettings = firebase_auth.ActionCodeSettings(
                // URL you want to redirect back to. The domain (www.example.com) for this
                // URL must be whitelisted in the Firebase Console.
                url:
                    'https://flutterfirebasesample.page.link/iGuj-001',
                // This must be true
                handleCodeInApp: true,
                iOSBundleId: 'com.example.flutter_firebase',
                androidPackageName: 'com.example.flutter_firebase',
                // installIfNotAvailable
                androidInstallApp: true,
                // minimumVersion
                androidMinimumVersion: '12');

      print('actionCodeSettings[${actionCodeSettings.asMap()}]');
      await _firebaseAuth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
      
      SharedPrefService.instance.setString('passwordLessEmail', email);
      return AppResponse(
        1, StatusCode.SUCCESS 
      );
    } catch (e, s) {
       return AppResponse(
        1, StatusCode.ERROR
      );
    }
  }

  Future<AppResponse> retrieveDynamicLinkAndSignIn({
    required bool fromColdState,
  }) async {
    try {
      String email =
          SharedPrefService.instance.getString('passwordLessEmail') ?? '';
      if (email.isEmpty) {
        return AppResponse(
        1, StatusCode.ERROR
      );
      }

      PendingDynamicLinkData? dynamicLinkData;

      Uri? deepLink;
      if (fromColdState) {
        dynamicLinkData = await FirebaseDynamicLinks.instance.getInitialLink();
        if (dynamicLinkData != null) {
          deepLink = dynamicLinkData.link;
        }
      } else {
        dynamicLinkData =
            await FirebaseDynamicLinks.instance.getDynamicLink(deepLink);
        deepLink = dynamicLinkData!.link;
      }

      if (deepLink != null) {
        bool validLink =
            _firebaseAuth.isSignInWithEmailLink(deepLink.toString());

        SharedPrefService.instance.setString('passwordLessEmail', '');
        if (validLink) {
          final firebase_auth.UserCredential userCredential =
              await _firebaseAuth.signInWithEmailLink(
            email: email,
            emailLink: deepLink.toString(),
          );
          if (userCredential.user != null) {
            return AppResponse(
        1, StatusCode.ERROR
      );
          } else {
            print('userCredential.user is [${userCredential.user}]');
          }
        } else {
          print('Link is not valid');
          return AppResponse(
        1, StatusCode.ERROR
      );
        }
      }
    } catch (e, s) {
      return AppResponse(
        1, StatusCode.ERROR
      );
    }
    return AppResponse(
        1, StatusCode.ERROR
      );
  }
}
