//
//  Calculate.swift
//  Calculator
//
//  Created by KN on 2019/08/19.
//  Copyright © 2019年 KN. All rights reserved.
//

import Foundation

class CalculateController{
    
    
    func Calculate(_ numBuffer : Double, _ num : Double,_ operatorType : OperatorType) ->Double? {
        
        var result : Double!
        
        switch operatorType{
        case OperatorType.Plus:
            //+
            result = num + numBuffer
        case OperatorType.Minus:
            //-
            result = numBuffer - num
        case OperatorType.Multi:
            //*
            result = numBuffer * num
        case OperatorType.Subtract:
            // /
            if(num == 0){
                return nil
            }
            result = numBuffer / num
        default:
            print("switch error")
        }
        
        return result
    }
}
