///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class CreditRequestReportModel {
/*
{
  "Msg": "SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM.",
  "depslip": null,
  "UserID": null,
  "Name": null,
  "ReqCode": null,
  "Reqdate": null,
  "ReqAmt": null,
  "City": null,
  "Mobile": null,
  "MOP": null,
  "bank": null,
  "Branch": null,
  "MOPDet": null,
  "Depdet": null,
  "Sts": null,
  "Upby": null,
  "Updated": null,
  "Remarks": null,
  "cnfcode": null,
  "cnfname": null,
  "UserRemarks": null
}
*/

  String? Msg;
  String? depslip;
  String? UserID;
  String? Name;
  String? ReqCode;
  String? Reqdate;
  String? ReqAmt;
  String? City;
  String? Mobile;
  String? MOP;
  String? bank;
  String? Branch;
  String? MOPDet;
  String? Depdet;
  String? Sts;
  String? Upby;
  String? Updated;
  String? Remarks;
  String? cnfcode;
  String? cnfname;
  String? UserRemarks;

  CreditRequestReportModel({
    this.Msg,
    this.depslip,
    this.UserID,
    this.Name,
    this.ReqCode,
    this.Reqdate,
    this.ReqAmt,
    this.City,
    this.Mobile,
    this.MOP,
    this.bank,
    this.Branch,
    this.MOPDet,
    this.Depdet,
    this.Sts,
    this.Upby,
    this.Updated,
    this.Remarks,
    this.cnfcode,
    this.cnfname,
    this.UserRemarks,
  });
  CreditRequestReportModel.fromJson(Map<String, dynamic> json) {
    Msg = json['Msg']?.toString();
    depslip = json['depslip']?.toString();
    UserID = json['UserID']?.toString();
    Name = json['Name']?.toString();
    ReqCode = json['ReqCode']?.toString();
    Reqdate = json['Reqdate']?.toString();
    ReqAmt = json['ReqAmt']?.toString();
    City = json['City']?.toString();
    Mobile = json['Mobile']?.toString();
    MOP = json['MOP']?.toString();
    bank = json['bank']?.toString();
    Branch = json['Branch']?.toString();
    MOPDet = json['MOPDet']?.toString();
    Depdet = json['Depdet']?.toString();
    Sts = json['Sts']?.toString();
    Upby = json['Upby']?.toString();
    Updated = json['Updated']?.toString();
    Remarks = json['Remarks']?.toString();
    cnfcode = json['cnfcode']?.toString();
    cnfname = json['cnfname']?.toString();
    UserRemarks = json['UserRemarks']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Msg'] = Msg;
    data['depslip'] = depslip;
    data['UserID'] = UserID;
    data['Name'] = Name;
    data['ReqCode'] = ReqCode;
    data['Reqdate'] = Reqdate;
    data['ReqAmt'] = ReqAmt;
    data['City'] = City;
    data['Mobile'] = Mobile;
    data['MOP'] = MOP;
    data['bank'] = bank;
    data['Branch'] = Branch;
    data['MOPDet'] = MOPDet;
    data['Depdet'] = Depdet;
    data['Sts'] = Sts;
    data['Upby'] = Upby;
    data['Updated'] = Updated;
    data['Remarks'] = Remarks;
    data['cnfcode'] = cnfcode;
    data['cnfname'] = cnfname;
    data['UserRemarks'] = UserRemarks;
    return data;
  }
}