import 'balance.dart';

class Balances {
  List<Balance> balances;

  Balances({
    this.balances,
  }); //

  Balances.fromJson(Map data) {
    balances = [];
    if (data['balances'] != null) {
      List mBalances = data['balances'];
      mBalances.forEach((element) {
        balances.add(Balance.fromJson(element));
      });
    }
  }

  Map<String, dynamic> toJson() {
    List<Map> mMap = List();
    balances.forEach((element) {
      mMap.add(element.toJson());
    });
    Map<String, dynamic> map = Map();
    map['balances'] = mMap;
    return map;
  }
}
