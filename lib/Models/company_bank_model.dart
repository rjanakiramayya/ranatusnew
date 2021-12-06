
class CompanyBankDetailsModelCompanyBanks {
/*
{
  "CBId": "1",
  "Bank": "State Bank of India",
  "Branch": "BHASKAR RAO NAGAR",
  "Accno": "00000038003260283",
  "IFSC": "SBIN0015568",
  "City": "Hyderabad",
  "State": "Telangana",
  "StateId": "36",
  "CBStatus": "0",
  "UpdatedOn": "",
  "UpdatedBy": "",
  "BankImage": "",
  "Msg": "SUCCESS"
}
*/

  String? CBId;
  String? Bank;
  String? Branch;
  String? Accno;
  String? IFSC;
  String? City;
  String? State;
  String? StateId;
  String? CBStatus;
  String? UpdatedOn;
  String? UpdatedBy;
  String? BankImage;
  String? Msg;

  CompanyBankDetailsModelCompanyBanks({
    this.CBId,
    this.Bank,
    this.Branch,
    this.Accno,
    this.IFSC,
    this.City,
    this.State,
    this.StateId,
    this.CBStatus,
    this.UpdatedOn,
    this.UpdatedBy,
    this.BankImage,
    this.Msg,
  });
  CompanyBankDetailsModelCompanyBanks.fromJson(Map<String, dynamic> json) {
    CBId = json['CBId']?.toString();
    Bank = json['Bank']?.toString();
    Branch = json['Branch']?.toString();
    Accno = json['Accno']?.toString();
    IFSC = json['IFSC']?.toString();
    City = json['City']?.toString();
    State = json['State']?.toString();
    StateId = json['StateId']?.toString();
    CBStatus = json['CBStatus']?.toString();
    UpdatedOn = json['UpdatedOn']?.toString();
    UpdatedBy = json['UpdatedBy']?.toString();
    BankImage = json['BankImage']?.toString();
    Msg = json['Msg']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['CBId'] = CBId;
    data['Bank'] = Bank;
    data['Branch'] = Branch;
    data['Accno'] = Accno;
    data['IFSC'] = IFSC;
    data['City'] = City;
    data['State'] = State;
    data['StateId'] = StateId;
    data['CBStatus'] = CBStatus;
    data['UpdatedOn'] = UpdatedOn;
    data['UpdatedBy'] = UpdatedBy;
    data['BankImage'] = BankImage;
    data['Msg'] = Msg;
    return data;
  }
}

class CompanyBankDetailsModel {
/*
{
  "CompanyBanks": [
    {
      "CBId": "1",
      "Bank": "State Bank of India",
      "Branch": "BHASKAR RAO NAGAR",
      "Accno": "00000038003260283",
      "IFSC": "SBIN0015568",
      "City": "Hyderabad",
      "State": "Telangana",
      "StateId": "36",
      "CBStatus": "0",
      "UpdatedOn": "",
      "UpdatedBy": "",
      "BankImage": "",
      "Msg": "SUCCESS"
    }
  ],
  "Message": null,
  "Msg": null
}
*/

  List<CompanyBankDetailsModelCompanyBanks?>? CompanyBanks;
  String? Message;
  String? Msg;

  CompanyBankDetailsModel({
    this.CompanyBanks,
    this.Message,
    this.Msg,
  });
  CompanyBankDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['CompanyBanks'] != null) {
      final v = json['CompanyBanks'];
      final arr0 = <CompanyBankDetailsModelCompanyBanks>[];
      v.forEach((v) {
        arr0.add(CompanyBankDetailsModelCompanyBanks.fromJson(v));
      });
      CompanyBanks = arr0;
    }
    Message = json['Message']?.toString();
    Msg = json['Msg']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (CompanyBanks != null) {
      final v = CompanyBanks;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['CompanyBanks'] = arr0;
    }
    data['Message'] = Message;
    data['Msg'] = Msg;
    return data;
  }
}
