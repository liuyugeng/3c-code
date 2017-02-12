//
//  MainValueController.swift
//  Swift-LightBlue
//
//  Created by liuyugeng on 18/11/2016.
//  Copyright © 2016 Pluto-y. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreMotion

class MainValueController: UIViewController, BluetoothDelegate, UIAccelerometerDelegate
{
    let bluetoothManager = BluetoothManager.getInstance()
    var characteristic: CBCharacteristic?
    var writeType: CBCharacteristicWriteType?
    var motionManager = CMMotionManager()
    
    @IBOutlet var speechBtn: UIButton!
    @IBOutlet var textBtn: UIButton!
    @IBOutlet var directionBtn: UIButton!
    @IBOutlet var GestureRecognizerBtn: UIButton!
    @IBOutlet var GravityBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initAll()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func initAll(){
        assert(characteristic != nil || writeType != nil, "The MainValueController didn't initilize correct!")
        self.title = "控制台"
        bluetoothManager.delegate = self
        
    }
    
    @IBAction func speechBtn(sender : UIButton!) {
        let controller = SpeechController()
            controller.characteristic = self.characteristic!
        if self.characteristic!.getProperties().contains("Write Without Response") {
            controller.writeType = .withoutResponse
        } else {
            controller.writeType = .withResponse
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func textBtn(sender : UIButton!) {
        let controller = EditValueController()
        controller.characteristic = self.characteristic!
        if self.characteristic!.getProperties().contains("Write Without Response") {
            controller.writeType = .withoutResponse
        } else {
            controller.writeType = .withResponse
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func directionBtn(sender : UIButton!) {
        let controller = DirectionController()
        controller.characteristic = self.characteristic!
        if self.characteristic!.getProperties().contains("Write Without Response") {
            controller.writeType = .withoutResponse
        } else {
            controller.writeType = .withResponse
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func GestureRecognizerBtn(sender : UIButton!) {
        let controller = GestureRecognitionController()
        controller.characteristic = self.characteristic!
        if self.characteristic!.getProperties().contains("Write Without Response") {
            controller.writeType = .withoutResponse
        } else {
            controller.writeType = .withResponse
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func GravityBtn(sender : UIButton!) {
        let controller = GravityController()
        controller.characteristic = self.characteristic!
        if self.characteristic!.getProperties().contains("Write Without Response") {
            controller.writeType = .withoutResponse
        } else {
            controller.writeType = .withResponse
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

