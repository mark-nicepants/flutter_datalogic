package com.tusaamf.flutter_datalogic

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.util.Log
import com.tusaamf.flutter_datalogic.const.MyChannels

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.Exception
import com.datalogic.decode.BarcodeManager
import com.datalogic.decode.DecodeException
import com.datalogic.decode.configuration.ScannerProperties
import com.datalogic.device.configuration.ConfigException
import com.tusaamf.flutter_datalogic.const.ScannerStatus

/** FlutterDatalogicPlugin */
class FlutterDatalogicPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {

    private lateinit var scanEventChannel: EventChannel

    private var manager: BarcodeManager? = null

    private var configuration: ScannerProperties? = null

    /**
     * Used to save BroadcastReceiver to be able unregister them.
     */
    private val registeredReceivers: ArrayList<SinkBroadcastReceiver> = ArrayList()

    private lateinit var context: Context

    private lateinit var intentFilter: IntentFilter

    private var scannedBarcode: String = ""

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext

        try {
            // Create a BarcodeManager. It will be used later to change intent delivery modes.
            manager = BarcodeManager().also {
                it.addReadListener{ result ->
                    scannedBarcode = result.text
                }
            }

            // get the current settings from the BarcodeManager
            configuration = ScannerProperties.edit(manager)

            configuration?.let {
                it.ean13.sendChecksum.set(true)
                // set default labelSuffix from [LF] to ""
                // https://datalogic.github.io/oemconfig/scanner-settings/#formatting
                it.format.labelSuffix.set("")
            }
            listenScannerStatus()
        } catch (e: Exception) { // Any error?
            when (e) {
                is ConfigException -> Log.e(
                    LOG_TAG,
                    "Error while retrieving/setting properties: " + e.error_number,
                    e
                )

                is DecodeException -> Log.e(
                    LOG_TAG,
                    "Error while retrieving/setting properties: " + e.error_number,
                    e
                )

                else -> Log.e(LOG_TAG, "Other error ", e)
            }
            e.printStackTrace()
        }

        try {
            // Register dynamically decode wedge intent broadcast receiver.
            intentFilter = IntentFilter().also {
                it.addAction("${context.packageName}${DLInterface.ACTION_SCANNER_INFO}")
            }

            scanEventChannel =
                EventChannel(flutterPluginBinding.binaryMessenger, MyChannels.scanChannel)
            scanEventChannel.setStreamHandler(this)
        } catch (e: Exception) {
            Log.e(LOG_TAG, "Error while register intent broadcast receiver", e)
            e.printStackTrace()
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
    }

    private fun listenScannerStatus() {
        fun sendScannerInfo(status: ScannerStatus, barcode: String) {
            Intent().also { intent ->
                val bundle = Bundle().also {
                    it.putString(
                        DLInterface.EXTRA_KEY_VALUE_SCANNER_STATUS,
                        status.toString()
                    )
                    it.putString(
                        DLInterface.EXTRA_KEY_VALUE_SCAN_DATA,
                        barcode
                    )
                }

                intent.action = "${context.packageName}${DLInterface.ACTION_SCANNER_INFO}"
                intent.putExtra("${context.packageName}${DLInterface.EXTRA_SCANNER_INFO}", bundle)
                context.sendBroadcast(intent)
            }
        }
        manager?.addStartListener {
            scannedBarcode = ""
            sendScannerInfo(ScannerStatus.SCANNING, scannedBarcode)
        }
        manager?.addStopListener {
            sendScannerInfo(ScannerStatus.IDLE, scannedBarcode)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        for (receiver in registeredReceivers) {
            context.unregisterReceiver(receiver)
        }
        scanEventChannel.setStreamHandler(null)
    }

    @SuppressLint("UnspecifiedRegisterReceiverFlag")
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        val receiver = SinkBroadcastReceiver(events)
        registeredReceivers.add(receiver)
        context.registerReceiver(receiver, intentFilter)
    }

    override fun onCancel(arguments: Any?) {
    }

    companion object {
        private const val LOG_TAG = "FlutterDatalogic"
    }
}
