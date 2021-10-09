//
//  ViewController.swift
//  Mycalculator
//
//  Created by 吕玉龙 on 2021/10/2.
//  Copyright © 2021 吕玉龙. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var label_Clear: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.display.text! = "0"
        self.RadorDegree.text! = ""
    }

    //var result:Double
    var displaylength = 0
    var digitOndisplay: String{
        get{
            return self.display.text!
            
        }
        
        set{
            if(displaylength <= 9){
                displaylength += 1
                self.display.text! = newValue
                print(displaylength)
                print("get a new value")
            }
            //print(digitOndisplay)
        }
    }
    
    var isdegree = true
    var intypingmode = false
    var doubledot = true
    var preciseNum:Decimal = 0

    @IBAction func NumberTouched(_ sender: UIButton) {
        if intypingmode{
            
            if doubledot == false && sender.currentTitle! == "."{
            }
            else{
                digitOndisplay = digitOndisplay + sender.currentTitle!
                preciseNum = Decimal.init(string:digitOndisplay)!
                print(preciseNum)
            }
            if sender.currentTitle! == "."{
                doubledot = false
            }
        }
        else{
            if sender.currentTitle! == "."{
            }
            else{
                if digitOndisplay == "fault"{
                    digitOndisplay = "0"
                    displaylength = 0
                    preciseNum = Decimal(0)
                }
                digitOndisplay = sender.currentTitle!
                preciseNum = Decimal.init(string:digitOndisplay)!
                intypingmode = true
                label_Clear.setTitle("C", for: .normal)
            }
        }
    }
    @IBAction func ClearOperation(_ sender: UIButton) {
        intypingmode = false
        displaylength = 0
        doubledot = true
        digitOndisplay = "0"
        preciseNum = 0
        displaylength = 0
        label_Clear.setTitle("AC", for: .normal)
    }
    
    @IBOutlet weak var label_RadorDegree: UIButton!
    @IBOutlet weak var RadorDegree: UILabel!
    
    @IBOutlet weak var label_ex: UIButton!
    @IBOutlet weak var label_10x: UIButton!
    @IBOutlet weak var label_ln: UIButton!
    @IBOutlet weak var label_log10: UIButton!
    @IBOutlet weak var label_sin: UIButton!
    @IBOutlet weak var label_cos: UIButton!
    @IBOutlet weak var label_tan: UIButton!
    @IBOutlet weak var label_sinh: UIButton!
    @IBOutlet weak var label_cosh: UIButton!
    @IBOutlet weak var label_tanh: UIButton!
    var changeflag = true
    @IBOutlet weak var label_mr: UIButton!
    
    @IBAction func ChangeLabel(_ sender: UIButton) {
        print("2nd pressed")
        if changeflag{
            label_ex.setTitle("y^x", for: .normal)
            label_10x.setTitle("2^x", for: .normal)
            label_ln.setTitle("logy", for: .normal)
            label_log10.setTitle("log2", for: .normal)
            label_sin.setTitle("sin-1", for: .normal)
            label_cos.setTitle("cos-1", for: .normal)
            label_tan.setTitle("tan-1", for: .normal)
            label_sinh.setTitle("sinh-1", for: .normal)
            label_sinh.titleLabel?.font = UIFont.systemFont(ofSize: 22)
            label_cosh.setTitle("cosh-1", for: .normal)
            label_cosh.titleLabel?.font = UIFont.systemFont(ofSize: 22)
            label_tanh.setTitle("tanh-1", for: .normal)
            label_tanh.titleLabel?.font = UIFont.systemFont(ofSize: 22)
            changeflag = false
        }
        else{
            label_ex.setTitle("e^x", for: .normal)
            label_10x.setTitle("10^x", for: .normal)
            label_ln.setTitle("ln", for: .normal)
            label_log10.setTitle("log10", for: .normal)
            label_sin.setTitle("sin", for: .normal)
            label_cos.setTitle("cos", for: .normal)
            label_tan.setTitle("tan", for: .normal)
            label_sinh.setTitle("sinh", for: .normal)
            label_cosh.setTitle("cosh", for: .normal)
            label_tanh.setTitle("tanh", for: .normal)
            changeflag = true
        }
    }
    
    let calculator = Calculator()
    @IBAction func Rad2Degree(_ sender: UIButton) {
        if isdegree{
            isdegree = false
            RadorDegree.text! = "Rad"
            label_RadorDegree.setTitle("Deg", for: .normal)
            calculator.changeRadorDegree(flag:isdegree)
        }
        else{
            isdegree = true
            RadorDegree.text! = ""
            label_RadorDegree.setTitle("Rad", for: .normal)
            calculator.changeRadorDegree(flag:isdegree)
        }
    }
    
    
    @IBAction func OperationTouched(_ sender: UIButton) {
        print("operation \(sender.currentTitle!) touched")
        if let op = sender.currentTitle {
            if digitOndisplay != "fault"{
                if let result = calculator.Calculate(operation: op, operand: preciseNum){
                    /*if Double(digitOndisplay) == 0 && calculator.GetOp() == "/" && op != "+/-" && op != "%" && op != "e^x" && op != "10^x" && op != "x^2" && op != "x^3" && op != "x!" && op != "e" && op != "2^x"{
                        digitOndisplay = "fault"
                    }//xiugai
                    else{*/
                        var memoryclear = calculator.getMemory()
                        if memoryclear{
                            label_mr.backgroundColor = UIColor.separator
                        }
                        else{
                            label_mr.backgroundColor = UIColor.gray
                        }
                        preciseNum = result
                        if result < 1e10 && result > -1e10{
                            print("one")
                            print(NSDecimalNumber(decimal: result).decimalValue)
                            if result.exponent < -8{
                                let number:NSNumber = NSNumber(value: NSDecimalNumber(decimal: result).doubleValue)
                                print(number)
                                let numberformat = NumberFormatter()
                                numberformat.numberStyle = .scientific
                                numberformat.maximumSignificantDigits = 8
                                print("bad")
                                
                                let string1 = numberformat.string(from: number)!
                                //print(numberformat.number(from: string1)!)
                                //print(Decimal.init(string:string1)!.exponent)
                                print("time \(string1)")
                                displaylength = 0
                                digitOndisplay = string1
                                print("numberstring : \(numberformat.string(from: number)!)")
                                
                            }
                            else{
                                print("try")
                                displaylength = 0
                                digitOndisplay = NSDecimalNumber(decimal: result).stringValue
                                print(digitOndisplay)
                            }
                            
                        }
                        else{
                            let number:NSNumber = NSNumber(value: NSDecimalNumber(decimal: result).doubleValue)
                            let numberformat = NumberFormatter()
                            numberformat.numberStyle = .scientific
                            numberformat.maximumSignificantDigits = 8
                            displaylength = 0
                            digitOndisplay = numberformat.string(from: number)!
                        }
                    //}
                }
                else{
                    if op == "=" || op == "1/x" || op == "2√x" || op == "ln" || op == "log10" || op == "x!" || op == "log2" || op == "tanh-1" || op == "sin-1" || op == "cos-1" || op == "10^x" || op == "e^x" {
                        digitOndisplay = "fault"
                    }
                }
            }
            intypingmode = false
            displaylength = 0
            print("displaylength : \(displaylength)")
            doubledot = true
        }
    }

}
