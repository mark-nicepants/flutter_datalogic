package com.tusaamf.flutter_datalogic

class DLInterface {
    companion object {
        // Datalogic Actions
        const val ACTION_BROADCAST_RECEIVER = "com.tusaamf.datalogic.decode_action"
        const val ACTION_SCANNER_STATUS = "com.tusaamf.datalogic.api.SCANNER_STATUS"
        // Datalogic Categories
        const val CATEGORY_BROADCAST_RECEIVER = "com.tusaamf.datalogic.decode_category"
        // Datalogic extras
        const val DATALOGIC_SCAN_EXTRA_DATA_STRING = "com.datalogic.decode.intentwedge.barcode_string"
        const val EXTRA_SCANNER_STATUS = "com.tusaamf.datalogic.extra.SCANNER_STATUS"
        const val EXTRA_KEY_VALUE_SCANNER_STATUS = "SCANNER_STATUS"
    }
}