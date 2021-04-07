package com.app.markaa

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.annotation.NonNull
import com.adjust.sdk.flutter.AdjustSdk
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    // Either call make the call in onCreate.
    protected override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // GeneratedPluginRegistrant.registerWith(this); Used only for pre flutter 1.12 Android projects
        val intent: Intent = intent
        val data: Uri? = intent.getData()
        AdjustSdk.appWillOpenUrl(data, this)
    }

    // Or make the cakll in onNewIntent.
    protected override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val data: Uri? = intent.getData()
        AdjustSdk.appWillOpenUrl(data, this)
    }
}
