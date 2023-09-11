import 'dart:developer';

import 'package:chatbot_koreai/src/services/dio_services.dart';
import 'package:chatbot_koreai/src/shared/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../viewModel/progress_files.dart';

class DataSource {
  late String botId;
  late String userId;
  late String clientId;
  late CustomHttp http;
  late String assertion;
  late String chatBot;
  late Map userInfo;
  late String _bearerToken;
  late int? limit;


  DataSource(this.botId, this.clientId, String clientSecret, this.userId,
      this.assertion, this.chatBot, this.userInfo, this.limit) {
    http = CustomHttp(clientId, clientSecret);
  }

  post(
    String type,
    String value, {
    String? fileName,
    String? fileType,
    String? fileId,
  }) async {
    final jsonImage = {
      "message": {
        "type": type,
        "val": value,
      },
      "body": "",
      "attachments": [
        {"fileName": fileName, "fileType": fileType, "fileId": fileId}
      ],
      "from": {"id": userId, "userInfo": userInfo}
    };

    final json = {
      "message": {
        "type": type,
        "val": value,
      },
      "from": {"id": userId, "userInfo": userInfo}
    };

    bodyDataJson() {
      if (fileName != null) {
        print(jsonImage);
        return jsonImage;
      } else {
        print(json);
        return json;
      }
    }

    if (fileName != null) {}
    final response =
        await http.client.post(Endpoints.chat + botId, data: bodyDataJson());
    return response.data;
  }

  _getBearerToken() async {
    final json = {
      "assertion": assertion,
      "botInfo": {
        "chatBot": chatBot,
        "taskBotId": botId,
        "customData": {"rtmType": "web"}
      },
      "token": {}
    };
    final response = await http.client.post(Endpoints.bearerToken, data: json);

    return response.data['authorization']['accessToken'];
  }

  get() async {
    _bearerToken = await _getBearerToken();
    final response = await Dio().get(
      '${Endpoints.history}$botId&limit=${limit ?? 30}',
      options: Options(
        headers: {
          'Authorization': 'Bearer $_bearerToken',
        },
      ),
    );
    return response.data;
  }

  getFileToken() async {
    try {
      final response = await Dio().post(
        Endpoints.fileToken,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_bearerToken',
          },
        ),
      );
      return response.data['fileToken'];
    } on Exception catch (e) {
      log(e.toString());
      _bearerToken = await _getBearerToken();
      getFileToken();
    }
  }

  sendImage(String fileToken, PickedFile file) async {
    try {
      final dio = Dio();
      final formData = FormData.fromMap(
        {
          'file': await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
          'fileExtension': file.path.split('.').last,
          'fileContext': 'workflows',
        },
      );
      final options = Options(headers: {
        'Cookie': 'filetoken=$fileToken',
        'Authorization': 'Bearer $_bearerToken',
        'Content-Type':
            'multipart/form-data; boundary=<calculated when request is sent>',
      });
      final response = await dio.post(
        Endpoints.file,
        data: formData,
        options: options,
        onReceiveProgress: (count, total) async {
          await Future.delayed(const Duration(milliseconds: 300));
          ProgressFiles.value.value = 0.0;
        },
        onSendProgress: (count, total) async {
          await Future.delayed(const Duration(milliseconds: 300));
          double progress = count / total;
          ProgressFiles.value.value = progress;
        }
      );
      return response.data;
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      log('Aqui no dioerror');
      log(e.message.toString());
      log(e.response!.data.toString());
      log(e.response!.headers.toString());
    }
  }

  sendAnyFile(String fileToken, FilePickerResult file) async {
    try {
      final dio = Dio();
      final formData = FormData.fromMap(
        {
          'file': await MultipartFile.fromFile(
            file.paths.first!,
            filename: file.files.first.name,
          ),
          'fileExtension': file.files.first.extension,
          'fileContext': 'workflows',
        },
      );
      final options = Options(headers: {
        'Cookie': 'filetoken=$fileToken',
        'Authorization': 'Bearer $_bearerToken',
        'Content-Type':
            'multipart/form-data; boundary=<calculated when request is sent>',
      });
      final response = await dio.post(
        Endpoints.file,
        data: formData,
        options: options,
      );

      return response.data;
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      log(e.message.toString());
      log(e.response!.data.toString());
      log(e.response!.headers.toString());
    }
  }
}
