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

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var ResultLabel: UILabel!
    var ImageView: UIImageView!
    
    var numString : String = ""
    var num : Double = 0
    var numBuffer : Double = 0
    
    var operatorType : OperatorType = OperatorType.Null
    
    var calculateController : CalculateController!
    
    //イコールが押されずに連続して演算子と数字が押されたかどうかを判別する用
    var operatorFirst = true
    //イコールが押された直後かどうか
    var isStringReset = false
    var picker: UIImagePickerController! = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GenerateImageView()
        calculateController = CalculateController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func TwoZeroButtonClicked(_ sender: UIButton) {
        if(numString != "" && numString != "0"){
            numString += "00"
            num = Double(numString)!
            ResultLabel.text=numString
        }
    }
    
    @IBAction func NumButtonClicked(_ sender: UIButton) {
        
        //イコールが押された後の状態
        if(isStringReset){
            numString = ""
            isStringReset = false
        }
        
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
        
        //イコールが押されずに1+2+3+...の用に連続で演算子と数字が繰り返された時にその都度計算していく
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
        
        switch sender.tag{
        case 1:
            operatorType = OperatorType.Plus
        case 2:
            operatorType = OperatorType.Minus
        case 3:
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
        
        let result : Double! = calculateController.Calculate(numBuffer, num, operatorType)
        if(result == nil){
            ErrorProcess()
            return
        }
        numBuffer = result
        ResultLabel.text = String(result)
        numString = String(result)
        operatorFirst = true
        isStringReset = true
    }
    
    //0徐算のときに呼ぶ
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
        
        numBuffer = p
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
    
    //UIImagePickerを表示
    @IBAction func ImageFolderClicked(_ sender: UIButton) {
        
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.delegate = self
        picker.navigationBar.tintColor = UIColor.white
        picker.navigationBar.barTintColor = UIColor.gray
        
        //ピッカーを表示する
        present(picker, animated: true, completion: nil)
    }
    
    //コードからImage Viewを生成
    func GenerateImageView(){
        
        // 表示できる限界(bound)のサイズ
        let BoundSize_w: CGFloat = UIScreen.main.bounds.width
        let BoundSize_h: CGFloat = UIScreen.main.bounds.height
        print("\(BoundSize_w),\(BoundSize_h)")  //iPhone6の場合375.0,667.0と出力
        
        
        ImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: BoundSize_w, height: BoundSize_h))
        
        //ImageView.image = UIImage(named: "Photos.png")
        
        ImageView.layer.position = CGPoint(x: BoundSize_w/2, y:BoundSize_h/2)
        
        view.addSubview(ImageView)
        
        self.view.sendSubview(toBack: ImageView)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // キャンセルボタンを押された時に呼ばれる
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 写真が選択された時に呼ばれる
        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        ImageView.image = image
    }
}

