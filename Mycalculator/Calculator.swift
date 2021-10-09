//
//  Calculator.swift
//  Mycalculator
//
//  Created by 吕玉龙 on 2021/10/4.
//  Copyright © 2021 吕玉龙. All rights reserved.
//

import UIKit
var isRadorisDegree:Double = Double.pi/180

class Calculator: NSObject {
    enum Operation{
        case UnaryOp((Decimal)->Decimal?)
        case BinaryOp((Decimal,Decimal)->Decimal?)
        case EqualOp
        case MemoryOp((Decimal,Decimal)->Decimal?)
    }
    
    var Memorynum:Decimal = 0
    var isClear = true

    var operations = [
        "+":Operation.BinaryOp{
            op1,op2 in
            return op1+op2
        },
        "-":Operation.BinaryOp{
            (op1,op2) in
            return op1-op2
        },
        "*":Operation.BinaryOp{
            (op1,op2) in
            return op1*op2
        },
        "/":Operation.BinaryOp{
            (op1,op2) in
            return op2 != 0 ? op1/op2 : nil
        },
        "%":Operation.UnaryOp{
            op1 in
            return op1/100.0
        },
        "+/-":Operation.UnaryOp{
            op1 in
            return -op1
        },
        "=":Operation.EqualOp,
        "x^2":Operation.UnaryOp{
            op1 in
            return op1*op1
        },
        "x^3":Operation.UnaryOp{
            op1 in
            return op1*op1*op1
        },
        "x^y":Operation.BinaryOp{
            (op1,op2) in
            return (pow(NSDecimalNumber(decimal: op1).doubleValue,NSDecimalNumber(decimal: op2).doubleValue) < 1e146 && pow(NSDecimalNumber(decimal: op1).doubleValue,NSDecimalNumber(decimal: op2).doubleValue) > 1e-109 ? Decimal.init(pow(NSDecimalNumber(decimal: op1).doubleValue,NSDecimalNumber(decimal: op2).doubleValue)): nil)
        },
        "e^x":Operation.UnaryOp{
            op1 in
            return (pow(Double(M_E),NSDecimalNumber(decimal: op1).doubleValue) < 1e146 && pow(Double(M_E),NSDecimalNumber(decimal: op1).doubleValue) > 1e-109 ? Decimal.init(pow(Double(M_E),NSDecimalNumber(decimal: op1).doubleValue)) : nil)
        },
        "10^x":Operation.UnaryOp{
            op1 in
            return (pow(10,NSDecimalNumber(decimal: op1).doubleValue) < 1e146 && pow(10,NSDecimalNumber(decimal: op1).doubleValue) > 1e-109 ? Decimal.init(pow(10,NSDecimalNumber(decimal: op1).doubleValue)) : nil)
        },
        "1/x":Operation.UnaryOp{
            op1 in
            return (op1 == 0 ? nil : Decimal.init(string:"1")!/op1)
        },
        "2√x":Operation.UnaryOp{
            op1 in
            return (op1 < 0 ? nil : Decimal.init(pow(NSDecimalNumber(decimal: op1).doubleValue,0.5)))
        },
        "3√x":Operation.UnaryOp{
          op1 in
            return (op1 >= 0 ? Decimal.init(pow(NSDecimalNumber(decimal: op1).doubleValue,1/3.0)) : Decimal.init(-pow(NSDecimalNumber(decimal: -op1).doubleValue,1/3.0)))
        },
        "y√x":Operation.BinaryOp{
           (op1,op2) in
            return ((op1 >= 0 || (op1 < 0 && op2.exponent >= 0 && (op2/2).exponent == -1)) ? Decimal.init((op1.isSignMinus ? -1 : 1)*pow(NSDecimalNumber(decimal: (op1.isSignMinus ? -1 : 1)*op1).doubleValue,NSDecimalNumber(decimal:1/op2).doubleValue)) : nil)
        },
        "ln":Operation.UnaryOp{
          op1 in
            return (op1 > 0 ? Decimal(log(NSDecimalNumber(decimal: op1).doubleValue)) : nil)
        },
        "log10":Operation.UnaryOp{
            op1 in
            return (op1 > 0 ? Decimal(log10(NSDecimalNumber(decimal: op1).doubleValue)) : nil)
        },
        "x!":Operation.UnaryOp{
            op1 in
            if op1 >= 0 && op1.exponent >= 0 && op1 <= 103{
                var res:Decimal = 1
                var index:Decimal = 1
                repeat{
                    res = res * index
                    index = index + 1
                }while index <= op1
                return res
            }
            return nil
        },
        "sin":Operation.UnaryOp{
            op1 in
            return Decimal.init(sin(NSDecimalNumber(decimal: op1).doubleValue*isRadorisDegree))
        },
        "cos":Operation.UnaryOp{
            op1 in
            return Decimal.init(cos(NSDecimalNumber(decimal: op1).doubleValue*isRadorisDegree))
        },
        "tan":Operation.UnaryOp{
            op1 in
            return Decimal.init(tan(NSDecimalNumber(decimal: op1).doubleValue*isRadorisDegree))
        },
        "e":Operation.UnaryOp{
            op1 in
            return Decimal.init(M_E)
        },
        "EE":Operation.BinaryOp{
            (op1,op2) in
            return op1*Decimal.init(pow(10,NSDecimalNumber(decimal: op2).doubleValue))
        },
        "sinh":Operation.UnaryOp{
            op1 in
            return Decimal.init(sinh(NSDecimalNumber(decimal: op1).doubleValue))
        },
        "cosh":Operation.UnaryOp{
            op1 in
            return Decimal.init(cosh(NSDecimalNumber(decimal: op1).doubleValue))
        },
        "tanh":Operation.UnaryOp{
            op1 in
            return Decimal.init(tanh(NSDecimalNumber(decimal: op1).doubleValue))
        },
        "π":Operation.UnaryOp{
            op1 in
            return Decimal.init(.pi)
        },
        "Rand":Operation.UnaryOp{
            op1 in
            return Decimal.init(Double.random(in: 0...1))
        },
        "y^x":Operation.BinaryOp{
            (op1,op2) in
            return (pow(NSDecimalNumber(decimal: op2).doubleValue,NSDecimalNumber(decimal: op1).doubleValue) < 1e146 && pow(NSDecimalNumber(decimal: op2).doubleValue,NSDecimalNumber(decimal: op1).doubleValue) > 1e-109 ? Decimal.init(pow(NSDecimalNumber(decimal: op2).doubleValue,NSDecimalNumber(decimal: op1).doubleValue)) : nil)
        },
        "2^x":Operation.UnaryOp{
            op1 in
            return Decimal.init(pow(2.0,NSDecimalNumber(decimal: op1).doubleValue))
        },
        "log2":Operation.UnaryOp{
            op1 in
            return (op1 > 0 ? Decimal(log2(NSDecimalNumber(decimal: op1).doubleValue)) : nil)
        },
        "sin-1":Operation.UnaryOp{
            op1 in
            return ((op1 >= -1 && op1 <= 1) ? Decimal.init((asin(NSDecimalNumber(decimal: op1).doubleValue))/isRadorisDegree) : nil)
        },
        "cos-1":Operation.UnaryOp{
            op1 in
            return ((op1 >= -1 && op1 <= 1) ? Decimal.init((acos(NSDecimalNumber(decimal: op1).doubleValue))/isRadorisDegree) : nil)
        },
        "tan-1":Operation.UnaryOp{
            op1 in
            return Decimal.init((atan(NSDecimalNumber(decimal: op1).doubleValue))/isRadorisDegree)
        },
        "sinh-1":Operation.UnaryOp{
            op1 in
            return Decimal.init(asinh(NSDecimalNumber(decimal: op1).doubleValue))
        },
        "cosh-1":Operation.UnaryOp{
            op1 in
            return Decimal.init(acosh(NSDecimalNumber(decimal: op1).doubleValue))
        },
        "tanh-1":Operation.UnaryOp{
            op1 in
            return (op1 > -1 && op1 < 1 ? Decimal.init(atanh(NSDecimalNumber(decimal: op1).doubleValue)) : nil)
        },
        "logy":Operation.BinaryOp{
            (op1,op2) in
            return ((op1 > 0 && op2 > 0 && op2 != 1) ? Decimal(log(NSDecimalNumber(decimal: op1).doubleValue) / log(NSDecimalNumber(decimal: op2).doubleValue)) : nil)
        },
        "m+":Operation.MemoryOp{
            (op1,op2) in
            return op1+op2
        },
        "m-":Operation.MemoryOp{
            (op1,op2) in
            return op1-op2
        },
        "mc":Operation.MemoryOp{
            (op1,op2) in
            return 0
        },
        "mr":Operation.MemoryOp{
            (op1,op2) in
            return op1
        },
    ]
    
    struct BinaryResult
    {
        var firstop: Decimal
        var newOperation: (Decimal,Decimal)->Decimal?
        var newOp: String
        var lastPressedOp: String
    }
    
    var middleres: BinaryResult? = nil
    
    func GetOp()->String?
    {
        return middleres?.newOp
    }
    
    func changeRadorDegree(flag:Bool){
        if flag{
            isRadorisDegree = Double.pi/180
        }
        else{
            isRadorisDegree = 1.0
        }
    }
    
    func getMemory()->Bool{
        return isClear
    }
    
    func Calculate(operation: String, operand:Decimal)->Decimal?{
        if let op = operations[operation]
        {
            switch op{
                case Operation.BinaryOp(let function):
                    middleres = BinaryResult(firstop:operand,newOperation:function,newOp:operation,lastPressedOp: operation)
                    return nil
                case Operation.MemoryOp(let function):
                    Memorynum = function(Memorynum,operand)!
                    if(operation == "m+" || operation == "m-" ){
                        isClear = false
                        return operand
                    }
                    else if operation == "mc"{
                        isClear = true
                        return operand
                    }
                    else{
                        return Memorynum
                    }
                case Operation.UnaryOp(let function):
                    let res:Decimal? = function(operand)
                    print(res)
                    return res
                case Operation.EqualOp:
                    if middleres != nil{
                    var res:Decimal? =  middleres!.newOperation(middleres!.firstop,operand)
                    var res1:Decimal? =  middleres!.newOperation(operand,middleres!.firstop)
                    if middleres?.lastPressedOp != "="{
                        middleres!.firstop = operand
                        middleres!.lastPressedOp = operation
                    }
                    else{
                        print(middleres!.firstop)
                        print(operand)
                        print("res=")
                        print(res)
                        if middleres!.newOp == "/" || middleres!.newOp == "x^y" || middleres!.newOp == "y√x" || middleres!.newOp == "EE" || middleres!.newOp == "y^x" || middleres!.newOp == "logy"{
                            res = res1
                        }
                        else if middleres!.newOp == "-"{
                            res = 0 - res!
                        }
                    }
                    print(res)
                    print(1)
                    return res
                    }
                    else{
                        return operand
                    }
                
            }
        }
        return nil
    }
}
