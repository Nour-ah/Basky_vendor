import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('spider-vendor.postman_collection.json');
  if (!file.existsSync()) {
    print('Postman file not found');
    return;
  }
  final content = file.readAsStringSync();
  final data = jsonDecode(content);
  final items = data['item'] as List;

  void processItems(List list, [String parent = '']) {
    for (final item in list) {
      final name = parent.isNotEmpty ? '$parent > ${item['name']}' : item['name'];
      if (item.containsKey('item')) {
        processItems(item['item'] as List, name);
      } else {
        final req = item['request'] ?? {};
        final method = req['method'] ?? 'GET';
        final urlRaw = (req['url'] is Map) ? (req['url']['raw'] ?? '') : (req['url'] ?? '');
        print('[$method] $urlRaw ($name)');
      }
    }
  }

  processItems(items);
}
