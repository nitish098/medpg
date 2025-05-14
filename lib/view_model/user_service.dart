// import 'dart:convert';

// import 'package:http/http.dart' as http;

// import '../presentation/models/login_api.dart';

// class   UserService {
//   Future<List<UserClass>> userService(String credential, String password) async {
//     const url = "https://themedico.app/api/auth/login";

//     final response = await http.post(
//       Uri.parse(url),
//       headers:  {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'credential': credential,
//         'password': password,
//       })
//     );
//     if(response.statusCode == 200){
//       final userDecoded = jsonDecode(response.body) ;
//       final userDecodedData = userDecoded["user"] as List;
//       final userData = userDecodedData.map((e) => UserClass.fromJson(e)).toList();
//       return userData;
//     }
//   throw "Exception";
  
//   }
  
// }
