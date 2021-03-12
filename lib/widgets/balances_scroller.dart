import 'package:flutter/material.dart';
import 'package:money_library_2021/models/stellar_account_bag.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/image_handler/currency_icons.dart';
import 'package:money_library_2021/util/util.dart';

class BalancesScroller extends StatelessWidget {
  final Axis direction;
  final StellarAccountBag bag;

  const BalancesScroller(
      {Key key, @required this.direction, @required this.bag})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (bag == null) {
      return Container(
        child: Text(
          'No balances found',
          style: Styles.blueBoldMedium,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: bag == null ? 0 : bag.balances.length,
          scrollDirection: direction,
          itemBuilder: (context, index) {
            var currency;
            if (bag.balances.elementAt(index).assetCode == null) {
              currency = 'XLM';
            } else {
              currency = bag.balances.elementAt(index).assetCode;
            }
            var imagePath = CurrencyIcons.getCurrencyImagePath(currency);
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4),
              child: Row(
                children: <Widget>[
                  Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                          boxShadow: customShadow,
                          color: baseColor,
                          shape: BoxShape.circle),
                      child: Image.asset(imagePath)),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    getFormattedAmount(
                        bag.balances.elementAt(index).balance, context),
                    style: Styles.tealBoldSmall,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
