import 'package:intl/intl.dart';

class Requester {
  List unsupported;
  String version;
  Requester({this.unsupported, this.version});

  Map prepare({String method, parameters = const [], String suffix}) {
    var methodName = method.toLowerCase();
    if (version != null && unsupported.contains(methodName)) {
      throw Exception(
          'Method "${method}" is not supported by version "${version}"');
    }
    return {
      'id': '${DateTime.now()}  ${(suffix ?? '')}',
      methodName: methodName,
      'params': parameters,
    };
  }
}
