package com.example.trx
import android.content.Context
import android.net.wifi.WifiManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.annotation.NonNull
import java.net.NetworkInterface
import java.util.Collections
import android.os.Bundle


class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.trx/macAddress"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getMacAddress") {
                val macAddress = getMacAddress()
                result.success(macAddress)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getMacAddress(): String {
        
        return try {
            val interfaceName = "wlan0"
            val interfaces = Collections.list(NetworkInterface.getNetworkInterfaces())
            for (inter_face in interfaces) {
                if (!inter_face.name.equals(interfaceName, ignoreCase = true)) {
                    continue
                }

                val mac = inter_face.hardwareAddress ?: return ""
                val buffer = StringBuilder()
                for (aMac in mac) {
                    buffer.append(String.format("%02X:", aMac))
                }
                if (buffer.isNotEmpty()) {
                    buffer.deleteCharAt(buffer.length - 1)
                }
                return buffer.toString()
            }
            ""
        } catch (e: Exception) {
            ""
        }
    
    }
}
