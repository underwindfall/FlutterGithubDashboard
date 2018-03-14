import 'dart:async';

import 'package:http/http.dart';

abstract class AuthClient extends BaseClient {
  final Client _client;
  final String _authorization;

  AuthClient(this._client, this._authorization);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    request.headers['Authorization'] = _authorization;
    return _client.send(request);
  }
}