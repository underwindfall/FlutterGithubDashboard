import 'package:githubdashboard/github/api/client/AuthClient.dart';
import 'package:http/http.dart';


class OauthClient extends AuthClient {
  OauthClient(Client client, String token) : super(client, 'token $token');

}