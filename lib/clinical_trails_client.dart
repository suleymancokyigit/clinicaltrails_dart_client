library clinical_trails_client;

// ignore_for_file: constant_identifier_names

import 'package:dart_rss/dart_rss.dart';
import 'package:dio/dio.dart';

class _ApiClient {
  final Dio _dio;
  final String baseUrl;

  _ApiClient({Dio? dio, required this.baseUrl}) : _dio = dio ?? Dio();

  Future<Response> getRequest(String endpoint, {Map<String, dynamic>? queryParams}) async {
    print(queryParams);
    try {
      final response = await _dio.get('$baseUrl$endpoint', queryParameters: queryParams);
      return response;
    } catch (e) {
      throw Exception('Failed to perform GET request: $e');
    }
  }

  Future<Response> postRequest(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post('$baseUrl$endpoint', data: data);
      return response;
    } catch (e) {
      throw Exception('Failed to perform POST request: $e');
    }
  }

  Future<Response> putRequest(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put('$baseUrl$endpoint', data: data);
      return response;
    } catch (e) {
      throw Exception('Failed to perform PUT request: $e');
    }
  }

  Future<Response> deleteRequest(String endpoint, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.delete('$baseUrl$endpoint', queryParameters: queryParams);
      return response;
    } catch (e) {
      throw Exception('Failed to perform DELETE request: $e');
    }
  }
}

/// Model for GET RSS Feed Request
class GetRssStudiesRequest extends _ApiClient {
  String? country;
  String? dateField;
  String? cond;
  String? term;
  String? intr;
  String? locStr;
  String? start;
  String? primComp;
  String? ageRange;
  String? aggFilters;
  GetRssStudiesRequest({
    super.dio,
    super.baseUrl = 'https://clinicaltrials.gov/api/rss',
    this.country,
    this.dateField,
    this.cond,
    this.term,
    this.intr,
    this.locStr,
    this.start,
    this.primComp,
    this.ageRange,
    this.aggFilters,
  });
  Future<RssFeed> send() async {
    final queryParams = {
      if (country != null) 'country': country,
      if (dateField != null) 'dateField': dateField,
      if (cond != null) 'cond': cond,
      if (term != null) 'term': term,
      if (intr != null) 'intr': intr,
      if (locStr != null) 'locStr': locStr,
      if (start != null) 'start': start,
      if (primComp != null) 'primComp': primComp,
      if (ageRange != null) 'ageRange': ageRange,
      if (aggFilters != null) 'aggFilters': aggFilters,
    };
    final response = await getRequest('', queryParams: queryParams);
    return RssFeed.parse(response.data.toString());
  }
}

/// Model for GET /studies request parameters
class GetStudiesRequest extends _ApiClient {
  /// Response format (e.g., csv, json)
  final Format format;

  /// Markup format for response (e.g., markdown, legacy)
  final MarkupFormat markupFormat;

  /// Search term to filter studies (affects ranking if sorted by relevance)
  // final String? queryCont;

  final String? queryTerm;

  /// Search phrase to match exact study descriptions
  // final String? queryPhrase;

  /// Search by study condition
  final String? queryCond;

  /// Search by study location
  final String? queryLocn;

  /// Search by study title
  final String? queryTitles;

  /// Search by intervention
  final String? queryIntr;

  /// Search by outcomes
  final String? queryOutc;

  /// Search by sponsor
  final String? querySpons;

  /// Search by lead investigator
  final String? queryLead;

  /// Search by study ID
  final String? queryId;

  /// Search by patient-related criteria
  final String? queryPatient;

  /// Filter studies by status (multiple allowed)
  final List<StudyStatus>? filterOverallS;

  /// Filter studies by geographic location
  final String? filterGeo;

  /// Filter studies by list of study IDs
  final List<String>? filterIds;

  /// Advanced filtering options
  final String? filterAdvanced;

  /// Use synonyms in filtering
  final List<String>? filterSynonyms;

  /// Post-filtering by status (multiple allowed)
  final List<StudyStatus>? postFilterOver;

  /// Post-filtering by geographic location
  final String? postFilterGeo;

  /// Post-filtering by list of study IDs
  final List<String>? postFilterIds;

  /// Post-filtering advanced options
  final String? postFilterAdvanced;

  /// Use synonyms in post-filtering
  final List<String>? postFilterSynonyms;

  /// Aggregate filtering options
  final String? aggFilters; // studytype:int

  /// Geo decay parameter
  final String? geoDecay;

  /// Fields to return in response
  final List<String>? fields;

  /// Sorting parameter (max 2 items)
  final List<String>? sort;

  /// Whether to count the total number of matching studies
  final bool countTotal;

  /// Number of studies per page (limits data returned per request)
  final int pageSize;

  /// Token for paginating through results (use `nextPageToken` from response)
  final String? pageToken;

  GetStudiesRequest({
    super.dio,
    super.baseUrl = 'https://clinicaltrials.gov/api/v2',
    this.format = Format.json,
    this.markupFormat = MarkupFormat.markdown,
    this.queryTerm,
    // this.queryPhrase,
    this.queryCond,
    this.queryLocn,
    this.queryTitles,
    this.queryIntr,
    this.queryOutc,
    this.querySpons,
    this.queryLead,
    this.queryId,
    this.queryPatient,
    this.filterOverallS,
    this.filterGeo,
    this.filterIds,
    this.filterAdvanced,
    this.filterSynonyms,
    this.postFilterOver,
    this.postFilterGeo,
    this.postFilterIds,
    this.postFilterAdvanced,
    this.postFilterSynonyms,
    this.aggFilters,
    this.geoDecay,
    this.fields,
    this.sort,
    this.countTotal = true,
    this.pageSize = 20,
    this.pageToken,
  });

  /// Fetch studies matching the given query and filter parameters
  Future<Map<String, dynamic>> send() async {
    final queryParams = {
      'format': format.name,
      'markupFormat': markupFormat.name,
      if (queryTerm != null) 'query.term': queryTerm,
      // if (queryPhrase != null) 'query.phrase': queryPhrase,
      if (queryCond != null) 'query.cond': queryCond,
      if (queryLocn != null) 'query.locn': queryLocn,
      if (queryTitles != null) 'query.titles': queryTitles,
      if (queryIntr != null) 'query.intr': queryIntr,
      if (queryOutc != null) 'query.outc': queryOutc,
      if (querySpons != null) 'query.spons': querySpons,
      if (queryLead != null) 'query.lead': queryLead,
      if (queryId != null) 'query.id': queryId,
      if (queryPatient != null) 'query.patient': queryPatient,
      if (filterOverallS != null) 'filter.overallS': filterOverallS?.join(','),
      if (filterGeo != null) 'filter.geo': filterGeo,
      if (filterIds != null) 'filter.ids': filterIds?.join(','),
      if (filterAdvanced != null) 'filter.advanced': filterAdvanced,
      if (filterSynonyms != null) 'filter.synonyms': filterSynonyms?.join(','),
      if (postFilterOver != null) 'postFilter.over': postFilterOver?.join(','),
      if (postFilterGeo != null) 'postFilter.geo': postFilterGeo,
      if (postFilterIds != null) 'postFilter.ids': postFilterIds?.join(','),
      if (postFilterAdvanced != null) 'postFilter.advanced': postFilterAdvanced,
      if (postFilterSynonyms != null) 'postFilter.synonyms': postFilterSynonyms?.join(','),
      if (aggFilters != null) 'aggFilters': aggFilters,
      if (geoDecay != null) 'geoDecay': geoDecay,
      if (fields != null) 'fields': fields?.join(','),
      if (sort != null) 'sort': sort?.join(','),
      if (pageToken != null) 'pageToken': pageToken,
      'countTotal': countTotal,
      'pageSize': pageSize,
    };

    final response = await getRequest('/studies', queryParams: queryParams);
    return response.data;
  }
}

/// Enumeration for response format
enum Format { csv, json }

enum ResponseFormat { xml, json }

/// Enumeration for markup format
enum MarkupFormat { markdown, legacy }

/// Enumeration for study statuses
enum StudyStatus {
  ACTIVE_NOT_RECRUITING,
  COMPLETED,
  ENROLLING_BY_INVITATION, //frontendde gosterecegiz
  NOT_YET_RECRUITING, //frontendde gosterecegiz
  RECRUITING, //frontendde gosterecegiz
  SUSPENDED,
  TERMINATED,
  WITHDRAWN,
  AVAILABLE,
  NO_LONGER_AVAILABLE,
  TEMPORARILY_NOT_AVAILABLE,
  APPROVED_FOR_MARKETING,
  WITHHELD,
  UNKNOWN
}

/// Model for GET /studies/{nctId} request
class GetSingleStudyRequest extends _ApiClient {
  /// The NCT ID of the study to retrieve
  final String nctId;

  GetSingleStudyRequest({
    super.dio,
    super.baseUrl = 'https://clinicaltrials.gov/api/v2',
    required this.nctId, // Required NCT ID
  });

  /// Fetch a single study by its NCT ID
  Future<Map<String, dynamic>> send() async {
    final response = await getRequest('/studies/$nctId');
    return response.data;
  }
}

/// Model for GET /studies/metadata request
class GetStudyMetadataRequest extends _ApiClient {
  GetStudyMetadataRequest({
    super.dio,
    super.baseUrl = 'https://clinicaltrials.gov/api/v2',
  });

  /// Fetch metadata fields of study data model
  ///
  /// This endpoint returns a list of available fields in the study data model.
  Future<Map<String, dynamic>> send() async {
    final response = await getRequest('/studies/metadata');
    return response.data;
  }
}

/// Model for GET /studies/search-areas request
class GetStudySearchAreasRequest extends _ApiClient {
  GetStudySearchAreasRequest({
    super.dio,
    super.baseUrl = 'https://clinicaltrials.gov/api/v2',
  });

  /// Fetch available search areas for studies
  ///
  /// This endpoint retrieves search documents and their respective search areas.
  Future<Map<String, dynamic>> send() async {
    final response = await getRequest('/studies/search-areas');
    return response.data;
  }
}

/// Model for GET /studies/enums request
class GetStudyEnumsRequest extends _ApiClient {
  GetStudyEnumsRequest({
    super.dio,
    super.baseUrl = 'https://clinicaltrials.gov/api/v2',
  });

  /// Fetch enumeration types and their values
  ///
  /// Each item in the response represents an enum type containing:
  /// - `type`: The name of the enum type.
  /// - `pieces`: An array of data pieces associated with the enum type.
  /// - `values`: Available values for the enum, each containing:
  ///   - `value`: The data value.
  ///   - `legacyValue`: The corresponding value in the legacy API.
  ///   - `exceptions`: Special enum values for specific data pieces.
  Future<Map<String, dynamic>> send() async {
    final response = await getRequest('/studies/enums');
    return response.data;
  }
}

/// Model for GET /stats/size request
class GetStudySizeStatsRequest extends _ApiClient {
  GetStudySizeStatsRequest({
    super.dio,
    super.baseUrl = 'https://clinicaltrials.gov/api/v2',
  });

  /// Fetch statistics of study JSON sizes
  ///
  /// This endpoint provides statistics on the sizes of study JSON responses.
  Future<Map<String, dynamic>> send() async {
    final response = await getRequest('/stats/size');
    return response.data;
  }
}

/// Model for GET /stats/field/values request
class GetStudyFieldValuesStatsRequest extends _ApiClient {
  GetStudyFieldValuesStatsRequest({
    super.dio,
    super.baseUrl = 'https://clinicaltrials.gov/api/v2',
  });

  /// Fetch value statistics of the study leaf fields
  ///
  /// This endpoint provides statistical data about values stored in study fields.
  Future<Map<String, dynamic>> send() async {
    final response = await getRequest('/stats/field/values');
    return response.data;
  }
}

/// Model for GET /stats/field/sizes request
class GetStudyFieldSizesStatsRequest extends _ApiClient {
  GetStudyFieldSizesStatsRequest({
    super.dio,
    super.baseUrl = 'https://clinicaltrials.gov/api/v2',
  });

  /// Fetch statistics for field sizes in study data
  ///
  /// This endpoint provides statistical data on the sizes of various study fields.
  Future<Map<String, dynamic>> send() async {
    final response = await getRequest('/stats/field/sizes');
    return response.data;
  }
}

/// Model for GET /version request
class GetApiVersionRequest extends _ApiClient {
  GetApiVersionRequest({
    super.dio,
    super.baseUrl = 'https://clinicaltrials.gov/api/v2',
  });

  /// Fetch the current API version
  ///
  /// This endpoint retrieves the version details of the Clinical Trials API.
  Future<Map<String, dynamic>> send() async {
    final response = await getRequest('/version');
    return response.data;
  }
}
