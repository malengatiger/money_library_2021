class StokvelDataAPI {
  // static var _fs = FirebaseFirestore.instance;
  //
  // static Future sendInvitation(Invitation invitation) async {
  //   await _fs.collection('invitations').add(invitation.toJson());
  //   print(
  //       'Invitation for ${invitation.stokvel.name} has been added to Firestore - will launch cloud function ...');
  // }
  //
  // static Future uploadMemberPhoto({File file, Member member}) async {
  //   final FirebaseStorage storage = FirebaseStorage.instance;
  //   final Reference reference = storage.ref().child('payservice-photos');
  //
  //   //final  Storager FirebaseStorage().ref().child('photos');
  //
  //   final UploadTask uploadTask = reference.putFile(file);
  //   //
  //   // final StreamSubscription<TaskEvent> streamSubscription = uploadTask.snapshot.ref.
  //   //   ..events.listen((event) {
  //   //     print(
  //   //         'Bytes transferred: ${event.snapshot.bytesTransferred} of ${event.snapshot.totalByteCount}');
  //   //     print('StorageUploadTask EVENT: ${event.type}');
  //   //   });
  //   //
  //   // var snapshot = await uploadTask.onComplete;
  //   // streamSubscription.cancel();
  //   // if (uploadTask.isSuccessful) {
  //   //   member.url = await snapshot.ref.getDownloadURL();
  //   //   updateMember(member);
  //   // } else {
  //   //   throw Exception('Photo upload failed');
  //   // }
  // }
  //
  // static Future updateMember(Member member) async {
  //   prettyPrint(member.toJson(),
  //       '🥬 🥬 🥬 Member about to be deleted and added again ...');
  //
  //   DocumentReference documentReference;
  //   var querySnapshot = await _fs
  //       .collection('members')
  //       .where('memberId', isEqualTo: member.memberId)
  //       .limit(1)
  //       .get();
  //
  //   if (querySnapshot.docs.length > 0) {
  //     documentReference = querySnapshot.docs.first.reference;
  //   } else {
  //     throw Exception('Member update failed, member not found');
  //   }
  //   if (documentReference != null) {
  //     await _fs.runTransaction((Transaction tx) async {
  //       var snap = await tx.get(documentReference);
  //       if (snap.exists) {
  //         tx.update(documentReference, member.toJson());
  //         print('🧡 🧡 DataAPI: ... member updated: ... 🍎 ');
  //       }
  //     });
  //     return null;
  //   } else {
  //     throw Exception('Mmeber to be updated NOT found');
  //   }
  // }
  //
  // static Future<StokvelPayment> sendStokvelPaymentToStellar(
  //     {@required StokvelPayment payment, @required String seed}) async {
  //   var res = await Stellar.sendPayment(
  //       seed: seed,
  //       destinationAccount: payment.stokvel.accountId,
  //       amount: payment.amount,
  //       memo: 'STOKVEL');
  //   print(
  //       '👌🏾👌🏾👌🏾 Stokvel payment successful on Stellar. 🧩 Will cache on Firestore');
  //   payment.stellarHash = res.hash;
  //   await makerBloc.writeStokvelPayment(payment);
  //   return payment;
  // }
  //
  // static Future<MemberPayment> sendMemberPaymentToStellar(
  //     {@required MemberPayment payment, @required String seed}) async {
  //   var res = await Stellar.sendPayment(
  //       seed: seed,
  //       destinationAccount: payment.toMember.accountId,
  //       amount: payment.amount,
  //       memo: 'MEMBER');
  //   print('Member payment successful on Stellar. Will cache on Firestore');
  //   payment.stellarHash = res.hash;
  //   await makerBloc.writeMemberPayment(payment);
  //   return payment;
  // }
  //
  // static Future addStokvelToMember(
  //     {@required Stokvel stokvel, @required String memberId}) async {
  //   var querySnapshot = await _fs
  //       .collection('members')
  //       .where('memberId', isEqualTo: memberId)
  //       .get();
  //   if (querySnapshot.docs.isNotEmpty) {
  //     var member = Member.fromJson(querySnapshot.docs.first.data());
  //     if (member.stokvelIds == null) {
  //       member.stokvelIds = List();
  //     }
  //     member.stokvelIds.add(stokvel.stokvelId);
  //     querySnapshot.docs.first.reference.set(member.toJson());
  //     print(
  //         '🛎 🛎 Member updated on Firestore with added Stokvel: 🥬 ${stokvel.name} '
  //         'member stokvels: 🥬 ${member.stokvelIds.length}');
  //     await Prefs.saveMember(member);
  //     return null;
  //   } else {
  //     throw Exception('Member not found');
  //   }
  // }
  //
  // static Future addStokvelAdministrator(
  //     {@required Member member, @required String stokvelId}) async {
  //   var querySnapshot = await _fs
  //       .collection('stokvels')
  //       .where('stokvelId', isEqualTo: stokvelId)
  //       .get();
  //   if (querySnapshot.docs.isNotEmpty) {
  //     var stokvel = Stokvel.fromJson(querySnapshot.docs.first.data());
  //     stokvel.adminMember = member;
  //     stokvel.date = DateTime.now().toUtc().toIso8601String();
  //     querySnapshot.docs.first.reference.set(stokvel.toJson());
  //   } else {
  //     throw Exception('Member not found');
  //   }
  // }
  //
  // static Future<StokvelGoal> addStokvelGoalPayment(
  //     {String stokvelGoalId, StokvelPayment payment}) async {
  //   assert(stokvelGoalId != null);
  //   assert(payment != null);
  //   var goal = await ListAPI.getStokvelGoalById(stokvelGoalId);
  //   if (goal == null) {
  //     throw Exception('Goal not found');
  //   }
  //   if (goal.payments == null) {
  //     goal.payments = [];
  //   }
  //   goal.payments.add(payment);
  //   await updateStokvelGoal(goal);
  //   print(
  //       '💊 DataAPI: addStokvelGoalPayment: StokvelGoal updated (added payment)');
  //   return goal;
  // }
  //
  // static Future<StokvelGoal> addStokvelGoalUrl(
  //     {String stokvelGoalId, String url}) async {
  //   assert(stokvelGoalId != null);
  //   assert(url != null);
  //   var goal = await ListAPI.getStokvelGoalById(stokvelGoalId);
  //   if (goal == null) {
  //     throw Exception('Goal not found');
  //   }
  //   if (goal.imageUrls == null) {
  //     goal.imageUrls = [];
  //   }
  //   goal.imageUrls.add(url);
  //   var mRes = await updateStokvelGoal(goal);
  //   print(
  //       '💊 DataAPI: StokvelGoal updated (added imageUrl), path: ${mRes.path}');
  //   return goal;
  // }
  //
  // static Future<StokvelGoal> addStokvelGoal(StokvelGoal goal) async {
  //   var uuid = Uuid();
  //   goal.stokvelGoalId = uuid.v4();
  //   goal.date = DateTime.now().toUtc().toIso8601String();
  //   var mRes = await _fs.collection('stokvelGoals').add(goal.toJson());
  //   print('💊 DataAPI: StokvelGoal added to Firestore, path: ${mRes.path}');
  //   await StokvelLocalDB.addStokvelGoal(goal: goal);
  //   return goal;
  // }
  //
  // static Future updateStokvelGoal(StokvelGoal goal) async {
  //   DocumentReference documentReference;
  //   var querySnapshot = await _fs
  //       .collection('stokvelGoals')
  //       .where('stokvelGoalId', isEqualTo: goal.stokvelGoalId)
  //       .limit(1)
  //       .get();
  //
  //   if (querySnapshot.docs.length > 0) {
  //     documentReference = querySnapshot.docs.first.reference;
  //   } else {
  //     throw Exception('StokvelGoal update failed, StokvelGoal not found');
  //   }
  //   if (documentReference != null) {
  //     await _fs.runTransaction((Transaction tx) async {
  //       var snap = await tx.get(documentReference);
  //       if (snap.exists) {
  //         await tx.update(documentReference, goal.toJson());
  //         print('🧡 🧡 DataAPI: ... StokvelGoal updated on Firestore: ... 🍎 ');
  //         await StokvelLocalDB.addStokvelGoal(goal: goal);
  //       }
  //     });
  //     return null;
  //   } else {
  //     throw Exception('StokvelGoal to be updated NOT found');
  //   }
  // }
  //
  // static Future addInvitation(Invitation invite) async {
  //   var uuid = Uuid();
  //   invite.invitationId = uuid.v1();
  //   invite.date = DateTime.now().toUtc().toIso8601String();
  //   var mRes = await _fs.collection('invitations').add(invite.toJson());
  //   print('💊 DataAPI: Invitation added to Firestore, path: ${mRes.path}');
  //   return invite;
  // }
}
