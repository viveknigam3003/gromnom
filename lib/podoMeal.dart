class Combos {
  List<Combo> combo;

  Combos({this.combo});

  Combos.fromJson(Map<String, dynamic> json) {
    if (json['combo'] != null) {
      combo = new List<Combo>();
      json['combo'].forEach((v) {
        combo.add(new Combo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.combo != null) {
      data['combo'] = this.combo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Combo {
  List<Items> items;

  Combo({this.items});

  Combo.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> findJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson());
    }
    return data;
  } 

}

class Items {
  String item;
  String price;
  bool boolValue = false;
  //double intPrice;

  Items({this.item, this.price});

  Items.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item'] = this.item;
    data['price'] = this.price;
    return data;
  }
}

