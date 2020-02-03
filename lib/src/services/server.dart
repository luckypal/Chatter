
import 'dart:convert';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:chatter/config/app_config.dart' as config;

abstract class ServerService {
  Future<Map<String, dynamic>> uploadProfileImage(String phoneNumber, String name, File image);
}

class ServerServiceImpl extends ServerService {

  @override
  Future<Map<String, dynamic>> uploadProfileImage(String phoneNumber, String userName, File image) {
    return new Future(() async {
      try {
        String url = config.Server.SERVER_URL + "/uploadProfileImage";

        final httpRequest = http.MultipartRequest('POST', Uri.parse(url));
        httpRequest.fields ["phoneNumber"] = phoneNumber;
        httpRequest.fields ["userName"] = userName;

        if (image != null) {
          final mimeTypeData = lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');

          final httpFile = await http.MultipartFile.fromPath('image', image.path,
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
          httpRequest.fields['ext'] = mimeTypeData[1];
          httpRequest.files.add(httpFile);
        }
      
        final streamedResponse = await httpRequest.send();
        final response = await http.Response.fromStream(streamedResponse);
        if (response.statusCode != 200) {
          return null;
        }
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } catch (e) {
        print(e);
        return null;
      }
    });
  }
}