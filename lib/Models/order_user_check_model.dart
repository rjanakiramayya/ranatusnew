class OrderUserCheckModel {
/*
{
  "Msg": "SUCCESS",
  "Message": "success",
  "Balance": null,
  "Uid": null,
  "Username": null,
  "Idno": null
}
*/

  String? Msg;
  String? Message;
  String? Balance;
  String? Uid;
  String? Username;
  String? Idno;

  OrderUserCheckModel({
    this.Msg,
    this.Message,
    this.Balance,
    this.Uid,
    this.Username,
    this.Idno,
  });
  OrderUserCheckModel.fromJson(Map<String, dynamic> json) {
    Msg = json['Msg']?.toString();
    Message = json['Message']?.toString();
    Balance = json['Balance']?.toString();
    Uid = json['Uid']?.toString();
    Username = json['Username']?.toString();
    Idno = json['Idno']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Msg'] = Msg;
    data['Message'] = Message;
    data['Balance'] = Balance;
    data['Uid'] = Uid;
    data['Username'] = Username;
    data['Idno'] = Idno;
    return data;
  }
}
