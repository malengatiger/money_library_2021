import 'package:flutter/material.dart';
import 'package:money_library_2021/models/stellar_account_bag.dart';
import 'package:money_library_2021/util/image_handler/currency_icons.dart';
import 'package:money_library_2021/util/util.dart';

class CurrencyDropDown extends StatelessWidget {
  final StellarAccountBag bag;
  final bool showXLM;
  final CurrencyDropDownListener listener;

  const CurrencyDropDown(
      {Key key,
      @required this.bag,
      @required this.listener,
      this.showXLM = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(bag != null);
    var items = <DropdownMenuItem<Balance>>[];
    bag.balances.forEach((balance) {
      p('🌼 .... Balance to be put into dropDown menu: ${balance.assetCode} ${balance.balance}');
      var imagePath = CurrencyIcons.getCurrencyImagePath(balance.assetCode);
      p('🌼 .... imagePath: $imagePath');
      if (balance.assetCode != 'XLM') {
        items.add(new DropdownMenuItem(
            value: balance,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Image.asset(imagePath, height: 40, width: 40),
                  SizedBox(width: 8),
                  Text(balance.assetCode == null ? "XLM" : balance.assetCode),
                ],
              ),
            )));
      }
    });

    return DropdownButton<Balance>(
        hint: Text('Select Currency'), items: items, onChanged: _onChanged);
  }

  void _onChanged(Balance value) {
    listener.onChanged(value);
  }
}

abstract class CurrencyDropDownListener {
  onChanged(Balance value);
}
