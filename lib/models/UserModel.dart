class UserModel {
  String googleIdToken;
  String uid;
  String name;
  String photoUrlFull;
  String email;
  String phoneNumber;



  UserModel({
    this.googleIdToken,
    this.uid,
    this.name,
    this.photoUrlFull,
    this.email,this.phoneNumber
 
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    googleIdToken: json["googleIdToken"],
    uid: json["aud"],
    name: json["name"],
    photoUrlFull: json["picture"] ,
    email: json["email"],
    
  );

  Map<String, dynamic> toJson() => {
    "googleIdToken": googleIdToken,
    "aud": uid,
    "name": name,
    "picture":  photoUrlFull,
    "email": email,
  };
}