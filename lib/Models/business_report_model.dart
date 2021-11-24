class BusinessReportModel {
/*
{
  "RNo": "1",
  "regid": "1",
  "Idno": "IRD10000001",
  "Name": "Proprietor Proprietor",
  "CityName": "Pune",
  "StateName": "Maharashtra",
  "JoinDate": "Dec 31 2009  6:30PM",
  "ActDate": "Dec 31 2009  6:30PM",
  "Status": "Active",
  "SelfJBV": "58.0000",
  "DownJBV": "37380014.0000",
  "TotJBV": "37380072.0000",
  "SelfRBV": "0",
  "DownRBV": "0",
  "TotRBV": "0",
  "Purchase": "SELF",
  "Msg": "SUCCESS",
  "Message": null
}
*/

  String? RNo;
  String? regid;
  String? Idno;
  String? Name;
  String? CityName;
  String? StateName;
  String? JoinDate;
  String? ActDate;
  String? Status;
  String? SelfJBV;
  String? DownJBV;
  String? TotJBV;
  String? SelfRBV;
  String? DownRBV;
  String? TotRBV;
  String? Purchase;
  String? Msg;
  String? Message;

  BusinessReportModel({
    this.RNo,
    this.regid,
    this.Idno,
    this.Name,
    this.CityName,
    this.StateName,
    this.JoinDate,
    this.ActDate,
    this.Status,
    this.SelfJBV,
    this.DownJBV,
    this.TotJBV,
    this.SelfRBV,
    this.DownRBV,
    this.TotRBV,
    this.Purchase,
    this.Msg,
    this.Message,
  });
  BusinessReportModel.fromJson(Map<String, dynamic> json) {
    RNo = json['RNo']?.toString();
    regid = json['regid']?.toString();
    Idno = json['Idno']?.toString();
    Name = json['Name']?.toString();
    CityName = json['CityName']?.toString();
    StateName = json['StateName']?.toString();
    JoinDate = json['JoinDate']?.toString();
    ActDate = json['ActDate']?.toString();
    Status = json['Status']?.toString();
    SelfJBV = json['SelfJBV']?.toString();
    DownJBV = json['DownJBV']?.toString();
    TotJBV = json['TotJBV']?.toString();
    SelfRBV = json['SelfRBV']?.toString();
    DownRBV = json['DownRBV']?.toString();
    TotRBV = json['TotRBV']?.toString();
    Purchase = json['Purchase']?.toString();
    Msg = json['Msg']?.toString();
    Message = json['Message']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['RNo'] = RNo;
    data['regid'] = regid;
    data['Idno'] = Idno;
    data['Name'] = Name;
    data['CityName'] = CityName;
    data['StateName'] = StateName;
    data['JoinDate'] = JoinDate;
    data['ActDate'] = ActDate;
    data['Status'] = Status;
    data['SelfJBV'] = SelfJBV;
    data['DownJBV'] = DownJBV;
    data['TotJBV'] = TotJBV;
    data['SelfRBV'] = SelfRBV;
    data['DownRBV'] = DownRBV;
    data['TotRBV'] = TotRBV;
    data['Purchase'] = Purchase;
    data['Msg'] = Msg;
    data['Message'] = Message;
    return data;
  }
}
