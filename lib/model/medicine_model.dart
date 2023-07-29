class Medicine {
  final List<Items> items;
  Medicine({required this.items});
}

class Items {
  final String entpName, itemName;
  final String? efcyQesitm,
      useMethodQesitm,
      atpnWarnQesitm,
      atpnQesitm,
      intrcQesitm,
      seQesitm,
      depositMethodQesitm,
      itemImage;
  Items(
      {required this.entpName,
      required this.itemName,
      required this.itemImage,
      required this.efcyQesitm,
      required this.useMethodQesitm,
      required this.atpnWarnQesitm,
      required this.atpnQesitm,
      required this.intrcQesitm,
      required this.seQesitm,
      required this.depositMethodQesitm});

  Items.fromJson(Map<String, dynamic> json)
      : entpName = json['entpName'],
        itemName = json['itemName'],
        itemImage = json['itemImage'],
        efcyQesitm = json['efcyQesitm'],
        useMethodQesitm = json['useMethodQesitm'],
        atpnWarnQesitm = json['atpnWarnQesitm'],
        atpnQesitm = json['atpnQesitm'],
        intrcQesitm = json['intrcQesitm'],
        seQesitm = json['seQesitm'],
        depositMethodQesitm = json['depositMethodQesitm'];
}
