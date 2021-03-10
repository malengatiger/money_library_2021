class CurrencyIcons {
  static const String prefix = "assets/currencies/";
  static String getCurrencyImagePath(String assetCode) {
    switch (assetCode) {
      case 'USD':
        return "${prefix}currency_dollar_green.png";
        break;
      case 'ZAR':
        return "${prefix}zar.png";
        break;
      case 'GBP':
        return "${prefix}currency_blue_pound.png";
        break;
      case 'EUR':
        return "${prefix}currency_euro_red.png";
        break;
      case 'XLM':
        return "${prefix}stellar-xlm.png";
        break;
    }
    return "${prefix}currency_euro_red.png";
  }
}
