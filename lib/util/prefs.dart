import 'dart:convert';

import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/models/client.dart';
import 'package:money_library_2021/models/stokvel.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future saveAnchor(Anchor anchor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map mJson = anchor.toJson();
    var jx = json.encode(mJson);
    prefs.setString('anchor', jx);
    print("🌽 🌽 🌽 Prefs. ANCHOR  SAVED: 💦  ...... ${anchor.name} 💦 ");
    return null;
  }

  static Future saveClient(Client client) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map mJson = client.toJson();
    var jx = json.encode(mJson);
    prefs.setString('client', jx);
    print(
        "🌽 🌽 🌽 Prefs. CLIENT  SAVED: 💦  ...... ${client.personalKYCFields!.getFullName()} 💦 ");
    return null;
  }

  static Future saveClientCache(ClientCache clientCache) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map mJson = clientCache.toJson();
    var jx = json.encode(mJson);
    prefs.setString('clientCache', jx);
    print("🌽 🌽 🌽 Prefs. CLIENT_CACHE  SAVED: 💦 💦 ");
    return null;
  }

  static Future saveAnchorUser(AnchorUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map mJson = user.toJson();
    var jx = json.encode(mJson);
    prefs.setString('anchorUser', jx);
    print(
        "🌽 🌽 🌽 Prefs. ANCHOR USER  SAVED: 💦  ...... ${user.firstName} 💦 ");
    return null;
  }

  static Future saveAgent(Agent agent) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map mJson = agent.toJson();
    var jx = json.encode(mJson);
    prefs.setString('agent', jx);
    print(
        "🌽 🌽 🌽 Prefs. AGENT SAVED: 💦  ...... ${agent.personalKYCFields!.getFullName()} 💦 ");
    return null;
  }

  static void setThemeIndex(int index) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('index', index);
    print('🔵 🔵 🔵 Prefs: theme index set to: $index 🍎 🍎 ');
  }

  static Future<int> getThemeIndex() async {
    final preferences = await SharedPreferences.getInstance();
    var b = preferences.getInt('index');
    if (b == null) {
      return 0;
    } else {
      print('🔵 🔵 🔵  theme index retrieved: $b 🍏 🍏 ');
      return b;
    }
  }

  static void saveMOMOKey(String apiKey) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('momoKey', apiKey);
    print('🔵 🔵 🔵 Prefs: saveMOMOKey ok: $apiKey 🍎 🍎 ');
  }

  static Future<String?> getMOMOKey() async {
    final preferences = await SharedPreferences.getInstance();
    var b = preferences.getString('momoKey');
    if (b == null) {
      return null;
    } else {
      print('🔵 🔵 🔵  MOMO apiKey retrieved: $b 🍏 🍏 ');
      return b;
    }
  }

  static void saveMOMORef(String referenceId) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('referenceId', referenceId);
    print('🔵 🔵 🔵 Prefs: saveMOMORef ok: $referenceId 🍎 🍎 ');
  }

  static Future<String?> getMOMORef() async {
    final preferences = await SharedPreferences.getInstance();
    var b = preferences.getString('referenceId');
    if (b == null) {
      return null;
    } else {
      print('🔵 🔵 🔵  MOMO referenceId retrieved: $b 🍏 🍏 ');
      return b;
    }
  }

  static Future<Client?> getClient() async {
    p('🦋 🦋 .................  🌽 🥨 🥨  🌽  getting cached CLIENT .... 🥨 🥨 ');
    var prefs = await SharedPreferences.getInstance();
    var string = prefs.getString('client');
    if (string == null) {
      return null;
    }
    var jx = json.decode(string);
    var name = new Client.fromJson(jx);
    print(
        "🌽 🌽 🌽 Prefs.getClient 🧩🧩🧩🧩 ......CLIENT:  🧩 ${name.personalKYCFields!.getFullName()} retrieved 🧩");
    return name;
  }

  static Future<ClientCache?> getClientCache() async {
    p('🦋 🦋 .................  🌽 🥨 🥨  🌽  getting cached CLIENT_CACHE .... 🥨 🥨 ');
    var prefs = await SharedPreferences.getInstance();
    var string = prefs.getString('clientCache');
    if (string == null) {
      return null;
    }
    var jx = json.decode(string);
    var name = new ClientCache.fromJson(jx);
    print(
        "🌽 🌽 🌽 Prefs.getClientCache 🧩🧩🧩🧩 ...... CLIENT_CACHE retrieved 🧩");
    return name;
  }

  static Future<Anchor?> getAnchor() async {
    p('🦋 🦋 .................  🌽 🥨 🥨  🌽  getting cached ANCHOR .... 🥨 🥨 ');
    var prefs = await SharedPreferences.getInstance();
    var string = prefs.getString('anchor');
    if (string == null) {
      return null;
    }
    var jx = json.decode(string);
    var name = new Anchor.fromJson(jx);
    print(
        "🌽 🌽 🌽 Prefs.getAnchor 🧩🧩🧩🧩 ......ANCHOR:  🧩 ${name.name} retrieved 🧩");
    return name;
  }

  static Future<Agent?> getAgent() async {
    p('🦋 🦋 🦋 .................  🌽 🥨 🥨  🌽  getting cached agent .... check next statement ... falling down 🥨 🥨 ');
    var prefs = await SharedPreferences.getInstance();
    p('.................  🌽  🌽  😡 😡 😡  SharedPreferences instance OK ....');
    var string = prefs.getString('agent');
    if (string == null) {
      p('getting cached agent  😡  FAILED  😡  ....');
      return null;
    }
    var jx = json.decode(string);
    var name = new Agent.fromJson(jx);
    print(
        "🌽 🌽 🌽 🧡  Prefs.getAgent 🧩🧩🧩🧩 ......AGENT:  🧩 ${name.personalKYCFields!.getFullName()} retrieved 🧩");
    return name;
  }

  static Future<AnchorUser?> getAnchorUser() async {
    var prefs = await SharedPreferences.getInstance();
    var string = prefs.getString('anchorUser');
    if (string == null) {
      return null;
    }
    var jx = json.decode(string);
    var name = new AnchorUser.fromJson(jx);
    print(
        "🌽 🌽 🌽 Prefs.getAnchorUser 🧩 ......  ${name.firstName} retrieved");
    return name;
  }

  static Future saveMember(Member member) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map jsonx = member.toJson();
    var jx = json.encode(jsonx);
    prefs.setString('member', jx);
    print("🌽 🌽 🌽 Prefs.saveMember  SAVED: 🌽 ${member.toJson()}");
    return null;
  }

  static Future<Member?> getMember() async {
    var prefs = await SharedPreferences.getInstance();
    var string = prefs.getString('member');
    if (string == null) {
      return null;
    }
    var jx = json.decode(string);
    var member = new Member.fromJson(jx);
    return member;
  }
}
