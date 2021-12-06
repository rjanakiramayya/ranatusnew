
class UnilevelTreeModelUniLevelTreeViewTwo {
/*
{
  "UserID": "IRD10000002",
  "Sponser": "IRD10000001",
  "sprname": "Proprietor",
  "Sprcount": "1",
  "Name": "Renatus_3",
  "stsdate": "14 Sep 2018",
  "StsID": "1",
  "mstatus": "Active",
  "DownCnt": "0",
  "Team": "Team 1",
  "Regid": "2",
  "ResultCnt": "5",
  "Message": "Success"
}
*/

  String? UserID;
  String? Sponser;
  String? sprname;
  String? Sprcount;
  String? Name;
  String? stsdate;
  String? StsID;
  String? mstatus;
  String? DownCnt;
  String? Team;
  String? Regid;
  String? ResultCnt;
  String? Message;

  UnilevelTreeModelUniLevelTreeViewTwo({
    this.UserID,
    this.Sponser,
    this.sprname,
    this.Sprcount,
    this.Name,
    this.stsdate,
    this.StsID,
    this.mstatus,
    this.DownCnt,
    this.Team,
    this.Regid,
    this.ResultCnt,
    this.Message,
  });
  UnilevelTreeModelUniLevelTreeViewTwo.fromJson(Map<String, dynamic> json) {
    UserID = json['UserID']?.toString();
    Sponser = json['Sponser']?.toString();
    sprname = json['sprname']?.toString();
    Sprcount = json['Sprcount']?.toString();
    Name = json['Name']?.toString();
    stsdate = json['stsdate']?.toString();
    StsID = json['StsID']?.toString();
    mstatus = json['mstatus']?.toString();
    DownCnt = json['DownCnt']?.toString();
    Team = json['Team']?.toString();
    Regid = json['Regid']?.toString();
    ResultCnt = json['ResultCnt']?.toString();
    Message = json['Message']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['UserID'] = UserID;
    data['Sponser'] = Sponser;
    data['sprname'] = sprname;
    data['Sprcount'] = Sprcount;
    data['Name'] = Name;
    data['stsdate'] = stsdate;
    data['StsID'] = StsID;
    data['mstatus'] = mstatus;
    data['DownCnt'] = DownCnt;
    data['Team'] = Team;
    data['Regid'] = Regid;
    data['ResultCnt'] = ResultCnt;
    data['Message'] = Message;
    return data;
  }
}

class UnilevelTreeModelUniLevelTreeView {
/*
{
  "Regid": "1",
  "UserID": "IRD10000001",
  "Sponser": "-",
  "sprname": "",
  "Sprcount": "8",
  "Name": "Proprietor",
  "stsdate": "31 Dec 2009",
  "StsID": "1",
  "mstatus": "Active",
  "DownCnt": "0",
  "Message": "Success"
}
*/

  String? Regid;
  String? UserID;
  String? Sponser;
  String? sprname;
  String? Sprcount;
  String? Name;
  String? stsdate;
  String? StsID;
  String? mstatus;
  String? DownCnt;
  String? Message;

  UnilevelTreeModelUniLevelTreeView({
    this.Regid,
    this.UserID,
    this.Sponser,
    this.sprname,
    this.Sprcount,
    this.Name,
    this.stsdate,
    this.StsID,
    this.mstatus,
    this.DownCnt,
    this.Message,
  });
  UnilevelTreeModelUniLevelTreeView.fromJson(Map<String, dynamic> json) {
    Regid = json['Regid']?.toString();
    UserID = json['UserID']?.toString();
    Sponser = json['Sponser']?.toString();
    sprname = json['sprname']?.toString();
    Sprcount = json['Sprcount']?.toString();
    Name = json['Name']?.toString();
    stsdate = json['stsdate']?.toString();
    StsID = json['StsID']?.toString();
    mstatus = json['mstatus']?.toString();
    DownCnt = json['DownCnt']?.toString();
    Message = json['Message']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Regid'] = Regid;
    data['UserID'] = UserID;
    data['Sponser'] = Sponser;
    data['sprname'] = sprname;
    data['Sprcount'] = Sprcount;
    data['Name'] = Name;
    data['stsdate'] = stsdate;
    data['StsID'] = StsID;
    data['mstatus'] = mstatus;
    data['DownCnt'] = DownCnt;
    data['Message'] = Message;
    return data;
  }
}

class UnilevelTreeModel {
/*
{
  "UniLevelTreeView": [
    {
      "Regid": "1",
      "UserID": "IRD10000001",
      "Sponser": "-",
      "sprname": "",
      "Sprcount": "8",
      "Name": "Proprietor",
      "stsdate": "31 Dec 2009",
      "StsID": "1",
      "mstatus": "Active",
      "DownCnt": "0",
      "Message": "Success"
    }
  ],
  "UniLevelTreeViewTwo": [
    {
      "UserID": "IRD10000002",
      "Sponser": "IRD10000001",
      "sprname": "Proprietor",
      "Sprcount": "1",
      "Name": "Renatus_3",
      "stsdate": "14 Sep 2018",
      "StsID": "1",
      "mstatus": "Active",
      "DownCnt": "0",
      "Team": "Team 1",
      "Regid": "2",
      "ResultCnt": "5",
      "Message": "Success"
    }
  ],
  "Msg": null,
  "Message": null,
  "Result": null
}
*/

  List<UnilevelTreeModelUniLevelTreeView?>? UniLevelTreeView;
  List<UnilevelTreeModelUniLevelTreeViewTwo?>? UniLevelTreeViewTwo;
  String? Msg;
  String? Message;
  String? Result;

  UnilevelTreeModel({
    this.UniLevelTreeView,
    this.UniLevelTreeViewTwo,
    this.Msg,
    this.Message,
    this.Result,
  });
  UnilevelTreeModel.fromJson(Map<String, dynamic> json) {
    if (json['UniLevelTreeView'] != null) {
      final v = json['UniLevelTreeView'];
      final arr0 = <UnilevelTreeModelUniLevelTreeView>[];
      v.forEach((v) {
        arr0.add(UnilevelTreeModelUniLevelTreeView.fromJson(v));
      });
      UniLevelTreeView = arr0;
    }
    if (json['UniLevelTreeViewTwo'] != null) {
      final v = json['UniLevelTreeViewTwo'];
      final arr0 = <UnilevelTreeModelUniLevelTreeViewTwo>[];
      v.forEach((v) {
        arr0.add(UnilevelTreeModelUniLevelTreeViewTwo.fromJson(v));
      });
      UniLevelTreeViewTwo = arr0;
    }
    Msg = json['Msg']?.toString();
    Message = json['Message']?.toString();
    Result = json['Result']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (UniLevelTreeView != null) {
      final v = UniLevelTreeView;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['UniLevelTreeView'] = arr0;
    }
    if (UniLevelTreeViewTwo != null) {
      final v = UniLevelTreeViewTwo;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['UniLevelTreeViewTwo'] = arr0;
    }
    data['Msg'] = Msg;
    data['Message'] = Message;
    data['Result'] = Result;
    return data;
  }
}
