import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../model/chat_model.dart';

abstract class IChatRepository {
  Future<List<ChatModel>> sendMessage({
    String? type,
    String? value,
    String? fileName,
    String? fileType,
    String? fileId,
  });
  Future<List<ChatModel>> getHistoryMessage();
  Future<String?> getFileToken();
  Future sendImage(String fileToken, PickedFile file);
  Future sendAnyFile(String fileToken, FilePickerResult file);
}
