package com.tusaamf.flutter_datalogic

import android.content.BroadcastReceiver
import android.content.ContentValues.TAG
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import com.tusaamf.flutter_datalogic.const.MyEvents
import com.tusaamf.flutter_datalogic.const.ScannerStatus
import io.flutter.plugin.common.EventChannel.EventSink
import org.json.JSONObject

class SinkBroadcastReceiver(private var events: EventSink? = null) : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            ///  A barcode has been scanned
            "${context.packageName}${DLInterface.ACTION_BROADCAST_RECEIVER}" -> {
                handleScannedBarcode(intent)
            }

            ///  A scan status has been changed
            "${context.packageName}${DLInterface.ACTION_SCANNER_STATUS}" -> {
                val extraKey = "${context.packageName}${DLInterface.EXTRA_SCANNER_STATUS}"
                if (intent.hasExtra(extraKey)) {
                    intent.getBundleExtra(extraKey)?.let {
                        handleScannerStatus(it)
                    }
                }
            }

            else -> {
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

    private fun handleScannerStatus(b: Bundle) {
        val status =
            b.getString(DLInterface.EXTRA_KEY_VALUE_SCANNER_STATUS)
        val scanResult = JSONObject()
        scanResult.put(MyEvents.EVENT_NAME, MyEvents.SCANNER_STATUS)
        scanResult.put("status", status)

        events!!.success(scanResult.toString())

        if (status == ScannerStatus.SCANNING.toString()) {
            resetScannedBarcode()
        }
    }

    private fun resetScannedBarcode() {
        val scanResult = JSONObject()
        scanResult.put(MyEvents.EVENT_NAME, MyEvents.SCAN_RESULT)
        scanResult.put("scanData", "")

        events!!.success(scanResult.toString())
    }
}