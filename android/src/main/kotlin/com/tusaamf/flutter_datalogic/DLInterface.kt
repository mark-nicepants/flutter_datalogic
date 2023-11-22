package com.tusaamf.flutter_datalogic

class DLInterface {
    companion object {
        // Datalogic Actions
        const val ACTION_BROADCAST_RECEIVER = "com.tussaamf.datalogic.decode_action"
        // Datalogic Categories
        const val CATEGORY_BROADCAST_RECEIVER = "com.tussaamf.datalogic.decode_category"
        // Datalogic Barcode string
        const val DATALOGIC_SCAN_EXTRA_DATA_STRING = "com.datalogic.decode.intentwedge.barcode_string"
    }
}