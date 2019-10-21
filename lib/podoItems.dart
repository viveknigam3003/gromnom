class Combos2 {
  List<Combo2> combo;

  Combos2({this.combo});

  Combos2.fromJson(Map<String, dynamic> json) {
    if (json['combo'] != null) {
      combo = new List<Combo2>();
      json['combo'].forEach((v) {
        combo.add(new Combo2.fromJson(v));
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

class Combo2 {
  List<Items2> items;

  Combo2({this.items});

  Combo2.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<Items2>();
      json['items'].forEach((v) {
        items.add(new Items2.fromJson(v));
      });
    }
  }

  Combo2.fromJson2(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<Items2>();
      json['items'].forEach((v) {
        items.add(new Items2.fromJson(v));
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

class Items2 {
  String item;
  String price;
  bool boolValue = false;
  String user;
  //double intPrice;

  Items2({this.item, this.price,this.boolValue,this.user});

  Items2.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    price = json['price'];
    boolValue = json['boolValue'];
    user = json['user'];
  }

  Items2.fromJson2(Map<dynamic, dynamic> json) {
    item = json['item'];
    price = json['price'];
    boolValue = json['boolValue'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item'] = this.item;
    data['price'] = this.price;
    data['boolValue'] = this.boolValue;
    data['user'] = this.user;
    return data;
  }
}

// CLASSES TO USE DATA FROM FIRESTORE

// class ItemsAndUser {
//   String item;
//   String price;
//   String reciever;
// }
