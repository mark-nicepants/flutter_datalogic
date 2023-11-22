package com.tusaamf.flutter_datalogic

import android.content.BroadcastReceiver
import android.content.ContentValues.TAG
import android.content.Context
import android.content.Intent
import android.util.Log
import com.tusaamf.flutter_datalogic.const.MyEvents
import io.flutter.plugin.common.EventChannel.EventSink
import org.json.JSONObject

class SinkBroadcastReceiver(private var events: EventSink? = null) : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            ///  A barcode has been scanned
            DLInterface.ACTION_BROADCAST_RECEIVER -> {
                handleScannedBarcode(intent)
            }

            else -> {
                // Log.d("flutter_datalogic:onReceive:default", intentToString(intent))
                Log.d(TAG, "default_case")
            }
        }
    }

    private fun handleScannedBarcode(intent: Intent) {
        val scanData =
            intent.getStringExtra(DLInterface.DATALOGIC_SCAN_EXTRA_DATA_STRING) ?: ""
        val scanResult = JSONObject()
        scanResult.put(MyEvents.EVENT_NAME, MyEvents.SCAN_RESULT)
        scanResult.put("scanData", scanData)

        events!!.success(scanResult.toString())
    }
}