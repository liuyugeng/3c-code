//
//  GestureRecognitionControl.swift
//  3c
//
//  Created by liuyugeng on 05/12/2016.
//  Copyright © 2016 liuyugeng.com. All rights reserved.
//
import UIKit
import CoreBluetooth
import UIKit.UIGestureRecognizerSubclass

class GestureRecognitionController: UIViewController, BluetoothDelegate
{
    let bluetoothManager = BluetoothManager.getInstance()
    var characteristic: CBCharacteristic?
    var writeType: CBCharacteristicWriteType?
    var direct : Int = 0
    var str : String = ""
    var speed : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAll()
        
        let swipeUp = UISwipeGestureRecognizer(target:self, action:#selector(swipe(_:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target:self, action:#selector(swipe(_:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target:self, action:#selector(swipe(_:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target:self, action:#selector(swipe(_:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
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
        assert(characteristic != nil || writeType != nil, "The GestureRecognitionController didn't initilize correct!")
        self.title = "手势识别控制"
        bluetoothManager.delegate = self
    }

    
    func swipe(_ recognizer:UISwipeGestureRecognizer){
        
        if recognizer.direction == .up{
            print("向上滑动")
            let textContent = "0x41"
            direct = 41
            var hexString = textContent.substring(from: textContent.characters.index(textContent.startIndex, offsetBy: 2))
            if hexString.characters.count % 2 != 0 {
                hexString = "0" + hexString
            }
            let data = hexString.dataFromHexadecimalString()
            
            self.bluetoothManager.writeValue(data: data!, forCahracteristic: self.characteristic!, type: self.writeType!)
        }
        else if recognizer.direction == .down{
            print("向下滑动")
            let textContent = "0x42"
            direct = 42
            var hexString = textContent.substring(from: textContent.characters.index(textContent.startIndex, offsetBy: 2))
            if hexString.characters.count % 2 != 0 {
                hexString = "0" + hexString
            }
            let data = hexString.dataFromHexadecimalString()
            
            self.bluetoothManager.writeValue(data: data!, forCahracteristic: self.characteristic!, type: self.writeType!)
        }
        else if recognizer.direction == .left{
            print("向左滑动")
            let textContent = "0x43"
            direct = 43
            var hexString = textContent.substring(from: textContent.characters.index(textContent.startIndex, offsetBy: 2))
            if hexString.characters.count % 2 != 0 {
                hexString = "0" + hexString
            }
            let data = hexString.dataFromHexadecimalString()
            
            self.bluetoothManager.writeValue(data: data!, forCahracteristic: self.characteristic!, type: self.writeType!)
        }
        else if recognizer.direction == .right{
            print("向右滑动")
            let textContent = "0x44"
            direct = 44
            var hexString = textContent.substring(from: textContent.characters.index(textContent.startIndex, offsetBy: 2))
            if hexString.characters.count % 2 != 0 {
                hexString = "0" + hexString
            }
            let data = hexString.dataFromHexadecimalString()
            
            self.bluetoothManager.writeValue(data: data!, forCahracteristic: self.characteristic!, type: self.writeType!)
        }
        
        let point=recognizer.location(in: self.view)
        //这个点是滑动的起点
        print(point.x)
        print(point.y)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            if view.traitCollection.forceTouchCapability == .available {
                let a: Float = Float(touch.force)
                if(direct == 41){
                    if (a >= 0.0 && a <= 2.22){
                        speed = "0x46"
                    }
                    else if (a > 2.2 && a <= 3.3){
                        speed = "0x45"
                    }
                    else{
                        speed = "0x41"
                    }
                }
                else if(direct == 42){
                    if (a >= 0.0 && a <= 2.22){
                        speed = "0x48"
                    }
                    else if (a > 2.2 && a <= 3.3){
                        speed = "0x47"
                    }
                    else{
                        speed = "0x42"
                    }
                }
                if(str != speed){
                    let textContent = speed
                    var hexString = textContent.substring(from: textContent.characters.index(textContent.startIndex, offsetBy: 2))
                    if hexString.characters.count % 2 != 0 {
                        hexString = "0" + hexString
                    }
                    let data = hexString.dataFromHexadecimalString()
                    print(hexString)
                    self.bluetoothManager.writeValue(data: data!, forCahracteristic: self.characteristic!, type: self.writeType!)
                    str = speed
                }
                
            }
        }
    }
}
