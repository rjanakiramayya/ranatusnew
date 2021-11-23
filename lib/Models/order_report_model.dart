///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class OrderReportModel {
/*
{
  "Fcode": "stores",
  "Idno": "IRD10000001",
  "Name": "Proprietor  Proprietor",
  "BillNo": "569419",
  "TotAmt": "460.20",
  "TotBV": "4.00",
  "TotQty": "1",
  "BillDate": "Nov 18 2021 12:25PM",
  "OrdDate": "Nov 18 2021 12:25PM",
  "RepType": "Repurchase",
  "OrdStatus": "Approved",
  "TaxType": "IGST",
  "DispDetails": "",
  "InvNo": "JH/2122/0000094",
  "shpName": null,
  "City": null,
  "Mobile": null,
  "DispBy": "",
  "DispRemarks": "",
  "DispMode": "By Courier",
  "Msg": "SUCCESS",
  "Message": null
}
*/

  String? Fcode;
  String? Idno;
  String? Name;
  String? BillNo;
  String? TotAmt;
  String? TotBV;
  String? TotQty;
  String? BillDate;
  String? OrdDate;
  String? RepType;
  String? OrdStatus;
  String? TaxType;
  String? DispDetails;
  String? InvNo;
  String? shpName;
  String? City;
  String? Mobile;
  String? DispBy;
  String? DispRemarks;
  String? DispMode;
  String? Msg;
  String? Message;

  OrderReportModel({
    this.Fcode,
    this.Idno,
    this.Name,
    this.BillNo,
    this.TotAmt,
    this.TotBV,
    this.TotQty,
    this.BillDate,
    this.OrdDate,
    this.RepType,
    this.OrdStatus,
    this.TaxType,
    this.DispDetails,
    this.InvNo,
    this.shpName,
    this.City,
    this.Mobile,
    this.DispBy,
    this.DispRemarks,
    this.DispMode,
    this.Msg,
    this.Message,
  });
  OrderReportModel.fromJson(Map<String, dynamic> json) {
    Fcode = json['Fcode']?.toString();
    Idno = json['Idno']?.toString();
    Name = json['Name']?.toString();
    BillNo = json['BillNo']?.toString();
    TotAmt = json['TotAmt']?.toString();
    TotBV = json['TotBV']?.toString();
    TotQty = json['TotQty']?.toString();
    BillDate = json['BillDate']?.toString();
    OrdDate = json['OrdDate']?.toString();
    RepType = json['RepType']?.toString();
    OrdStatus = json['OrdStatus']?.toString();
    TaxType = json['TaxType']?.toString();
    DispDetails = json['DispDetails']?.toString();
    InvNo = json['InvNo']?.toString();
    shpName = json['shpName']?.toString();
    City = json['City']?.toString();
    Mobile = json['Mobile']?.toString();
    DispBy = json['DispBy']?.toString();
    DispRemarks = json['DispRemarks']?.toString();
    DispMode = json['DispMode']?.toString();
    Msg = json['Msg']?.toString();
    Message = json['Message']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Fcode'] = Fcode;
    data['Idno'] = Idno;
    data['Name'] = Name;
    data['BillNo'] = BillNo;
    data['TotAmt'] = TotAmt;
    data['TotBV'] = TotBV;
    data['TotQty'] = TotQty;
    data['BillDate'] = BillDate;
    data['OrdDate'] = OrdDate;
    data['RepType'] = RepType;
    data['OrdStatus'] = OrdStatus;
    data['TaxType'] = TaxType;
    data['DispDetails'] = DispDetails;
    data['InvNo'] = InvNo;
    data['shpName'] = shpName;
    data['City'] = City;
    data['Mobile'] = Mobile;
    data['DispBy'] = DispBy;
    data['DispRemarks'] = DispRemarks;
    data['DispMode'] = DispMode;
    data['Msg'] = Msg;
    data['Message'] = Message;
    return data;
  }
}