import 'package:clinical_trails_client/clinical_trails_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () async {
    final result = await GetApiVersionRequest().send();
    expect(result.isNotEmpty, true);
  });
}
