///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class IncomeReportModel {
/*
{
  "Msg": "SUCCESS",
  "Regid": "793432",
  "Idno": "IRD76249193",
  "Name": "KAMALKumar",
  "TotLeft": "0.0000",
  "TotRight": "0.0000",
  "BFLeft": "0.0000",
  "BFRight": "0.0000",
  "CurLeft": "0.0000",
  "CurRight": "0.0000",
  "Epairs": "173.0000",
  "CFLeft": "0.0000",
  "CFRight": "0.0000",
  "SchFrom": "29 Aug 2021",
  "SchTo": "11 Oct 2021",
  "BFAmt": "0.0000",
  "GrAmt": "830.4000",
  "SC": "0.0000",
  "TDS": "41.5200",
  "NetAmt": "788.8800",
  "Accno": "50170015103688",
  "Bank": "BANDHAN BANK LIMITED",
  "Branch": "GADARPUR",
  "BinCC": "13.8400",
  "GBACC": "0.0000",
  "TotalCC": "13.8400",
  "BinDedCC": "0.0000",
  "GBADedCC": "0.0000",
  "TotalDedCC": "0.0000",
  "BlncAmt": "13.8400",
  "GBAAmt": "0.0000",
  "FinalTotalCC": "13.8400",
  "Remarks": "",
  "TypeOfInc": "W",
  "PayNo": "107",
  "RankName": "Associate",
  "PackageName": "Professional Pack",
  "Mper": "8.0000",
  "TDBEligible": "NO",
  "PaymentDate": "",
  "TrnRefNo": "",
  "Payment_Remarks": "",
  "PaymentStatus": "Pending",
  "HL_TotalPV": "2295.0000",
  "OL_TotalPV": "173.0000",
  "SelfBV": "0.0000",
  "GroupBV": "694.0000",
  "TotalBV": "694.0000",
  "AdvDed": "0.0000",
  "Sno": "0"
}
*/

  String? Msg;
  String? Regid;
  String? Idno;
  String? Name;
  String? TotLeft;
  String? TotRight;
  String? BFLeft;
  String? BFRight;
  String? CurLeft;
  String? CurRight;
  String? Epairs;
  String? CFLeft;
  String? CFRight;
  String? SchFrom;
  String? SchTo;
  String? BFAmt;
  String? GrAmt;
  String? SC;
  String? TDS;
  String? NetAmt;
  String? Accno;
  String? Bank;
  String? Branch;
  String? BinCC;
  String? GBACC;
  String? TotalCC;
  String? BinDedCC;
  String? GBADedCC;
  String? TotalDedCC;
  String? BlncAmt;
  String? GBAAmt;
  String? FinalTotalCC;
  String? Remarks;
  String? TypeOfInc;
  String? PayNo;
  String? RankName;
  String? PackageName;
  String? Mper;
  String? TDBEligible;
  String? PaymentDate;
  String? TrnRefNo;
  String? PaymentRemarks;
  String? PaymentStatus;
  String? HLTotalPV;
  String? OLTotalPV;
  String? SelfBV;
  String? GroupBV;
  String? TotalBV;
  String? AdvDed;
  String? Sno;

  IncomeReportModel({
    this.Msg,
    this.Regid,
    this.Idno,
    this.Name,
    this.TotLeft,
    this.TotRight,
    this.BFLeft,
    this.BFRight,
    this.CurLeft,
    this.CurRight,
    this.Epairs,
    this.CFLeft,
    this.CFRight,
    this.SchFrom,
    this.SchTo,
    this.BFAmt,
    this.GrAmt,
    this.SC,
    this.TDS,
    this.NetAmt,
    this.Accno,
    this.Bank,
    this.Branch,
    this.BinCC,
    this.GBACC,
    this.TotalCC,
    this.BinDedCC,
    this.GBADedCC,
    this.TotalDedCC,
    this.BlncAmt,
    this.GBAAmt,
    this.FinalTotalCC,
    this.Remarks,
    this.TypeOfInc,
    this.PayNo,
    this.RankName,
    this.PackageName,
    this.Mper,
    this.TDBEligible,
    this.PaymentDate,
    this.TrnRefNo,
    this.PaymentRemarks,
    this.PaymentStatus,
    this.HLTotalPV,
    this.OLTotalPV,
    this.SelfBV,
    this.GroupBV,
    this.TotalBV,
    this.AdvDed,
    this.Sno,
  });
  IncomeReportModel.fromJson(Map<String, dynamic> json) {
    Msg = json['Msg']?.toString();
    Regid = json['Regid']?.toString();
    Idno = json['Idno']?.toString();
    Name = json['Name']?.toString();
    TotLeft = json['TotLeft']?.toString();
    TotRight = json['TotRight']?.toString();
    BFLeft = json['BFLeft']?.toString();
    BFRight = json['BFRight']?.toString();
    CurLeft = json['CurLeft']?.toString();
    CurRight = json['CurRight']?.toString();
    Epairs = json['Epairs']?.toString();
    CFLeft = json['CFLeft']?.toString();
    CFRight = json['CFRight']?.toString();
    SchFrom = json['SchFrom']?.toString();
    SchTo = json['SchTo']?.toString();
    BFAmt = json['BFAmt']?.toString();
    GrAmt = json['GrAmt']?.toString();
    SC = json['SC']?.toString();
    TDS = json['TDS']?.toString();
    NetAmt = json['NetAmt']?.toString();
    Accno = json['Accno']?.toString();
    Bank = json['Bank']?.toString();
    Branch = json['Branch']?.toString();
    BinCC = json['BinCC']?.toString();
    GBACC = json['GBACC']?.toString();
    TotalCC = json['TotalCC']?.toString();
    BinDedCC = json['BinDedCC']?.toString();
    GBADedCC = json['GBADedCC']?.toString();
    TotalDedCC = json['TotalDedCC']?.toString();
    BlncAmt = json['BlncAmt']?.toString();
    GBAAmt = json['GBAAmt']?.toString();
    FinalTotalCC = json['FinalTotalCC']?.toString();
    Remarks = json['Remarks']?.toString();
    TypeOfInc = json['TypeOfInc']?.toString();
    PayNo = json['PayNo']?.toString();
    RankName = json['RankName']?.toString();
    PackageName = json['PackageName']?.toString();
    Mper = json['Mper']?.toString();
    TDBEligible = json['TDBEligible']?.toString();
    PaymentDate = json['PaymentDate']?.toString();
    TrnRefNo = json['TrnRefNo']?.toString();
    PaymentRemarks = json['Payment_Remarks']?.toString();
    PaymentStatus = json['PaymentStatus']?.toString();
    HLTotalPV = json['HL_TotalPV']?.toString();
    OLTotalPV = json['OL_TotalPV']?.toString();
    SelfBV = json['SelfBV']?.toString();
    GroupBV = json['GroupBV']?.toString();
    TotalBV = json['TotalBV']?.toString();
    AdvDed = json['AdvDed']?.toString();
    Sno = json['Sno']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Msg'] = Msg;
    data['Regid'] = Regid;
    data['Idno'] = Idno;
    data['Name'] = Name;
    data['TotLeft'] = TotLeft;
    data['TotRight'] = TotRight;
    data['BFLeft'] = BFLeft;
    data['BFRight'] = BFRight;
    data['CurLeft'] = CurLeft;
    data['CurRight'] = CurRight;
    data['Epairs'] = Epairs;
    data['CFLeft'] = CFLeft;
    data['CFRight'] = CFRight;
    data['SchFrom'] = SchFrom;
    data['SchTo'] = SchTo;
    data['BFAmt'] = BFAmt;
    data['GrAmt'] = GrAmt;
    data['SC'] = SC;
    data['TDS'] = TDS;
    data['NetAmt'] = NetAmt;
    data['Accno'] = Accno;
    data['Bank'] = Bank;
    data['Branch'] = Branch;
    data['BinCC'] = BinCC;
    data['GBACC'] = GBACC;
    data['TotalCC'] = TotalCC;
    data['BinDedCC'] = BinDedCC;
    data['GBADedCC'] = GBADedCC;
    data['TotalDedCC'] = TotalDedCC;
    data['BlncAmt'] = BlncAmt;
    data['GBAAmt'] = GBAAmt;
    data['FinalTotalCC'] = FinalTotalCC;
    data['Remarks'] = Remarks;
    data['TypeOfInc'] = TypeOfInc;
    data['PayNo'] = PayNo;
    data['RankName'] = RankName;
    data['PackageName'] = PackageName;
    data['Mper'] = Mper;
    data['TDBEligible'] = TDBEligible;
    data['PaymentDate'] = PaymentDate;
    data['TrnRefNo'] = TrnRefNo;
    data['Payment_Remarks'] = PaymentRemarks;
    data['PaymentStatus'] = PaymentStatus;
    data['HL_TotalPV'] = HLTotalPV;
    data['OL_TotalPV'] = OLTotalPV;
    data['SelfBV'] = SelfBV;
    data['GroupBV'] = GroupBV;
    data['TotalBV'] = TotalBV;
    data['AdvDed'] = AdvDed;
    data['Sno'] = Sno;
    return data;
  }
}
