
class DownloadReportModel {
/*
{
  "Sno": "1",
  "Status": "0",
  "Subject": "RWPL RESTRAINED OPERATIONS",
  "FileName": "RWPL RESTRAINED OPERATIONS.pdf",
  "DMType": "USER",
  "PStatus": "Active",
  "Msg": "SUCCESS"
}
*/

  String? Sno;
  String? Status;
  String? Subject;
  String? FileName;
  String? DMType;
  String? PStatus;
  String? Msg;

  DownloadReportModel({
    this.Sno,
    this.Status,
    this.Subject,
    this.FileName,
    this.DMType,
    this.PStatus,
    this.Msg,
  });
  DownloadReportModel.fromJson(Map<String, dynamic> json) {
    Sno = json['Sno']?.toString();
    Status = json['Status']?.toString();
    Subject = json['Subject']?.toString();
    FileName = json['FileName']?.toString();
    DMType = json['DMType']?.toString();
    PStatus = json['PStatus']?.toString();
    Msg = json['Msg']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Sno'] = Sno;
    data['Status'] = Status;
    data['Subject'] = Subject;
    data['FileName'] = FileName;
    data['DMType'] = DMType;
    data['PStatus'] = PStatus;
    data['Msg'] = Msg;
    return data;
  }
}
