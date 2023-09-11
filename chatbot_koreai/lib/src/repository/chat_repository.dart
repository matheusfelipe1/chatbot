import 'package:chatbot_koreai/src/model/chat_model.dart';
// ignore: implementation_imports
import 'package:file_picker/src/file_picker_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../datasource/datasource.dart';
import 'ichat_repository.dart';

class ChatRepository implements IChatRepository {
  late DataSource dataSource;
  ChatRepository(String botId, String clientId, String clientSecret,
      String userId, String assertion, String chatBot, Map userInfo, int? limit) {
    dataSource = DataSource(
        botId, clientId, clientSecret, userId, assertion, chatBot, userInfo, limit);
  }
  @override
  Future<List<ChatModel>> sendMessage({
    String? type,
    String? value,
    String? fileName,
    String? fileType,
    String? fileId,
  }) async {
    final List<ChatModel> datas = [];
    if (type != null && value != null) {
      try {
        // final data = mock();
        final data = await dataSource.post(type, value);
        if (data['data'] is List) {
          for (var element in data['data']) {
            final item = element as Map<String, dynamic>;
            final ChatModel model = ChatModel.fromJson(item);
            datas.add(model);
          }
        }
        return datas;
      } catch (e) {
        debugPrint(e.toString());
        return [];
      }
    } else if (fileName != null && fileType != null && fileId != null) {
      try {
        final data = await dataSource.post(
          type!,
          value!,
          fileName: fileName,
          fileType: fileType,
          fileId: fileId,
        );
        if (data['data'] is List) {
          for (var element in data['data']) {
            final item = element as Map<String, dynamic>;
            final ChatModel model = ChatModel.fromJson(item);
            datas.add(model);
          }
        }
        return datas;
      } catch (e) {
        debugPrint(e.toString());
        return [];
      }
    } else {
      return [];
    }
  }

  @override
  Future<List<ChatModel>> getHistoryMessage() async {
    final List<ChatModel> datas = [];
    try {
      final data = await dataSource.get();
      if (data['messages'] is List) {
        for (var element in data['messages']) {
          for (var i = 0; i < element['components'].length; i++) {
            final item = element['components'][i] as Map<String, dynamic>;
            item['createdOn'] = element['createdOn'];
            item['messageId'] = item['_id'];
            item['type'] = item['cT'];
            item['val'] = item['data']['text'];
            if (element['type'] == 'incoming') {
              item['fromMe'] = true;
            } else {
              item['fromMe'] = false;
            }
            final ChatModel model = ChatModel.fromJson(item);
            datas.add(model);
          }
        }
      }
      return datas;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Future<String?> getFileToken() async {
    try {
      final token = await dataSource.getFileToken();
      return token;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future sendImage(String fileToken, PickedFile file) async {
    try {
      final data = await dataSource.sendImage(fileToken, file);
      return data;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future sendAnyFile(String fileToken, FilePickerResult file) async {
    try {
      final data = await dataSource.sendAnyFile(fileToken, file);
      if (data == null) throw ErrorDescription("Não foi possível enviar o arquivo.");
      return data;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Map mock() {
    return {"data": [{"type": "image", "val": {"text": '''
Este é um exemplo de Markdown que inclui um link, uma imagem, texto decorativo e um parágrafo com um tamanho de fonte maior.

Link:
- [Google](https://www.google.com)
Imagem:
![Gato Fofo](https://static.poder360.com.br/2020/10/gato-animal-covid-19-scaled.jpg)

Texto Decorativo:

* Oláaa Este é um exemplo de **texto em negrito** e _texto em itálico_. 

Enumerable:
 - 1. teste;
 - 2. Teste;

a) teste1
b) teste2
d) teste4
'''
       , 'isTemplate': true}, 'createdOn': '2023-09-06T14:59:03.028Z', 'messageId': 'ms-3389d4b5-e127-5d47-ab31-ff2f0cac4d87'}], '_v': 'v2', 'sessionId': '64f3416d351929b6bfaea73a', 'traversedIntents': ['Fallback Task'], 'agentAssistDetailsArr': []};
  }
}
