import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as get1;
import 'package:get/get_core/src/get_main.dart';
import 'package:graphview/GraphView.dart';
import 'package:renatus/Models/tree_model.dart';
import 'package:renatus/Models/unilevel_tree_details_model.dart';
import 'package:renatus/Models/unilevel_tree_model.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Widgets/sub_child_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenealogyUnilevel extends StatefulWidget {
  static const routeName = '/TreeViewPage';

  @override
  _GenealogyUnilevelPageState createState() => _GenealogyUnilevelPageState();
}

class _GenealogyUnilevelPageState extends State<GenealogyUnilevel> {

  late List<TreeModel> treelist;
  late List<Node> nodesList;
  late bool isLoad;
  late TextEditingController ibsCtrl;
  late String regid, psw, parentNode;
  late Graph graph;
  late BuchheimWalkerConfiguration builder;
  late String IDNO, PWD;
  var searchId;
  late Map<String, dynamic> args;

  @override
  void initState() {
    isLoad = true;
    ibsCtrl = TextEditingController();
    treelist = [];
    IDNO = SessionManager.getString(Constants.PREF_IDNo);
    nodesList = [];
    parentNode = Get.arguments;
    callServer1(IDNO, parentNode);
    EasyLoading.showToast('Long Click on Image To View Details Of Member.',toastPosition: EasyLoadingToastPosition.bottom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visual Genealogy'),
      ),
      body: Center(
        child: isLoad
            ? const Center()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              children: [
                Container(
                  width: 230,
                  padding: const EdgeInsets.all(3),
                  child: TextField(
                    controller: ibsCtrl,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(r'\s'),
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'User IRD ID',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  height: 72,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            width: 2),),
                    child: Text(
                      'Go',
                      style: TextStyle(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          fontSize: 19),
                    ),
                    color: Colors.white,
                    onPressed: () {
                      if (ibsCtrl.text.trim().isEmpty) {
                        Logger.ShowWorningAlert('Warning', 'Please Enter User ID');
                      } else {
                        callPlacementCheck(ibsCtrl.text.trim());
                      }
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Center(
                  child: InteractiveViewer(
                    constrained: false,
                    scaleEnabled: true,
                    boundaryMargin:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    minScale: 0.01,
                    // maxScale: 5.6,
                    child: GraphView(
                      graph: graph,
                      algorithm: BuchheimWalkerAlgorithm(
                          builder, TreeEdgeRenderer(builder)),
                      paint:  Paint()
                        ..color = Colors.green
                        ..strokeWidth = 1
                        ..style = PaintingStyle.stroke,
                      builder: (Node node) {
                        // I can decide what widget should be shown here based on the id
                        var a = node.key!.value as int?;
                        return rectangleWidget(a);
                      },
                      //renderer: TreeEdgeRenderer(builder),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rectangleWidget(int? a) {
    return InkWell(
      onTap: () {
        print('clicked');
      },
      child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(color: Colors.blue[100]!, spreadRadius: 1),
            ],
          ),
          child: Text('Node ${a}')),
    );
  }

  Future<void> getGenealogyToolTip(String idno) async {
    Map<String, dynamic> param = {
      'Idno': idno,
      'Action': "Unilevel",
    };
    NetworkCalls()
        .callServer(Constants.apiGetParentTree, param)
        .then((value) {
        UnilevelTreeDetailsModel model = UnilevelTreeDetailsModel.fromJson(jsonDecode(value!.body));
      if (model.UniLevelTreeViewDet!.length > 0) {
        _showOfferPopUp(model);
      } else {
        Logger.ShowWorningAlert('Warning', 'No Data Found');
      }
    });
  }

  Widget getNodeText(TreeModel e) {
    String imagpath;
    if (e.Icon == 'Active') {
      imagpath = '${Constants.iconPath}active.png';
    } else if (e.Icon == 'InActive') {
      imagpath = '${Constants.iconPath}inactive.png';
    } else {
      imagpath = '${Constants.iconPath}inactive.png';
    }
    Logger.log('sdasd${imagpath}');

    return GestureDetector(
      onLongPressStart: (details) {
        //var x = details.globalPosition.dx;
        //var y = details.globalPosition.dy;
        Offset(0.0, 0.0);
        //print('x=${x} y= ${y}');
      },
      onTap: () {
        callServer(IDNO, e.Idno);
      },
      onLongPress: () {
        getGenealogyToolTip(e.Idno);
      },
      onPanStart: (details) {
        var x = 0.0;
        var y = 0.0;
        setState(() {
          //builder.setFocusedNode(graph.getNodeAtPosition(i-1));
          graph
              .getNodeAtPosition(1)
              .position = Offset(x, y);
        });
      },
      onPanUpdate: (details) {
        var x = details.globalPosition.dx;
        var y = details.globalPosition.dy;
        setState(() {
          //builder.setFocusedNode(graph.getNodeAtPosition(i-1));
          graph
              .getNodeAtPosition(1)
              .position = const Offset(0.0, 0.0);
        });
      },
      onPanEnd: (details) {
        //builder.setFocusedNode(null);
      },
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Image.asset(
            imagpath,
            height: 40,
            width: 40,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(e.Idno),
          Text(e.Name),
          Text(e.Team,style: const TextStyle(color: Colors.green),),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void callServer(String Idno, String SearchIDNO) async {
    print('${Idno.toLowerCase()} == ${SearchIDNO.toLowerCase()}');
    if (treelist.length > 1) {
      if(parentNode!=SearchIDNO) {
        Get.toNamed(GenealogyUnilevel.routeName,arguments: SearchIDNO,preventDuplicates: false);
      }
    }
  }

  void callServer1(String Idno, String SearchIDNO) async {
    setState(() {
      isLoad = true;
    });
    Map<String, String> param = {
      'Action': 'UnilevelMember',
      'idno': SearchIDNO,
    };
    NetworkCalls().callServer(Constants.apiGetSubTreeUniway, param).then((value) {
      var data = jsonDecode(value!.body);
      UnilevelTreeModel unilevelModel = UnilevelTreeModel.fromJson(data);
      if (unilevelModel.UniLevelTreeView!.length > 0) {
        treelist.clear();
        treelist.add(TreeModel(Idno: unilevelModel.UniLevelTreeView![0]!.UserID!, Icon: unilevelModel.UniLevelTreeView![0]!.mstatus!, Regid: unilevelModel.UniLevelTreeView![0]!.Regid!, Name: unilevelModel.UniLevelTreeView![0]!.Name!, Team: '', Status: unilevelModel.UniLevelTreeView![0]!.mstatus!));
        treelist.addAll(unilevelModel.UniLevelTreeViewTwo!.map((e) => TreeModel(Idno: e!.UserID!, Icon: e!.mstatus!, Regid: e!.Regid!, Name: e!.Name!, Team: e!.Team!, Status: e!.mstatus!)));
        callCreateNodes();
      } else {
        callCreateNodes();
        ibsCtrl.text = '';
        Get.snackbar('Error', Constants.NODATAFOUND,
            margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
            backgroundColor: Colors.blue);
      }
    });
  }

  void callPlacementCheck(String id) {
    Map<String, String> param = {
      'dwnidno': id,
      'idno': IDNO,
    };
    NetworkCalls().callServer(Constants.apiCheckPlacement, param).then((value) {
      var data = jsonDecode(value!.body);
      if (data['Message'].toString().toUpperCase() == Constants.success) {
        callServer(IDNO, id);
      } else {
        ibsCtrl.text = '';
        Logger.ShowErrorAlert('Error', data['Message'].toString());
      }
    });
  }

  /*void callpopServer(String id) {
    // print(id);
    Map<String, String> param = {"Idno": regid, "Pwd": id};
    NetworkCalls calls = NetworkCalls(context);
    calls.callServer(Constents.GraphicalPopup, param).then((value) {
      var data = json.decode(value.body);
      if (data['Msg'] == Constents.success) {
        _showOfferPopUp(data);
      } else {
        WarningAlertBox(
            context: context,
            title: 'Invalid IBA Name',
            messageText: data['Msg']);
      }
    });
  }*/

  void callCreateNodes() {
    graph = Graph();
    builder = BuchheimWalkerConfiguration();
    nodesList.clear();
    if (treelist.length == 1) {
      graph.addNode(Node(getNodeText(treelist[0])));
    } else {
      nodesList.addAll(treelist.map((e) => Node(getNodeText(e))));
      for (int j = 1; j < treelist.length; j++) {
        graph.addEdge(nodesList[0], nodesList[j]);
      }
    }
    setState(() {
      isLoad = false;
    });
    builder
      ..siblingSeparation = (30)
      ..levelSeparation = (60)
      ..subtreeSeparation = (40)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
  }

  void _showOfferPopUp(UnilevelTreeDetailsModel data) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                AlertDialog(
                  title: Text('User Details'),
                  content: Container(
                    alignment: Alignment.topCenter,
                    width: double.maxFinite,
                    child: Column(
                      children: <Widget>[
                        SubChildItem('Distributor IRD', data.UniLevelTreeViewDet![0]!.UserID!, false),
                        SubChildItem('Name', data.UniLevelTreeViewDet![0]!.Name!, false),
                        SubChildItem('User ID',  data.UniLevelTreeViewDet![0]!.UserIDNo!, false),
                        SubChildItem('User Type',  data.UniLevelTreeViewDet![0]!.mstatus!, false),
                        SubChildItem('Date',  data.UniLevelTreeViewDet![0]!.stsdate!, false),
                        SubChildItem('Sponsor ID',  data.UniLevelTreeViewDet![0]!.Sponsor!, false),
                        SubChildItem('Sponsor Name',  data.UniLevelTreeViewDet![0]!.sprname!, false),
                        SubChildItem('Direct Sponsor',  data.UniLevelTreeViewDet![0]!.Sprcount!, false),
                        SubChildItem('Team Count',  data.UniLevelTreeViewDet![0]!.DownCnt!, false),
                        SubChildItem('Self CC',  double.parse(data.UniLevelTreeViewDet![0]!.SelfBV!).toStringAsFixed(0), false),
                        SubChildItem('Team CC',  double.parse(data.UniLevelTreeViewDet![0]!.DownBV!).toStringAsFixed(0), false),
                        SubChildItem('Group CC',  (double.parse(data.UniLevelTreeViewDet![0]!.SelfBV!)+double.parse(data.UniLevelTreeViewDet![0]!.DownBV!)).toStringAsFixed(0), false),
                        const SizedBox(height: 10,),
                        const Divider(
                          thickness: 0.9,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Container(
                        padding: EdgeInsets.all(10),
                        child: RaisedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Close'),
                          color: Theme
                              .of(context)
                              .primaryColor,
                        ))
                  ],
                ),
                /*Positioned(
                  right: 10,
                  top: 10,
                  child: FloatingActionButton(
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80)),
                    backgroundColor: Colors.white,
                    mini: true,
                    elevation: 5.0,
                  ),
                ),*/
              ],
            ),
          );
        });
  }
}