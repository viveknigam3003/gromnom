class Restaurants {
  List<RestaurantInfo> restaurants;

  Restaurants({this.restaurants});

  Restaurants.fromJson(Map<String, dynamic> json) {
    if (json['restaurants'] != null) {
      restaurants = new List<RestaurantInfo>();
      json['restaurants'].forEach((v) {
        restaurants.add(new RestaurantInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.restaurants != null) {
      data['restaurants'] = this.restaurants.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RestaurantInfo {
  String name;
  int code;
  String rating;
  String costfortwo;

  RestaurantInfo({this.name, this.code, this.rating, this.costfortwo});

  RestaurantInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    rating = json['rating'];
    costfortwo = json['costfortwo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    data['rating'] = this.rating;
    data['costfortwo'] = this.costfortwo;
    return data;
  }
}

