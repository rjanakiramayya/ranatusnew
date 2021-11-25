import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:renatus/Models/profile_model.dart';
import 'package:renatus/Models/statemodel.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Utils/validator.dart';
import 'package:renatus/Widgets/sub_child_item.dart';
import 'package:renatus/Widgets/sub_header.dart';

class ProfileView extends StatefulWidget {
  static const String routeName = '/ProfilleView';

  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late bool isLoad, isEditing;
  late ProfileModel _profileModel;
  final _profileformKey = GlobalKey<FormState>();
  late List<StateModel> cities, states, district;
  late int cityindex,
      stateindex,
      relationindex,
      districtindex;
  late TextEditingController addressCtrl,
      userPincode,
      mobileCtrl,
      emailCtrl,
      nomineeCtrl;
  late DateTime pikeddateg;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoad = false;
    isEditing = false;
    cities = [];
    states = [];
    district = [];
    cityindex = 0;
    stateindex = 0;
    districtindex = 0;
    relationindex = 0;
    addressCtrl = TextEditingController();
    userPincode = TextEditingController();
    mobileCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    nomineeCtrl = TextEditingController();
    getProfileData();
  }

  Future<void> getProfileData() async {
    Map<String, dynamic> param = {
      'regid': SessionManager.getString(Constants.PREF_RegId),
    };
    NetworkCalls().callServer(Constants.apiMemberProfile, param).then((value) {
      var data = jsonDecode(value!.body);
      _profileModel = ProfileModel.fromJson(data);
      if (_profileModel.MemberProfile![0]!.Msg!.toUpperCase() ==
          Constants.success) {
        cities.add(StateModel(Id: '0', Value: _profileModel.MemberProfile![0]!.City!));
        states.add(StateModel(Id:  _profileModel.MemberProfile![0]!.StateID!, Value: _profileModel.MemberProfile![0]!.State!));
        //district.add(StateModel(Id: '0', Value: _profileModel.MemberProfile![0]!.!));
        setState(() {
          isLoad = true;
        });
      }
    }).catchError((_) {
      EasyLoading.showToast(Constants.somethingWrong);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          // TextButton(
          //   onPressed: () {
          //     if(isEditing) {
          //       //_onUpdateData();
          //     }else {
          //       setState(() {
          //         _profileModel.MemberProfile![0]!.Relation == '' ? relationindex = 0 :
          //         relationindex = Constants.relations.indexWhere((ele) => ele==_profileModel.MemberProfile![0]!.Relation);
          //         isEditing = true;
          //       });
          //     }
          //   },
          //   child: isEditing ? const Text('Update',style: TextStyle(color: Colors.white),) : const Text('Edit',style: TextStyle(color: Colors.white),),
          // ),
        ],
      ),
      body: !isLoad ? const Center() : SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Form(
            key: _profileformKey,
            child: Column(
              children: [
                const SubHeader('Sponsor Details'),
                SubChildItem('Sponsor Id', _profileModel.MemberProfile![0]!.Sponsor!, true),
                SubChildItem('Sponsor Name', _profileModel.MemberProfile![0]!.SponsorName!, true),
                const SubHeader('Personal Details'),
                SubChildItem('User Id', _profileModel.MemberProfile![0]!.Idno!, true),
                SubChildItem('User Name', SessionManager.getString(Constants.PREF_UserId), true),
                SubChildItem('Name', _profileModel.MemberProfile![0]!.Name!, true),
                SubChildItem('Date Of Birth', _profileModel.MemberProfile![0]!.DOB!, true),
                const SubHeader('Address Details'),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  enabled: isEditing,
                  controller: addressCtrl,
                  keyboardType: TextInputType.text,
                  maxLines: 3,
                  validator: (v) => Validator.inputValidate(v!.trim()),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  enabled: isEditing,
                  controller: userPincode,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  validator: (v) => Validator.pinCodeValidator(v!.trim()),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Pin Code',
                  ),
                  onChanged: (val) {
                    if (val.length == 6) {
                     // _callPinToDistrict(val,'','District');
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(0),
                //     border: Border.all(
                //       color: Colors.black38,
                //     ),
                //   ),
                //   child: DropdownButtonHideUnderline(
                //     child:  DropdownButton<StateModel>(
                //         iconEnabledColor: Colors.black,
                //         isExpanded: true,
                //         hint: Text(
                //           district[districtindex].Value,
                //           style: const TextStyle(
                //               color: Colors.black87,
                //               fontSize: 15.0,
                //               fontFamily: 'Nunito'),
                //         ),
                //         items: district.map((StateModel map) {
                //           return DropdownMenuItem<StateModel>(
                //             value: map,
                //             child:  Text(
                //               map.Value,
                //               style: const TextStyle(
                //                 fontSize: 15.0,
                //                 color: Colors.black87,
                //               ),
                //             ),
                //           );
                //         }).toList(),
                //         onChanged: (value) {
                //           setState(() {
                //             districtindex = district.indexOf(value!);
                //           });
                //           //_callDistTocity(userPincode.text,value.Id,'City');
                //         }),
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    border: Border.all(
                      color: Colors.black38,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<StateModel>(
                        iconEnabledColor: Colors.black,
                        isExpanded: true,
                        hint: Text(
                          cities[cityindex].Value,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 15.0,),
                        ),
                        items: cities.map((StateModel map) {
                          return  DropdownMenuItem<StateModel>(
                            value: map,
                            child:  Text(
                              map.Value,
                              style: const TextStyle(
                                fontSize: 15.0,
                                color: Colors.black87,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            //cityindex = cities.indexOf(value);
                          });
                          //_callStates(userPincode.text,'','State');
                        }),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    border: Border.all(
                      color: Colors.black38,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child:  DropdownButton<StateModel>(
                        iconEnabledColor: Colors.black,
                        isExpanded: true,
                        hint: Text(
                          states[stateindex].Value,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 15.0,
                              fontFamily: 'Nunito'),
                        ),
                        items: states.map((StateModel map) {
                          return DropdownMenuItem<StateModel>(
                            value: map,
                            child:  Text(
                              map.Value,
                              style: const TextStyle(
                                fontSize: 15.0,
                                color: Colors.black87,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {});
                        }),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  enabled: false,
                  controller: mobileCtrl,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  maxLines: 1,
                  validator: (v) => Validator.mobileValidator(v!.trim()),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mobile',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  enabled: isEditing,
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => Validator.emailValidator(v!),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                const SubHeader('Nominee Details'),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  enabled: isEditing,
                  controller: nomineeCtrl,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nominee Name',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                IgnorePointer(
                  ignoring: !isEditing,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      border: Border.all(
                        color: Colors.black38,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                          iconEnabledColor: Colors.black,
                          isExpanded: true,
                          hint: Text(
                            Constants.relations[relationindex],
                            style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 15.0,
                                fontFamily: 'Nunito'),
                          ),
                          items: Constants.relations.map((String map) {
                            return  DropdownMenuItem<String>(
                              value: map,
                              child:  Text(
                                map,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black87,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              relationindex = Constants.relations.indexOf(value!);
                            });
                          }),
                    ),
                  ),
                ),
                //datePicker('NomineeDOB'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
