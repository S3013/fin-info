//
//  BluetoothManager.swift
//  Runner
//
//  Created by NeoSOFT on 14/06/23.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, FlutterPlugin, CBCentralManagerDelegate {
    private var centralManager: CBCentralManager?
    private var flutterResult: FlutterResult?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "bluetooth_channel", binaryMessenger: registrar.messenger())
        let instance = BluetoothManager()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "enableBluetooth":
            flutterResult = result
            enableBluetooth()
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func enableBluetooth() {
        if let centralManager = centralManager {
            switch centralManager.state {
            case .poweredOn:
                flutterResult?(true)
            case .poweredOff:
                centralManager.delegate = self
                centralManager.scanForPeripherals(withServices: nil, options: nil)
            default:
                flutterResult?(false)
            }
        } else {
            flutterResult?(false)
        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            flutterResult?(true)
        } else {
            flutterResult?(false)
        }
    }
}

