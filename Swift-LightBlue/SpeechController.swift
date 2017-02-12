//
//  SpeechController.swift
//  Swift-LightBlue
//
//  Created by liuyugeng on 18/11/2016.
//  Copyright © 2016 Pluto-y. All rights reserved.
//

import Foundation
import UIKit
import Speech
import CoreBluetooth

class SpeechController: UIViewController, SFSpeechRecognizerDelegate, UITextViewDelegate, BluetoothDelegate
{
    
    let bluetoothManager = BluetoothManager.getInstance()
    var characteristic: CBCharacteristic?
    var writeType: CBCharacteristicWriteType?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    
    //创建区域标志符
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "zh-cn"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    static var sendMessage : NSString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAll()
        // Do any additional setup after loading the view, typically from a nib.
        textView.delegate = self
        
        microphoneButton.isEnabled = false
        
        //将语音识别的delegate设为self
        speechRecognizer.delegate = self
        
        //请求语音识别
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("用户拒绝访问语音识别")
                
            case .restricted:
                isButtonEnabled = false
                print("此设备语音识别受到限制")
                
            case .notDetermined:
                isButtonEnabled = false
                print("语音识别尚未授权")
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initAll(){
        assert(characteristic != nil || writeType != nil, "The SpeechController didn't initilize correct!")
        self.title = "语音控制"
        bluetoothManager.delegate = self
    }
    
    func textFieldShouldReturn(textView: UITextView) -> Bool{
        textView.resignFirstResponder()
        return true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
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
    
    @IBAction func microphoneTapped(_ sender: AnyObject) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            microphoneButton.setTitle("开始录音", for: .normal)
        } else {
            startRecording()
            microphoneButton.setTitle("结束录音", for: .normal)
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {  //检查recognitionTask运行状态
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()  //访问音频会话
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("由于一些问题您的录音不能设置。")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //实例化recognitionRequest
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("您的设备不支持音频输入")
        }  //检查设备是否支持音频输入
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("不能创建一个SFSpeechAudioBufferRecognitionRequest对象")
        } //检查recognitionRequest对象是否被实例化
        
        recognitionRequest.shouldReportPartialResults = true  //一部分一部分的发送语音识别数据
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in  //可以修改当前识别结果
            
            var isFinal = false
            
            if result != nil {
                
                self.textView.text = result?.bestTranscription.formattedString  //看结果是否为最优
                isFinal = (result?.isFinal)!//true
            }
            
            SpeechController.sendMessage = self.textView.text as NSString
            let frontStr = SpeechController.sendMessage.range(of: "前");
            let backStr = SpeechController.sendMessage.range(of: "后");
            let leftStr = SpeechController.sendMessage.range(of: "左");
            let rightStr = SpeechController.sendMessage.range(of: "右");
            let stopStr = SpeechController.sendMessage.range(of: "停");
            if frontStr.location != NSNotFound{
                var _sendMessage : Int = 0x41
                let data = NSData(bytes: &_sendMessage, length: MemoryLayout<Int>.size)
                self.bluetoothManager.writeValue(data: data as Data, forCahracteristic: self.characteristic!, type: self.writeType!)
                print(_sendMessage )
            }
            if backStr.location != NSNotFound{
                var _sendMessage : Int = 0x42
                let data = NSData(bytes: &_sendMessage, length: MemoryLayout<Int>.size)
                self.bluetoothManager.writeValue(data: data as Data, forCahracteristic: self.characteristic!, type: self.writeType!)
                print(_sendMessage )
            }
            if leftStr.location != NSNotFound{
                let textContent = "0x43"
                var hexString = textContent.substring(from: textContent.characters.index(textContent.startIndex, offsetBy: 2))
                if hexString.characters.count % 2 != 0 {
                    hexString = "0" + hexString
                }
                let data = hexString.dataFromHexadecimalString()
                
                self.bluetoothManager.writeValue(data: data!, forCahracteristic: self.characteristic!, type: self.writeType!)
            }
            if rightStr.location != NSNotFound{
                let textContent = "0x44"
                var hexString = textContent.substring(from: textContent.characters.index(textContent.startIndex, offsetBy: 2))
                if hexString.characters.count % 2 != 0 {
                    hexString = "0" + hexString
                }
                let data = hexString.dataFromHexadecimalString()
                
                self.bluetoothManager.writeValue(data: data!, forCahracteristic: self.characteristic!, type: self.writeType!)

            }
            if stopStr.location != NSNotFound{
                var _sendMessage : Int = 0x53
                let data = NSData(bytes: &_sendMessage, length: MemoryLayout<Int>.size)
                self.bluetoothManager.writeValue(data: data as Data, forCahracteristic: self.characteristic!, type: self.writeType!)
                print(_sendMessage )
            }
            
            if error != nil || isFinal {  //检查没有错误或是收到最终结果
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true //将录音按钮切换为可用
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }//添加音频输入
        
        audioEngine.prepare()  //audioEngine设为准备状态
        
        do {
            try audioEngine.start()
        } catch {
            print("由于一些错误，audioEngine不能启动。")
        }
        
        textView.text = "好!\n"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    
    
}
