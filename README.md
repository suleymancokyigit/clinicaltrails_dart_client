# Clinical Trials API Client

A Dart API client for accessing the ClinicalTrials.gov API. This package provides easy-to-use models and requests to interact with clinical trials data.

## Features
- Fetch study details by NCT ID
- Search for studies using complex filters and queries
- Retrieve study metadata, enums, and statistics
- Supports pagination and sorting
- Fetch RSS feeds for new clinical trials

## Installation
Add this to your `pubspec.yaml`:

```yaml
dependencies:
  dio: ^5.0.0
  dart_rss: ^3.0.0
```

Then run:

```sh
dart pub get
```

## Usage

### Initialize API Client
```dart
final apiClient = ApiClient(baseUrl: 'https://clinicaltrials.gov/api/v2');
```

### Fetch a Single Study
```dart
final studyRequest = GetSingleStudyRequest(nctId: 'NCT00000102');
final study = await studyRequest.send();
print(study);
```

### Search for Studies
```dart
final studiesRequest = GetStudiesRequest(queryTerm: 'cancer', pageSize: 10);
final studies = await studiesRequest.send();
print(studies);
```

### Fetch Study Metadata
```dart
final metadataRequest = GetStudyMetadataRequest();
final metadata = await metadataRequest.send();
print(metadata);
```

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
