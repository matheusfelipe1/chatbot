class Endpoints {
  static String get baseUrl => "https://bots.kore.ai/";
  static String get chat => "chatbot/v2/webhook/";
  static String get bearerToken =>
      "https://bots.kore.ai/api/oAuth/token/jwtgrant";
  static String get history =>
      "https://bots.kore.ai/api/botmessages/rtm?botId=";
  static String get fileToken =>
      'https://bots.kore.ai/api/1.1/attachment/file/token';
  static String get file => 'https://bots.kore.ai/api/1.1/attachment/file';
}
