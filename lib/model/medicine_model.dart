class Medicine {
  final List<Items> items;
  Medicine({required this.items});
}

class Items {
  final String entpName, itemName, itemImage;
  final String? efcyQesitm,
      useMethodQesitm,
      atpnWarnQesitm,
      atpnQesitm,
      intrcQesitm,
      seQesitm,
      depositMethodQesitm;

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
}
