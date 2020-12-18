// To parse this JSON data, do
//
// final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) =>
    UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  UserProfile({
    this.status,
    this.success,
  });

  int status;
  Success success;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        status: json["status"],
        success: Success.fromJson(json["success"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success.toJson(),
      };
}

class Success {
  Success({
    this.user,
    this.campaigns,
  });

  User user;
  List<Campaign> campaigns;

  factory Success.fromJson(Map<String, dynamic> json) => Success(
        user: User.fromJson(json["user"]),
        campaigns: List<Campaign>.from(
            json["campaigns"].map((x) => Campaign.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "campaigns": List<dynamic>.from(campaigns.map((x) => x.toJson())),
      };
}

class Campaign {
  Campaign({
    this.type,
    this.img,
    this.id,
    this.video,
    this.title,
    this.description,
    this.likeCount,
    this.islike,
    this.celebrity,
    this.bh,
    this.channel,
  });

  String type;
  String img;
  int id;
  dynamic video;
  String title;
  String description;
  int likeCount;
  bool islike;
  List<Bh> celebrity;
  Bh bh;
  List<Network> channel;

  factory Campaign.fromJson(Map<String, dynamic> json) => Campaign(
        type: json["type"],
        img: json["img"],
        id: json["id"],
        video: json["video"],
        title: json["title"],
        description: json["description"],
        likeCount: json["likeCount"],
        islike: json["islike"],
        celebrity: List<Bh>.from(json["celebrity"].map((x) => Bh.fromJson(x))),
        bh: Bh.fromJson(json["bh"]),
        channel:
            List<Network>.from(json["channel"].map((x) => Network.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "img": img,
        "id": id,
        "video": video,
        "title": title,
        "description": description,
        "likeCount": likeCount,
        "islike": islike,
        "celebrity": List<dynamic>.from(celebrity.map((x) => x.toJson())),
        "bh": bh.toJson(),
        "channel": List<dynamic>.from(channel.map((x) => x.toJson())),
      };
}

class Bh {
  Bh({
    this.id,
    this.username,
    this.photo,
    this.cropPhoto,
    this.network,
  });

  int id;
  String username;
  String photo;
  String cropPhoto;
  List<Network> network;

  factory Bh.fromJson(Map<String, dynamic> json) => Bh(
        id: json["id"],
        username: json["username"],
        photo: json["photo"],
        cropPhoto: json["crop_photo"] == null ? null : json["crop_photo"],
        network:
            List<Network>.from(json["network"].map((x) => Network.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "photo": photo,
        "crop_photo": cropPhoto == null ? null : cropPhoto,
        "network": List<dynamic>.from(network.map((x) => x.toJson())),
      };
}

class Network {
  Network({
    this.url,
    this.icon,
    this.name,
    this.image,
    this.folowers,
  });

  String url;
  String icon;
  String name;
  String image;
  int folowers;

  factory Network.fromJson(Map<String, dynamic> json) => Network(
        url: json["url"] ?? '',
        icon: json["icon"],
        name: json["name"],
        image: json["image"],
        folowers: json["folowers"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "url": url == null ? null : url,
        "icon": icon,
        "name": name,
        "image": image,
        "folowers": folowers == null ? null : folowers,
      };
}

class User {
  User({
    this.id,
    this.username,
    this.photo,
    this.cropPhoto,
    this.network,
    this.userType,
    this.category,
    this.specialty,
    this.specialtyBh,
  });

  int id;
  String username;
  String photo;
  dynamic cropPhoto;
  List<Network> network;
  int userType;
  List<Category> category;
  List<dynamic> specialty;
  List<dynamic> specialtyBh;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        photo: json["photo"],
        cropPhoto: json["crop_photo"],
        network:
            List<Network>.from(json["network"].map((x) => Network.fromJson(x))),
        userType: json["user_type"],
        category: List<Category>.from(
            json["category"].map((x) => Category.fromJson(x))),
        specialty: List<dynamic>.from(json["specialty"].map((x) => x)),
        specialtyBh: List<dynamic>.from(json["specialtyBh"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "photo": photo,
        "crop_photo": cropPhoto,
        "network": List<dynamic>.from(network.map((x) => x.toJson())),
        "user_type": userType,
        "category": List<dynamic>.from(category.map((x) => x.toJson())),
        "specialty": List<dynamic>.from(specialty.map((x) => x)),
        "specialtyBh": List<dynamic>.from(specialtyBh.map((x) => x)),
      };
}

class Category {
  Category({
    this.name,
    this.id,
  });

  String name;
  int id;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
