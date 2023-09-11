package chatbot_koreai.chatbot_koreai

import androidx.appcompat.app.AppCompatActivity

object ChatBotKoreAI {
    var botId: String? = null
    var clientId: String? = null
    var clientSecret: String? = null
    var userId: String? = null
    var assertion: String? = null
    var chatBot: String? = null
    var userInfo: Map<String, Any>? = null
    private var callback: (() -> Unit)? = null

    fun setCallbackOnFinishChabotPlugin(callback: (() -> Unit)) {
        this.callback = callback;
    }

    fun invokeCallbackOnFinishChabotPlugin() {
        this.callback?.invoke()
    }
}