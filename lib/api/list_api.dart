import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_library_2021/models/stokvel.dart';

import 'db.dart';

class ListAPI {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<Stokvel>> getStokvelsAdministered(String memberId) async {
    var querySnapshot = await _firestore
        .collection('stokvels')
        .where('adminMember.memberId', isEqualTo: memberId)
        .get();
    var mList = List<Stokvel>();
    querySnapshot.docs.forEach((doc) {
      mList.add(Stokvel.fromJson(doc.data()));
    });
    return mList;
  }

  static Future<List<Stokvel>> getStokvels() async {
    var querySnapshot = await _firestore.collection('stokvels').get();
    var mList = List<Stokvel>();
    querySnapshot.docs.forEach((doc) {
      mList.add(Stokvel.fromJson(doc.data()));
    });
    mList.sort((a, b) => a.name.compareTo(b.name));
    return mList;
  }

  static Future<Stokvel> getStokvelById(String stokvelId) async {
    var querySnapshot = await _firestore
        .collection('stokvels')
        .where('stokvelId', isEqualTo: stokvelId)
        .get();
    var mList = List<Stokvel>();
    var stokvel;
    ;
    querySnapshot.docs.forEach((doc) {
      mList.add(Stokvel.fromJson(doc.data()));
    });
    mList.forEach((s) {
      if (s.stokvelId == stokvelId) {
        stokvel = s;
      }
    });
    if (stokvel != null) {
      await StokvelLocalDB.addStokvel(stokvel: stokvel);
    }
    return stokvel;
  }

  static Future<List<Invitation>> getInvitationsByEmail(String email) async {
    var querySnapshot = await _firestore
        .collection('invitations')
        .where('email', isEqualTo: email)
        .get();
    var mList = List<Invitation>();
    querySnapshot.docs.forEach((doc) {
      mList.add(Invitation.fromJson(doc.data()));
    });
    return mList;
  }

  static Future<List<Member>> getStokvelMembers(String stokvelId) async {
    var querySnapshot = await _firestore
        .collection('members')
        .where('stokvelIds', arrayContains: stokvelId)
        .get();
    var mList = List<Member>();
    querySnapshot.docs.forEach((doc) {
      mList.add(Member.fromJson(doc.data()));
    });

    return mList;
  }

  static Future<String> getStokvelSeed(String stokvelId) async {
    var cred = await getStokvelCredential(stokvelId);
    return null; //makerBloc.getDecryptedSeed(cred);
  }

  static Future<StokkieCredential> getStokvelCredential(
      String stokvelId) async {
    var querySnapshot = await _firestore
        .collection('creds')
        .where('stokvelId', isEqualTo: stokvelId)
        .limit(1)
        .get();
    var mList = List<StokkieCredential>();
    querySnapshot.docs.forEach((doc) {
      mList.add(StokkieCredential.fromJson(doc.data()));
    });
    print(
        '🔵 🔵 ListAPI: getStokvelCredential found on Firestore 🔵 ${mList.length} 🔵 creds');
    if (mList.isNotEmpty) {
      return mList.elementAt(0);
    }
    return null;
  }

  static Future<StokkieCredential> getMemberCredential(String memberId) async {
    var querySnapshot = await _firestore
        .collection('creds')
        .where('memberId', isEqualTo: memberId)
        .limit(1)
        .get();
    var mList = List<StokkieCredential>();
    querySnapshot.docs.forEach((doc) {
      mList.add(StokkieCredential.fromJson(doc.data()));
    });
    print(
        '🔵 🔵 ListAPI: getMemberCredential found on Firestore 🔵 ${mList.length} 🔵 creds');
    if (mList.isNotEmpty) {
      return mList.elementAt(0);
    }
    return null;
  }

  static Future<StokvelGoal> getStokvelGoalById(String stokvelGoalId) async {
    var querySnapshot = await _firestore
        .collection('stokvelGoals')
        .where('stokvelGoalId', isEqualTo: stokvelGoalId)
        .limit(1)
        .get();
    var mList = List<StokvelGoal>();
    querySnapshot.docs.forEach((doc) {
      mList.add(StokvelGoal.fromJson(doc.data()));
    });

    if (mList.isEmpty) {
      return null;
    }
    return mList.first;
  }

  static Future<List<StokvelGoal>> getStokvelGoals(String stokvelId) async {
    var querySnapshot = await _firestore
        .collection('stokvelGoals')
        .where('stokvel.stokvelId', isEqualTo: stokvelId)
        .limit(PAYMENT_LIST_LIMIT)
        .get();
    var mList = List<StokvelGoal>();
    querySnapshot.docs.forEach((doc) {
      mList.add(StokvelGoal.fromJson(doc.data()));
    });

    return mList;
  }

  static Future<List<StokvelPayment>> getStokvelPayments(
      String stokvelId) async {
    var querySnapshot = await _firestore
        .collection('stokvelPayments')
        .where('stokvel.stokvelId', isEqualTo: stokvelId)
        .limit(PAYMENT_LIST_LIMIT)
        .get();
    var mList = List<StokvelPayment>();
    querySnapshot.docs.forEach((doc) {
      mList.add(StokvelPayment.fromJson(doc.data()));
    });

    return mList;
  }

  static Future<List<MemberPayment>> getMemberPaymentsMade(
      String memberId) async {
    var querySnapshot = await _firestore
        .collection('memberPayments')
        .orderBy('date', descending: true)
        .where('fromMember.memberId', isEqualTo: memberId)
        .limit(PAYMENT_LIST_LIMIT)
        .get();
    var mList = List<MemberPayment>();
    querySnapshot.docs.forEach((doc) {
      mList.add(MemberPayment.fromJson(doc.data()));
    });
    return mList;
  }

  static Future<List<MemberPayment>> getMemberPaymentsReceived(
      String memberId) async {
    var querySnapshot = await _firestore
        .collection('memberPayments')
        .orderBy('date', descending: true)
        .where('toMember.memberId', isEqualTo: memberId)
        .limit(PAYMENT_LIST_LIMIT)
        .get();
    var mList = List<MemberPayment>();
    querySnapshot.docs.forEach((doc) {
      mList.add(MemberPayment.fromJson(doc.data()));
    });
    return mList;
  }

  static Future<Member> getMember(String memberId) async {
    var querySnapshot = await _firestore
        .collection('members')
        .where('memberId', isEqualTo: memberId)
        .limit(1)
        .get();

    var mList = List<Member>();
    querySnapshot.docs.forEach((doc) {
      mList.add(Member.fromJson(doc.data()));
    });

    if (mList.isNotEmpty) {
      return mList.first;
    }
    return null;
  }
}

const int PAYMENT_LIST_LIMIT = 1000;