import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

//Google Sign in Service Class
class GoogleSignInService{
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static bool isInitialize =false;
  static Future<void> initSignIn() async {
    if (!isInitialize){
      await _googleSignIn.initialize(
        serverClientId: '851597508701-65kfojvkbnqj9em6qca61kgtkkpd7aas.apps.googleusercontent.com'
      );
    }
    isInitialize =true;
  }
    //Sign in with google
static Future<UserCredential?> signInWithGoogle() async{
    try {
      initSignIn();
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final idToken = googleUser.authentication.idToken;
      final authorizationClient = googleUser.authorizationClient;

      GoogleSignInClientAuthorization? authorization = await
      authorizationClient.authorizationForScopes(['email', 'profile']);

      final accessToken = authorization?.accessToken;

      if (accessToken == null) {
        final authorization2 = await
        authorizationClient.authorizationForScopes(['email', 'profile']);
        if (authorization2?.accessToken == null) {
          throw FirebaseAuthException(code: "error", message: "error");
        }
        authorization = authorization2;
      }
      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      final UserCredential  userCredential =await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = userCredential.user;
      if(user != null) {
        final userDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
      }


    }

}
}
