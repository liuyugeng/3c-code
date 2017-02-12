//
//  DirectionController.swift
//  Swift-LightBlue
//
//  Created by liuyugeng on 18/11/2016.
//  Copyright © 2016 Pluto-y. All rights reserved.
//

import UIKit
import CoreBluetooth

class DirectionController: UIViewController, BluetoothDelegate
{
    let bluetoothManager = BluetoothManager.getInstance()
    var characteristic: CBCharacteristic?
    var writeType: CBCharacteristicWriteType?
    
    
    var speed: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAll()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let textContent = "0x53"
        var hexString = textContent.substring(from: textContent.characters.index(textContent.startIndex, offsetBy: 2))
        if hexString.characters.count % 2 != 0 {
            hexString = "0" + hexString
        }
        let data = hexString.dataFromHexadecimalString()
        print(hexString)
        self.bluetoothManager.writeValue(data: data!, forCahracteristic: self.characteristic!, type: self.writeType!)
    }
    
    func initAll(){
        assert(characteristic != nil || writeType != nil, "The DirectionController didn't initilize correct!")
        self.title = "方向控制"
        bluetoothManager.delegate = self
    }
    @IBOutlet weak var frontButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!

    
    
    @IBAction func front(sender : UIButton!) {
        var _sendMessage : Int = 0x41
        let data = NSData(bytes: &_sendMessage, length: MemoryLayout<Int>.size) as Data?
        self.bluetoothManager.writeValue(data: data! as Data, forCahracteristic: self.characteristic!, type: self.writeType!)
        print(_sendMessage )
        
    }
    @IBAction func back(sender : UIButton!) {
        var _sendMessage : Int = 0x42
        let data = NSData(bytes: &_sendMessage, length: MemoryLayout<Int>.size)
        self.bluetoothManager.writeValue(data: data as Data, forCahracteristic: self.characteristic!, type: self.writeType!)
        print(_sendMessage )
    }
    @IBAction func left(sender : UIButton!) {
        let textContent = "0x43"
        var hexString = textContent.substring(from: textContent.characters.index(textContent.startIndex, offsetBy: 2))
        print(hexString)
        if hexString.characters.count % 2 != 0 {
            hexString = "0" + hexString
        }
        let data = hexString.dataFromHexadecimalString()
        
        self.bluetoothManager.writeValue(data: data!, forCahracteristic: self.characteristic!, type: self.writeType!)

    }
    @IBAction func right(sender : UIButton!) {
        let textContent = "0x44"
        var hexString = textContent.substring(from: textContent.characters.index(textContent.startIndex, offsetBy: 2))
        if hexString.characters.count % 2 != 0 {
            hexString = "0" + hexString
        }
        let data = hexString.dataFromHexadecimalString()
        print(hexString)
        self.bluetoothManager.writeValue(data: data!, forCahracteristic: self.characteristic!, type: self.writeType!)
    }
    @IBAction func stop(sender : UIButton!) {
        let textContent = "0x53"
        var hexString = textContent.substring(from: textContent.characters.index(textContent.startIndex, offsetBy: 2))
        if hexString.characters.count % 2 != 0 {
            hexString = "0" + hexString
        }
        let data = hexString.dataFromHexadecimalString()
        print(hexString)
        self.bluetoothManager.writeValue(data: data!, forCahracteristic: self.characteristic!, type: self.writeType!)
    }
    
}
