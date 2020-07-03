class EmergencyNumberModel {
  String title;
  String image;
  String phoneNumber;
  String action;
  String message;

  EmergencyNumberModel(
      {this.title, this.image, this.phoneNumber, this.action, this.message});

  EmergencyNumberModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
    phoneNumber = json['phone_number'];
    action = json['action'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['image'] = this.image;
    data['phone_number'] = this.phoneNumber;
    data['action'] = this.action;
    data['message'] = this.message;
    return data;
  }
}
