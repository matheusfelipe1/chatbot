package chatbot_koreai.chatbot_koreai

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class FlutterMainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "chatbot_koreai").invokeMethod("myMethod", null)
    }

    fun getContextFlutter(): Context {
        return this
    }

    fun getActivityFlutter(): FlutterActivity {
        return this
    }

}