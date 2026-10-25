package com.example.app_clone

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.telephony.CellInfo
import android.telephony.CellInfoCdma
import android.telephony.CellInfoGsm
import android.telephony.CellInfoLte
import android.telephony.CellInfoNr
import android.telephony.CellInfoWcdma
import android.telephony.TelephonyManager
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.whereismytrain/cell"
    private val cellPermissionRequest = 4821
    private var pendingCellResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                if (call.method != "getCellTowerSnapshot") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                if (hasCellPermissions()) {
                    result.success(readCellSnapshot())
                } else {
                    pendingCellResult = result
                    ActivityCompat.requestPermissions(
                        this,
                        arrayOf(
                            Manifest.permission.ACCESS_FINE_LOCATION,
                            Manifest.permission.READ_PHONE_STATE
                        ),
                        cellPermissionRequest
                    )
                }
            }
    }

    private fun hasCellPermissions(): Boolean {
        val fineLocation = ActivityCompat.checkSelfPermission(
            this, Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED
        val phoneState = ActivityCompat.checkSelfPermission(
            this, Manifest.permission.READ_PHONE_STATE
        ) == PackageManager.PERMISSION_GRANTED
        return fineLocation && phoneState
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode != cellPermissionRequest) return

        val result = pendingCellResult
        pendingCellResult = null
        if (result == null) return

        if (hasCellPermissions()) {
            result.success(readCellSnapshot())
        } else {
            result.error(
                "CELL_PERMISSION_DENIED",
                "Location and phone-state permissions are needed to read cell information.",
                null
            )
        }
    }

    private fun readCellSnapshot(): Map<String, Any?> {
        val manager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
        val cells: List<Map<String, Any?>> = try {
            manager.allCellInfo.orEmpty().mapNotNull { cell -> cellToMap(cell) }
        } catch (_: SecurityException) {
            emptyList()
        } catch (_: RuntimeException) {
            emptyList()
        }

        return mapOf(
            "timestamp" to System.currentTimeMillis(),
            "cells" to cells
        )
    }

    private fun cellToMap(cell: CellInfo): Map<String, Any?>? {
        val type: String
        val cellId: String?
        val areaCode: String?
        val signalDbm = cell.cellSignalStrength.dbm

        when (cell) {
            is CellInfoLte -> {
                type = "LTE"
                cellId = cell.cellIdentity.ci.takeIf { it >= 0 }?.toString()
                areaCode = cell.cellIdentity.tac.takeIf { it >= 0 }?.toString()
            }
            is CellInfoGsm -> {
                type = "GSM"
                cellId = cell.cellIdentity.cid.takeIf { it >= 0 }?.toString()
                areaCode = cell.cellIdentity.lac.takeIf { it >= 0 }?.toString()
            }
            is CellInfoWcdma -> {
                type = "WCDMA"
                cellId = cell.cellIdentity.cid.takeIf { it >= 0 }?.toString()
                areaCode = cell.cellIdentity.lac.takeIf { it >= 0 }?.toString()
            }
            is CellInfoCdma -> {
                type = "CDMA"
                cellId = cell.cellIdentity.basestationId.takeIf { it >= 0 }?.toString()
                areaCode = cell.cellIdentity.networkId.takeIf { it >= 0 }?.toString()
            }
            else -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q && cell is CellInfoNr) {
                    type = "NR"
                    cellId = cell.cellIdentity.nci.takeIf { it >= 0L }?.toString()
                    areaCode = cell.cellIdentity.tac.takeIf { it >= 0 }?.toString()
                } else {
                    return null
                }
            }
        }

        return mapOf(
            "type" to type,
            "cellId" to cellId,
            "areaCode" to areaCode,
            "signalDbm" to signalDbm,
            "registered" to cell.isRegistered
        )
    }
}
