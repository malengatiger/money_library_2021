import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/models/client.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/prefs.dart';
import 'package:money_library_2021/util/util.dart';

class Auth {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static var _firestore = FirebaseFirestore.instance;

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
    final tokenResult = await FirebaseAuth.instance.currentUser();
    final token = await tokenResult.getIdToken();

    p('😡 😡 😡 Auth: getAuthToken: Token: 😡 😡 😡 $token 😡 😡 😡');
    return token;
  }

  static Future<FirebaseUser> signInAdmin() async {
    p('😡 😡 😡 Auth: Getting email and password from environment : 😡 😡 😡 ');
    await DotEnv.load(fileName: '.env');
    var email = DotEnv.env['email'];
    var pswd = DotEnv.env['password'];
    var firebaseUser =
        await _auth.signInWithEmailAndPassword(email: email, password: pswd);
    if (firebaseUser == null) {
      p('Grenade blew up! 👿👿👿 firebaseUser not found 👿👿👿');
      throw Exception('Firebase admin user unavailable: $email');
    }
    p('🦋🦋🦋🦋🦋🦋 Auth: 🦋🦋🦋 signInAdmin is all OK! User logged in: 🦋🦋🦋 ${firebaseUser.email} 🦋🦋🦋');
    return firebaseUser;
  }

  static Future<AnchorUser> signInAnchor(
      {String email, String password}) async {
    p('🔷 🔷 🔷Signing in as Anchor User ... $email');
    var result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (result == null) {
      throw Exception("Sign In Failed");
    }
    //get anchorUser
    var qs = await _firestore
        .collection("anchorUsers")
        .limit(1)
        .where("userId", isEqualTo: result.uid)
        .get();

    AnchorUser user;
    qs.docs.forEach((element) {
      user = AnchorUser.fromJson(element.data());
    });
    p('🔷 🔷 🔷 AnchorUser found on Firestore: ${user.toJson()}');
    Prefs.saveAnchorUser(user);
    //get anchorUser
    qs = await _firestore
        .collection("anchors")
        .limit(1)
        .where("anchorId", isEqualTo: user.anchorId)
        .get();

    Anchor anchor;
    qs.docs.forEach((element) {
      anchor = Anchor.fromJson(element.data());
    });
    p('🔷 🔷 🔷 Anchor found on Firestore: ${anchor.toJson()}');
    Prefs.saveAnchor(anchor);
    return user;
  }

  static Future<Agent> signInAgent({String email, String password}) async {
    p('🦕 🦕 Agent Sign in started ......');
    var result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (result == null) {
      throw Exception("Sign In Failed");
    }
    //get agent
    var qs = await _firestore
        .collection("agents")
        .limit(1)
        .where("agentId", isEqualTo: result.uid)
        .get();

    p('🦕 🦕 Agent query executed: ${qs.docs.length} agent found ......');
    Agent agent;
    qs.docs.forEach((element) {
      agent = Agent.fromJson(element.data());
    });

    Prefs.saveAgent(agent);
    //get anchor
    qs = await _firestore
        .collection("anchors")
        .limit(1)
        .where("anchorId", isEqualTo: agent.anchorId)
        .get();
    p('🦕 🦕 Anchor query executed: ${qs.docs.length} anchor found? ......');
    Anchor anchor;
    qs.docs.forEach((element) {
      anchor = Anchor.fromJson(element.data());
    });

    Prefs.saveAnchor(anchor);

    p('🦕 🦕 😎 😎 😎 Sign in executed OK: anchor saved:  ......');
    prettyPrint(anchor.toJson(), "😎 ANCHOR cached for later: ${anchor.name} ");
    p('🦕 🦕 😎 😎 😎 Sign in executed OK: returning agent  ......');
    prettyPrint(agent.toJson(),
        "😎 .... returning AGENT: ${agent.personalKYCFields.getFullName()}");
    return agent;
  }

  static Future<Client> signInClient({String email, String password}) async {
    p('🦕 🦕 ........... Sign in started ......');
    var result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (result == null) {
      throw Exception("Sign In Failed");
    }
    //get client
    var qs = await _firestore
        .collection("clients")
        .limit(1)
        .where("clientId", isEqualTo: result.uid)
        .get();

    p('🦕 🦕 Client query executed: ${qs.docs.length} client found ......');
    Client client;
    qs.docs.forEach((element) {
      client = Client.fromJson(element.data());
    });

    Prefs.saveClient(client);
    //get anchor
    qs = await _firestore
        .collection("anchors")
        .limit(1)
        .where("anchorId", isEqualTo: client.anchorId)
        .get();
    p('🦕 🦕 Anchor query executed: ${qs.docs.length} anchor found ......');
    Anchor anchor;
    qs.docs.forEach((element) {
      anchor = Anchor.fromJson(element.data());
    });

    Prefs.saveAnchor(anchor);

    p('🦕 🦕 😎 😎 😎 Sign in executed OK: anchor saved:  ......');
    prettyPrint(anchor.toJson(), "😎 ANCHOR cached for later: ${anchor.name} ");
    p('🦕 🦕 😎 😎 😎 Sign in executed OK: returning client  ......');
    prettyPrint(client.toJson(),
        "😎 .... returning AGENT: ${client.personalKYCFields.getFullName()}");
    return client;
  }

  static Future registerClient(Client client) async {}
}
