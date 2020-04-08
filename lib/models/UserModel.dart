class UserModel {
  String uid;
  String name;
  String photoUrlFull;
  String email;
  String phoneNumber;



  UserModel({
    this.uid,
    this.name,
    this.photoUrlFull,
    this.email,this.phoneNumber
 
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json["aud"],
    name: json["name"],
    photoUrlFull: json["picture"] ,
    email: json["email"],
    
  );

  Map<String, dynamic> toJson() => {
    "aud": uid,
    "name": name,
    "picture":  photoUrlFull,
    "email": email,
  };
}