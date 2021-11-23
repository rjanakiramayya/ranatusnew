class StateModel {
  late String Id;
  late String Value;

  StateModel({required this.Id,required this.Value});

  factory StateModel.fromJson(Map<String, dynamic> item) {
    return StateModel(Id:item['Id'], Value: item['Value']);
  }

  factory StateModel.stateJson(Map<String, dynamic> item) {
    return StateModel(Id:item['StateId'], Value: item['StateName']);
  }
}