import 'package:example/MapPage.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<dynamic> studies = [];
  List<dynamic> filteredStudies = [];
  Map<String, String> filters = {};
  Map<String, String> queryParameters = {};
  bool showFilters = false;

  List<String> overallStatusOptions = [
    'ACTIVE_NOT_RECRUITING',
    'COMPLETED',
    'ENROLLING_BY_INVITATION',
    'NOT_YET_RECRUITING',
    'RECRUITING',
    'SUSPENDED',
    'TERMINATED',
    'WITHDRAWN',
    'AVAILABLE',
    'NO_LONGER_AVAILABLE',
    'TEMPORARILY_NOT_AVAILABLE',
    'APPROVED_FOR_MARKETING',
    'WITHHELD',
    'UNKNOWN'
  ];

  List<String> selectedOverallStatus = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      print(queryParameters);
      final response = await Dio().get(
        'https://clinicaltrials.gov/api/v2/studies',
        queryParameters: queryParameters,
      );
      setState(() {
        studies = response.data['studies'] ?? [];
        filteredStudies = studies;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void filterStudies() {
    if (filters['queryCond'] != null && filters['queryCond']!.isNotEmpty) {
      queryParameters['query.cond'] = filters['queryCond']!;
    }
    if (filters['filterLocn'] != null && filters['filterLocn']!.isNotEmpty) {
      final locnRegex = RegExp(
          r'^distance\(-?\d+(\.\d+)?,-?\d+(\.\d+)?,\d+(\.\d+)?(km|mi)?\)$');
      bool regexBool = locnRegex.hasMatch(filters['filterLocn']!);
      if (!regexBool) {
        const snackBar =
            SnackBar(content: Text('Please Check Geo Locations Format'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      queryParameters['filter.geo'] = filters['filterLocn']!;
    }
    if (filters['queryTerm'] != null && filters['queryTerm']!.isNotEmpty) {
      queryParameters['query.term'] = filters['queryTerm']!;
    }
    if (filters['queryLocn'] != null && filters['queryLocn']!.isNotEmpty) {
      queryParameters['query.locn'] = filters['queryLocn']!;
    }
    if (filters['queryTitles'] != null && filters['queryTitles']!.isNotEmpty) {
      queryParameters['query.titles'] = filters['queryTitles']!;
    }
    if (filters['queryIntr'] != null && filters['queryIntr']!.isNotEmpty) {
      queryParameters['query.intr'] = filters['queryIntr']!;
    }
    if (filters['queryOutc'] != null && filters['queryOutc']!.isNotEmpty) {
      queryParameters['query.outc'] = filters['queryOutc']!;
    }
    if (filters['querySpons'] != null && filters['querySpons']!.isNotEmpty) {
      queryParameters['query.spons'] = filters['querySpons']!;
    }
    if (filters['queryLead'] != null && filters['queryLead']!.isNotEmpty) {
      queryParameters['query.lead'] = filters['queryLead']!;
    }
    if (filters['filterIds'] != null && filters['filterIds']!.isNotEmpty) {
      queryParameters['filter.ids'] = filters['filterIds']!;
    }
    if (filters['filterAdvanced'] != null &&
        filters['filterAdvanced']!.isNotEmpty) {
      queryParameters['filter.advanced'] = filters['filterAdvanced']!;
    }
    if (filters['filterSynonyms'] != null &&
        filters['filterSynonyms']!.isNotEmpty) {
      queryParameters['filter.synonyms'] = filters['filterSynonyms']!;
    }
    if (filters['agg.Filters'] != null && filters['agg.Filters']!.isNotEmpty) {
      queryParameters['aggFilters'] = filters['agg.Filters']!;
    }
    if (selectedOverallStatus.isNotEmpty) {
    queryParameters['filter.overallStatus'] = selectedOverallStatus.join(',');
    }
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;
    final filterFields = {
      'queryTerm': 'Term',
      'queryCond': 'Condition',
      'queryLocn': 'Location',
      'queryTitles': 'Title',
      'queryIntr': 'Intervention',
      'queryOutc': 'Outcome',
      'querySpons': 'Sponsor',
      'queryLead': 'Lead Researcher',
      'filterLocn': 'Geo Location',
      'filterIds': 'NCT Filters Id',
      'filterAdvanced': 'Filter Advanced',
      'filterSynonyms': 'Filter Synonyms',
      'agg.Filters': 'Agg Filters',
      'filteroverallStatus': 'Status',
    };

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Clinical Trials",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        actions: isMobile
            ? [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    setState(() {
                      showFilters = !showFilters;
                    });
                  },
                )
              ]
            : [],
      ),
      body: Row(
        children: [
          if (!isMobile)
            Container(
              width: 250,
              color: Colors.blueGrey[100],
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filters',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...filterFields.entries.map((entry) {
                    if (entry.key == 'filteroverallStatus') {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: MultiSelectDialogField(
                          items: overallStatusOptions
                              .map((status) =>
                                  MultiSelectItem<String>(status, status))
                              .toList(),
                          title: const Text("Select Status"),
                          selectedColor: Colors.blue,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              color: Colors.blue,
                              width: 1,
                            ),
                          ),
                          buttonIcon: const Icon(
                            Icons.filter_list,
                            color: Colors.blue,
                          ),
                          buttonText: const Text(
                            "Select Status",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                            ),
                          ),
                          onConfirm: (results) {
                            setState(() {
                              selectedOverallStatus = results.cast<String>();
                              filters['filteroverallStatus'] =
                                  selectedOverallStatus.join(',');
                            });
                          },
                          chipDisplay: MultiSelectChipDisplay(
                            chipColor: Colors.blue.withOpacity(0.5),
                            textStyle: const TextStyle(color: Colors.white),
                            onTap: (value) {
                              setState(() {
                                selectedOverallStatus.remove(value);
                                filters['filteroverallStatus'] =
                                    selectedOverallStatus.join(',');
                              });
                            },
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: entry.value,
                            border: const OutlineInputBorder(),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          onChanged: (value) {
                            filters[entry.key] = value;
                          },
                        ),
                      );
                    }
                  }).toList(),
                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: filterStudies,
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Column(
              children: [
                if (isMobile && showFilters)
                  Container(
                    width: double.infinity,
                    color: Colors.blueGrey[100],
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Filters',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: filterFields.entries.map((entry) {
                            if (entry.key == 'filteroverallStatus') {
                              return MultiSelectDialogField(
                                items: overallStatusOptions
                                    .map((status) =>
                                        MultiSelectItem<String>(status, status))
                                    .toList(),
                                title: const Text("Select Status"),
                                selectedColor: Colors.blue,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                buttonIcon: const Icon(
                                  Icons.filter_list,
                                  color: Colors.blue,
                                ),
                                buttonText: const Text(
                                  "Select Status",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                  ),
                                ),
                                onConfirm: (results) {
                                  setState(() {
                                    selectedOverallStatus = results;
                                    filters['filteroverallStatus'] =
                                        selectedOverallStatus.join(',');
                                  });
                                },
                              );
                            } else {
                              return SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: entry.value,
                                    border: const OutlineInputBorder(),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                  onChanged: (value) {
                                    filters[entry.key] = value;
                                  },
                                ),
                              );
                            }
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            onPressed: filterStudies,
                            child: const Text('Apply Filters'),
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredStudies = studies
                            .where((study) => study
                                .toString()
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 2,
                            blurRadius: 5),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Scrollbar(
                        thumbVisibility: true,
                        thickness: 8,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              columnSpacing: 10,
                              columns: const [
                                DataColumn(
                                    label: Text('NCT ID',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Study Title',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Organization',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Status',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Start Date',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Completion Date',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Lead Sponsor',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Location',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ],
                              rows: filteredStudies.map((study) {
                                final id = study['protocolSection']
                                        ['identificationModule']['nctId'] ??
                                    'N/A';
                                final title = study['protocolSection']
                                            ['identificationModule']
                                        ['briefTitle'] ??
                                    'Unknown';
                                final org = study['protocolSection']
                                            ['identificationModule']
                                        ['organization']['fullName'] ??
                                    'Unknown';
                                final status = study['protocolSection']
                                        ['statusModule']['overallStatus'] ??
                                    'Unknown';
                                final startDate = study['protocolSection']
                                            ['statusModule']['startDateStruct']
                                        ?['date'] ??
                                    'Unknown';
                                final completionDate = study['protocolSection']
                                            ['statusModule']
                                        ['completionDateStruct']?['date'] ??
                                    'Unknown';
                                final sponsor = study['protocolSection']
                                            ['sponsorCollaboratorsModule']
                                        ['leadSponsor']?['name'] ??
                                    'Unknown';
                                final locations = study['protocolSection']
                                            ?['contactsLocationsModule']
                                        ?['locations'] ??
                                    [];
                                final location = locations.isNotEmpty
                                    ? '${locations[0]['city']}, ${locations[0]['country']}'
                                    : 'Unknown';
                                return DataRow(cells: [
                                  DataCell(Text(id)),
                                  DataCell(Text(title)),
                                  DataCell(Text(org)),
                                  DataCell(Text(status)),
                                  DataCell(Text(startDate)),
                                  DataCell(Text(completionDate)),
                                  DataCell(Text(sponsor)),
                                  DataCell(Text(location)),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
