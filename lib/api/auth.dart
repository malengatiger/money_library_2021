import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:money_library_2021/api/net.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/models/client.dart';
import 'package:money_library_2021/util/util.dart';

class Auth {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static Future<bool> checkAuthenticated() async {
    await Firebase.initializeApp();
    p('💦 💦 💦 Firebase has been initialized. so make it rain 💦 💦 💦 💦 💦 💦 💦 💦 💦');
    var user = _auth.currentUser;
    if (user == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<String> getAuthToken() async {
    if (_auth.currentUser == null) {
      throw Exception('User not authenticated');
    }
    var token = await _auth.currentUser.getIdToken();
    p('😡 😡 😡 Auth: getAuthToken: Token: 😡 😡 😡 $token 😡 😡 😡');
    return token;
  }

  static Future<UserCredential> signInAdmin() async {
    p('😡 😡 😡 Auth: Getting email and password from environment : 😡 😡 😡 ');
    await DotEnv.load(fileName: '.env');
    var email = DotEnv.env['email'];
    var pswd = DotEnv.env['password'];
    var cred =
        await _auth.signInWithEmailAndPassword(email: email, password: pswd);
    if (cred.user == null) {
      p('Grenade blew up! 👿👿👿 cred not found 👿👿👿');
      throw Exception('Firebase admin user unavailable: $email');
    }
    p('🦋🦋🦋🦋🦋🦋 Auth: 🦋🦋🦋 signInAdmin is all OK! User logged in: 🦋🦋🦋 ${cred.user.email} 🦋🦋🦋');
    return cred;
  }

  static Future<AnchorUser> signInAnchor(
      {String email, String password}) async {
    p('$bb Signing in as Anchor User ... $email');
    var result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (result.user == null) {
      throw Exception("Sign In Failed");
    }
    await NetUtil.getAnchor();
    var user = await NetUtil.getAnchorUser(result.user.uid);
    return user;
  }

  static Future<Agent> signInAgent({String email, String password}) async {
    p('$bb  Agent Sign in started ......');
    var result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (result.user == null) {
      throw Exception("Sign In Failed");
    }
    Agent agent = await NetUtil.getAgent(result.user.uid);
    await NetUtil.getAnchor();

    return agent;
  }

  static Future<Client> signInClient({String email, String password}) async {
    p('$bb signInClientSign in started ......');
    var result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (result.user == null) {
      throw Exception("Sign In Failed");
    }
    Client client = await NetUtil.getClient(result.user.uid);
    await NetUtil.getAnchor();

    return client;
  }

  static Future registerClient(Client client) async {}

  static const bb = '🌼 🌼 🌼 🌼 🌼 🌼 Auth: ';
}
