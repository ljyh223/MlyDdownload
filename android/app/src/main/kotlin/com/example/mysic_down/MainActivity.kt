package com.example.mysic_down

import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterFragmentActivity () {

    private val CHANNEL = "com.example.mysic_down/platform"

    @RequiresApi(Build.VERSION_CODES.N)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "metadataWrite") {
                // 处理来自Flutter的请求
                val arguments = call.arguments as? Map<String, String>
                val message = arguments?.let { MetadataWrite().metadataWrite(it) }
                result.success(message)
            } else {
                result.notImplemented()
            }
        }
    }

}
