class SymbolInfo {
  String symbol;
  String openPrice;
  String lowPrice;
  String highPrice;
  String closePrice;
  String volume;
  String chgRate;

  SymbolInfo({required this.symbol,
    required this.openPrice,
    required this.lowPrice,
    required this.highPrice,
    required this.closePrice,
    required this.volume,
    required this.chgRate});

  factory SymbolInfo.fromJson(Map<String, dynamic> json) {
    if(json.containsKey('symbol') == false) {
      return SymbolInfo(
        symbol: "none",
        openPrice: "",
        lowPrice: "",
        highPrice: "",
        closePrice: "",
        volume: "",
        chgRate: "",
      );
    }

    final symbol = json['symbol'] as String;
    final openPrice = json['openPrice'] as String;
    final lowPrice = json['lowPrice'] as String;
    final highPrice = json['highPrice'] as String;
    final closePrice = json['closePrice'] as String;
    final volume = json['volume'] as String;
    final chgRate = json['chgRate'] as String;

    return SymbolInfo(
      symbol: symbol,
      openPrice: openPrice,
      lowPrice: lowPrice,
      highPrice: highPrice,
      closePrice: closePrice,
      volume: volume,
      chgRate: chgRate,
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'symbol': symbol,
        'openPrice': openPrice,
        'lowPrice': lowPrice,
        'highPrice': highPrice,
        'closePrice': closePrice,
        'volume': volume,
        'chgRate': chgRate,
    };
}
