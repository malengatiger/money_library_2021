import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:money_library_2021/api/net.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/models/client.dart';
import 'package:money_library_2021/util/prefs.dart';
import 'package:money_library_2021/util/util.dart';

class Auth {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static Future<bool> checkAuthenticated() async {
    await Firebase.initializeApp();
    p('π¦ π¦ π¦ Firebase has been initialized. so make it rain π¦ π¦ π¦ π¦ π¦ π¦ π¦ π¦ π¦');
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
    var token = await _auth.currentUser!.getIdToken();
    p('π‘ π‘ π‘ Auth: getAuthToken: Token: π‘ π‘ π‘ $token π‘ π‘ π‘');
    return token;
  }

  static Future<UserCredential> signInAdmin() async {
    p('π‘ π‘ π‘ Auth: Getting email and password from environment : π‘ π‘ π‘ ');
    await DotEnv.load(fileName: '.env');
    var email = DotEnv.env['email']!;
    var pswd = DotEnv.env['password']!;
    var cred =
        await _auth.signInWithEmailAndPassword(email: email, password: pswd);
    if (cred.user == null) {
      p('Grenade blew up! πΏπΏπΏ cred not found πΏπΏπΏ');
      throw Exception('Firebase admin user unavailable: $email');
    }
    p('π¦π¦π¦π¦π¦π¦ Auth: π¦π¦π¦ signInAdmin is all OK! User logged in: π¦π¦π¦ ${cred.user!.email} π¦π¦π¦');
    return cred;
  }

  static Future<AnchorUser> signInAnchor(
      {required String email, required String password}) async {
    p('$bb Signing in as Anchor User ... $email');
    var result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (result.user == null) {
      throw Exception("Sign In Failed");
    }

    var anchorUser = await NetUtil.getAnchorUser(result.user!.uid);
    var anchor = await NetUtil.getAnchor(anchorUser.anchorId);
    await Prefs.saveAnchor(anchor);
    await Prefs.saveAnchorUser(anchorUser);

    p('$bb getting Anchor User from firestore auth :...uid: ${result.user!.uid}');

    return anchorUser;
  }

  static Future<Agent> signInAgent({required String email, required String password}) async {
    p('$bb  Agent Sign in started ......');
    var result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (result.user == null) {
      throw Exception("Sign In Failed");
    }
    Agent agent = await NetUtil.getAgent(result.user!.uid);
    await NetUtil.getAnchor(agent.anchorId);

    return agent;
  }

  static Future<Client> signInClient({required String email, required String password}) async {
    p('$bb signInClientSign in started ......');
    var result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (result.user == null) {
      throw Exception("Sign In Failed");
    }
    Client client = await NetUtil.getClient(result.user!.uid);
    await NetUtil.getAnchor(client.anchorId);

    return client;
  }

  static Future registerClient(Client client) async {}

  static const bb = 'πΌ πΌ πΌ πΌ πΌ πΌ Auth: ';
}
