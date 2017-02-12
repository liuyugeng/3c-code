//
//  File.swift
//  3c
//
//  Created by liuyugeng on 05/12/2016.
//  Copyright © 2016 liuyugeng.com. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreMotion


class GravityController: UIViewController, BluetoothDelegate, UIAccelerometerDelegate
{
    let bluetoothManager = BluetoothManager.getInstance()
    var characteristic: CBCharacteristic?
    var writeType: CBCharacteristicWriteType?
    
    var car:UIImageView!
    var speedX:UIAccelerationValue = 0
    var speedY:UIAccelerationValue = 0
    var motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAll()
        
        car = UIImageView(image:UIImage(named:"car"))
        car.frame = CGRect(x:0, y:0, width:100, height:100)
        car.center = self.view.center
        self.view.addSubview(car)
        
        motionManager.accelerometerUpdateInterval = 1/60
        
        var str_a: String = ""
        var str_b: String = ""
        
        if motionManager.isAccelerometerAvailable {
            let queue = OperationQueue.current
            motionManager.startAccelerometerUpdates(to: queue!, withHandler: {
                (accelerometerData, error) in
                self.speedX += accelerometerData!.acceleration.x
                self.speedY +=  accelerometerData!.acceleration.y
                var posX=self.car.center.x + CGFloat(self.speedX)
                var posY=self.car.center.y - CGFloat(self.speedY)
                
                let thetaY = (posY - self.car.center.y)
                let thetaX = (posX - self.car.center.x)
                let k = thetaY/thetaX
                
                if(thetaX >= 0){
                    if(k > 1.0){
                        str_a = "0x42"
                        print("后")
                        
                    }
                    else if(k <= 1.0 && k >= -1.0){
                        str_a = "0x44"
                        print("右")
                        
                    }
                    else{
                        str_a = "0x41"
                        print("前")
                        
                    }
                }
                else{
                    if(k > 1.0){
                        str_a = "0x41"
                        print("前")
                        
                    }
                    else if(k <= 1.0 && k >= -1.0){
                        str_a = "0x43"
                        print("左")
                        
                    }
                    else{
                        str_a = "0x42"
                        print("后")
                        
                    }
                }
                if(str_b != str_a){
                    var hexString = str_a.substring(from: str_a.characters.index(str_a.startIndex, offsetBy: 2))
                    print(hexString)
                    if hexString.characters.count % 2 != 0 {
                        hexString = "0" + hexString
                    }
                    let data = hexString.dataFromHexadecimalString()
                    
                    self.bluetoothManager.writeValue(data: data!, forCahracteristic: self.characteristic!, type: self.writeType!)
                    str_b = str_a
                }
                
                //碰到边框后的反弹处理
                if posX<0 {
                    posX=0;
                    //左边框
                    self.speedX *= 0
                    
                }else if posX > self.view.bounds.size.width {
                    posX=self.view.bounds.size.width
                    //右边框
                    self.speedX *= 0
                }
                if posY<0 {
                    posY=0
                    //上边框
                    self.speedY=0
                } else if posY>self.view.bounds.size.height{
                    posY=self.view.bounds.size.height
                    //下边框
                    self.speedY *= 0
                }
                self.car.center = CGPoint(x:posX, y:posY)
            })
        }
    }
    
    func initAll(){
        assert(characteristic != nil || writeType != nil, "The GravityController didn't initilize correct!")
        self.title = "重力感应控制"
        bluetoothManager.delegate = self
    }

    override func viewDidDisappear(_ animated: Bool) {
        if (self.motionManager.isAccelerometerActive)
        {
            self.motionManager.stopAccelerometerUpdates()
        }
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
