import 'dart:convert';
import 'dart:math';

import 'package:clinical_trails_client/clinical_trails_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:json_to_form/json_schema.dart';

class AllFields extends StatefulWidget {
  AllFields({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _AllFields createState() => _AllFields();
}

class _AllFields extends State<AllFields> {
  TreeViewController? _treeViewController;
  bool allowParentSelection = true;
  void initState() {
    super.initState();
  }

  String form = json.encode({
    'title': 'Search',
    'description': 'Fill the neccessary fields',
    'fields': [
      {'key': 'queryTerm', 'type': 'Input', 'label': 'queryTerm', 'palceHolder': 'queryTerm'},
      // {'key': 'queryPhrase', 'type': 'Input', 'label': 'queryPhrase', 'palceHolder': 'queryPhrase'},
      {'key': 'queryCond', 'type': 'Input', 'label': 'queryCond', 'palceHolder': 'queryCond'},
      {'key':'queryLocn', 'type':'Input', 'label':'queryLocn', 'palceHolder':'queryLocn' },
      {'key': 'queryTitles', 'type': 'Input', 'label': 'queryTitles', 'palceHolder': 'queryTitles'},
      {'key': 'queryIntr', 'type': 'Input', 'label': 'queryIntr', 'palceHolder': 'queryIntr'},
      {'key': 'queryOutc', 'type': 'Input', 'label': 'queryOutc', 'palceHolder': 'queryOutc'},
      {'key': 'querySpons', 'type': 'Input', 'label': 'querySpons', 'palceHolder': 'querySpons'},
      {'key': 'queryLead', 'type': 'Input', 'label': 'queryLead', 'palceHolder': 'queryLead'},
      {'key': 'queryId', 'type': 'Input', 'label': 'queryId', 'palceHolder': 'queryId'},
      {'key': 'queryPatient', 'type': 'Input', 'label': 'queryPatient', 'palceHolder': 'queryPatient'},
      // {'key': 'filterGeo', 'type': 'Input', 'label': 'filterGeo', 'palceHolder': 'filterGeo'},
      {'key': 'filterAdvanced', 'type': 'Input', 'label': 'filterAdvanced', 'palceHolder': 'filterAdvanced'},
      // {'key': 'postFilterGeo', 'type': 'Input', 'label': 'postFilterGeo', 'palceHolder': 'postFilterGeo'},
      {'key': 'postFilterAdvanced', 'type': 'Input', 'label': 'postFilterAdvanced', 'palceHolder': 'postFilterAdvanced'},
      // {'key': 'aggFilters', 'type': 'Input', 'label': 'aggFilters', 'palceHolder': 'aggFilters'},
      // {'key': 'geoDecay', 'type': 'Input', 'label': 'geoDecay', 'palceHolder': 'geoDecay'},
      // {'key': 'pageToken', 'type': 'Input', 'label': 'pageToken', 'palceHolder': 'pageToken'},
    ]
  });
  Map<String, dynamic> formInput = {};
  Map<String, dynamic> response = {};

  List<Node> _buildTree(dynamic data, {String? parentKey, List<String> indexList = const ['root']}) {
    List<Node> nodes = [];

    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

    if (data.runtimeType.toString().startsWith('List')) {
      (data as List<dynamic>).asMap().forEach((key, value) {
        final List<String> keys = [...indexList, key.toString()];
        String? label;
        if (value is Map<String, dynamic>) {
          label = value['protocolSection']?['identificationModule']?['nctId'];
        }
        label ??= key.toString();
        nodes.add(Node(key: keys.join('.'), label: label, children: _buildTree(value, parentKey: keys.join('.'), indexList: keys)));
      });
    } else if (data.runtimeType.toString().startsWith('Map') || data.runtimeType.toString() == '_JsonMap') {
      int index = 0;
      (data as Map).forEach((key, value) {
        final List<String> keys = [...indexList, '${index++}.${key.toString()}'];
        nodes.add(Node(key: keys.join('.'), label: key.toString(), children: _buildTree(value, parentKey: keys.join('.'), indexList: keys)));
      });
    } else {
      Random rnd = Random();
      final newKey = String.fromCharCodes(Iterable.generate(32, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
      final List<String> keys = [...indexList, newKey];
      nodes.add(Node(key: keys.join('.'), label: "$data"));
    }

    return nodes;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("All Fields"),
      ),
      body: SingleChildScrollView(
        child: Container(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Flex(direction: Axis.horizontal, 
          crossAxisAlignment:CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  JsonSchema(
                    form: form,
                    onChanged: (response) {
                      formInput = response;
                    },
                    actionSave: (data) async {
                      final fields=(formInput['fields'] as List<dynamic>?)?.map((e) => MapEntry(e['key'], e['value'])).where((e)=>e.value != null);
                      final inputs={};
                      if(fields != null){
                        inputs.addEntries(fields);
                      }
                      // print(inputs);
                      response = await GetStudiesRequest(
                        queryTerm: inputs['queryTerm'],
                        // queryPhrase: inputs['queryPhrase'],
                        queryCond: inputs['queryCond'],
                        // queryLocn:inputs['queryLocn'],
                        queryLocn: 'Turkiye,Turkey',
                        queryTitles: inputs['queryTitles'],
                        queryIntr: inputs['queryIntr'],
                        queryOutc: inputs['queryOutc'],
                        querySpons: inputs['querySpons'],
                        queryLead: inputs['queryLead'],
                        queryId: inputs['queryId'],
                        queryPatient: inputs['queryPatient'],
                        // filterGeo: inputs['filterGeo'],
                        filterAdvanced: inputs['filterAdvanced'],
                        // postFilterGeo: inputs['postFilterGeo'],
                        postFilterAdvanced: inputs['postFilterAdvanced'],
                        // // aggFilters: inputs['aggFilters'],
                        // // geoDecay: inputs['geoDecay'],
                        // // pageToken: inputs['pageToken'],
                        // filterOverallS:inputs['filterOverallS'] != null ? StudyStatus.values.firstWhere((e)=>e.name == inputs['filterOverallS']) : null,
                        // postFilterOver:inputs['postFilterOver'] != null ? StudyStatus.values.firstWhere((e)=>e.name == inputs['postFilterOver']) : null,
                        countTotal: true,
                        pageSize: 20,
                      ).send();
                      // print(response['totalCount']);
                      setState(() {
                        _treeViewController = TreeViewController(children: _buildTree(response['studies']));
                      });
                    },
                    autovalidateMode: AutovalidateMode.always,
                    buttonSave: Container(
                      height: 40.0,
                      color: Colors.blueAccent,
                      child: const Center(
                        child: Text("Send", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    if (response.isNotEmpty) ...[
                      Text('total: ${response['totalCount']} / ${response['studies'].length}'),
                      Container(
                                            child: TreeView(
                      shrinkWrap: true,
                      controller: _treeViewController!,
                      allowParentSelect: allowParentSelection,
                      onNodeTap: (key) {
                        setState(() {
                          Node? node = _treeViewController!.getNode(key);
                          if (node != null) {
                            _treeViewController = _treeViewController!.copyWith(
                              children: _treeViewController!.updateNode(
                                key,
                                node.copyWith(expanded: !node.expanded),
                              ),
                            );
                          }
                        });
                      },
                                            ),
                                          )
                    ]
                    // })
                  ],
                ),
              ),
            )

            //
            // ...(response['studies'] as List<dynamic>).map((e){
          ]),
        ),
      ),
    );
  }
}
