package chatbot_koreai.chatbot_koreai

import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.annotation.NonNull
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ChatbotKoreaiPlugin */
class ChatbotKoreaiPlugin: FlutterPlugin, MethodCallHandler {

  private lateinit var channel : MethodChannel
  private lateinit var setClientId: String
  private lateinit var setClientSecret: String
  private lateinit var setUserId: String
  private lateinit var setAssertion: String
  private lateinit var setChatBot: String
  private lateinit var setUserInfo: Map<String, Any>
  private lateinit var chatbotObject: Map<String, Any>

  companion object {
    private const val REQUEST_CODE_FLUTTER_ACTIVITY = 9870
    private var app: AppCompatActivity? = null
  }


  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "chatbot_koreai")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "start") {
      result.success(mapOf(
        "botId" to ChatBotKoreAI.botId,
        "clientSecret" to ChatBotKoreAI.clientSecret,
        "clientId" to ChatBotKoreAI.clientId,
        "userId" to ChatBotKoreAI.userId,
        "assertion" to ChatBotKoreAI.assertion,
        "chatBot" to ChatBotKoreAI.chatBot,
        "userInfo" to ChatBotKoreAI.userInfo
      ))
    } else if (call.method == "close") {
      finish()
      result.success(null)
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  fun initialize(app: AppCompatActivity) {
    try {
      ChatbotKoreaiPlugin.app = app
      val flutterActivityIntent = Intent(ChatbotKoreaiPlugin.app, FlutterMainActivity::class.java)
      ChatbotKoreaiPlugin.app!!.startActivityForResult(flutterActivityIntent, REQUEST_CODE_FLUTTER_ACTIVITY)
    } catch (e: Exception) {
      Log.d("ERRO", e.toString())
    }
  }

  fun finish() {
    channel.invokeMethod("finalizaKotlin", null)
    ChatBotKoreAI.invokeCallbackOnFinishChabotPlugin()
    ChatbotKoreaiPlugin.app!!.finishActivity(REQUEST_CODE_FLUTTER_ACTIVITY)
  }

}
