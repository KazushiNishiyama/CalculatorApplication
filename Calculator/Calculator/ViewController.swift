//
//  ViewController.swift
//  Calculator
//
//  Created by KN on 2019/08/15.
//  Copyright © 2019年 KN. All rights reserved.
//

import UIKit

enum OperatorType{
    case Plus
    case Minus
    case Multi
    case Subtract
    case Null
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var ResultLabel: UILabel!
    
    var numString : String = ""
    var num : Double = 0
    var numBuffer : Double = 0
    
    var operatorType : OperatorType = OperatorType.Null
    
    var calculateController : CalculateController!
    
    //イコールが押されずに連続して演算子と数字が押されたかどうかを判別する用
    var operatorFirst = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculateController = CalculateController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func TwoZeroButtonClicked(_ sender: UIButton) {
        if(numString != ""){
            numString += "00"
            num = Double(numString)!
            ResultLabel.text=numString
        }
    }
    
    @IBAction func NumButtonClicked(_ sender: UIButton) {
        //入力した数字が01とかになるのを防ぐ
        if(numString == "0"){
            numString = ""
        }
        
        numString += String(sender.tag)
        
        num = Double(numString)!
        ResultLabel.text=numString
    }
    
    @IBAction func operatorButtonClicked(_ sender: UIButton) {
        
        //数値が入力されてない段階で演算子ボタンが押された時
        if(numString == ""){
            return
        }
        
        
        //前に入力されてた値をBufferに入れて、新しい値をnumに代入
        if(numBuffer == 0){
            numBuffer = num
        }
        
        if(numBuffer != 0 && !operatorFirst){
            let result : Double! = calculateController.Calculate(numBuffer, num, operatorType)
            if(result == nil){
                ErrorProcess()
                return
            }
            numBuffer = result
            ResultLabel.text = String(result)
            numString = ""
        }
        print("operator")
        switch sender.tag{
        case 1:
            operatorType = OperatorType.Plus
        case 2:
            operatorType = OperatorType.Minus
        case 3:
            print("multi")
            operatorType = OperatorType.Multi
        case 4:
            operatorType = OperatorType.Subtract
        default:
            print("switch error")
            
        }
        
        operatorFirst = false
        numString = ""
    }
    
    @IBAction func ClearButtonClicked(_ sender: UIButton) {
        Clear()
    }
    
    func Clear(){
        ResultLabel.text = "0"
        numBuffer = 0
        numString = ""
        operatorType = OperatorType.Null
        operatorFirst = true
    }
    
    @IBAction func EqualButtonClicked(_ sender: UIButton) {
        print("num = \(num)")
        print("numBuffer = \(numBuffer)")
        print("operatorType = \(operatorType)")
        
        let result : Double! = calculateController.Calculate(numBuffer, num, operatorType)
        if(result == nil){
            ErrorProcess()
            return
        }
        numBuffer = result
        ResultLabel.text = String(result)
        numString = String(result)
        operatorFirst = true
    }
    
    //0徐算
    func ErrorProcess(){
        Clear()
        ResultLabel.text = "error"
    }
    
    
    @IBAction func DotButtonClicked(_ sender: UIButton) {
        
        //入力した数字が01とかになるのを防ぐ
        if(numString == ""){
            numString = "0"
        }else if(numString.contains(".")){
            return
        }
        
        numString += "."
        
        ResultLabel.text=numString
    }
    
    @IBAction func PlusMinusButtonCliked(_ sender: UIButton) {
        
        if(numString == ""){
            return
        }
        var p : Double = Double(numString)!
        
        p -= p*2
        
        //numBuffer = p
        num = p
        numString = String(p)
        
        ResultLabel.text = numString
    }
    
    @IBAction func PercentButtonClicked(_ sender: UIButton) {
        
        
        if(numString == ""){
            return
        }
        var p : Double = Double(numString)!
        
        p /= 100
        
        numBuffer = p
        numString = String(p)
        
        ResultLabel.text = numString
    }
}

