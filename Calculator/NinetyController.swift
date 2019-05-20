//
//  NinetyController.swift
//  Calculator
//
//  Created by 小亦 on 21/5/2019.
//  Copyright © 2019 小亦. All rights reserved.
//

import UIKit

class NinetyController: UIViewController {
    let WRONG_WORLD = true
    
    let backgroundImage_Focused: UIImage = Helper.createImageWithColor(color: UIColor.init(red: 225/255, green: 64/255, blue: 66/255, alpha: 1))
    
    @IBOutlet weak var monitor: UILabel!
    @IBOutlet weak var keyborads: UIStackView!
    var currentSymbol = "ADD"
    var number1 = "0" // saved one
//    var number2 = ""  // current shows
    var needClear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initBackgroundColorForButtons()     // red background color
        self.monitor.textAlignment = .right // align right
    }
    
    @IBAction func tb1(_ sender: Any) {
        self.addNumber(number: "1")
    }
    @IBAction func tb2(_ sender: Any) {
        self.addNumber(number: "2")
    }
    @IBAction func tb3(_ sender: Any) {
        self.addNumber(number: "3")
    }
    @IBAction func tb4(_ sender: Any) {
        self.addNumber(number: "4")
    }
    @IBAction func tb5(_ sender: Any) {
        self.addNumber(number: "5")
    }
    @IBAction func tb6(_ sender: Any) {
        self.addNumber(number: "6")
    }
    @IBAction func tb7(_ sender: Any) {
        self.addNumber(number: "7")
    }
    @IBAction func tb8(_ sender: Any) {
        self.addNumber(number: "8")
    }
    @IBAction func tb9(_ sender: Any) {
        self.addNumber(number: "9")
    }
    @IBAction func tb0(_ sender: Any) {
        self.addNumber(number: "0")
    }
    @IBAction func tbDot(_ sender: Any) {
        self.addNumber(number: ".")
    }
    @IBAction func tbEqual(_ sender: Any) {
        self.done()
    }
    @IBAction func tbPlus(_ sender: Any) {
        self.setSymobl(symbol: "ADD")
    }
    @IBAction func tbMinus(_ sender: Any) {
        self.setSymobl(symbol: "MIS")
    }
    @IBAction func tbMultip(_ sender: Any) {
        self.setSymobl(symbol: "MUL")
    }
    @IBAction func tbDivide(_ sender: Any) {
        self.setSymobl(symbol: "DIV")
    }
    @IBAction func tbMod(_ sender: Any) {
        self.setSymobl(symbol: "MOD")
    }
    
    @IBAction func tb_Clear(_ sender: Any) {
        self.forceClear()
    }
    @IBAction func tb_Negitv(_ sender: Any) {
        self.switchNgiv()
    }
    
}


extension NinetyController {
    func initBackgroundColorForButtons () {
        for line in keyborads.arrangedSubviews {
            let lineStack = line as! UIStackView
            for button in lineStack.arrangedSubviews {
                let b = button as! UIButton
                b.setBackgroundImage(self.backgroundImage_Focused, for: UIControl.State.highlighted)
            }
        }
    }
}

// for monitor view
extension NinetyController {
    // max number size: 9
    func addNumber(number: String) {
        self.clearIfNeed()
        var text = self.fetchCurrentText()
        var tempAppendString = number
        if text.count >= 9 {
            return
        }
        if number == "." && text.contains(".") {
            return
        }
        if text == "0" {
            text = ""
        }
        if number == "." && text == "" {
            tempAppendString = "0."
        }
        self.reset(text: text + tempAppendString)
    }
    func switchNgiv() {
        let text = self.fetchCurrentText()
        if text == "0" {
            return
        }
        if text.starts(with: "-") {
//            let index = text.index(text.startIndex, offsetBy: 1)
            self.reset(text: text[1..<text.count])
        } else {
            self.reset(text: "-" + text)
        }
    }
    func forceClear() {
        self.monitor.text = "0"
        self.number1 = "0"
    }
    func clearIfNeed() {
        if self.needClear {
            self.monitor.text = "0"
            self.needClear = false
        }
    }
    
    func fetchCurrentText() -> String {
        return self.monitor.text!
    }
    func reset(text: String) {
        self.clearIfNeed()
        self.monitor.text = text
    }
}

// for symbol & equal cal
extension NinetyController {
    func setSymobl(symbol: String) {
        self.currentSymbol = symbol
        self.number1 = self.fetchCurrentText()
        self.needClear = true
    }
    func done() {
        let str_number1 = self.number1
        let str_number2 = self.fetchCurrentText()
        let number1 = Float(str_number1) ?? 0
        let number2 = Float(str_number2) ?? 0
        let result = self.calculate(operator: self.currentSymbol, num1: number1, num2: number2)
        self.reset(text: result)
        self.number1 = result
        self.needClear = true
    }
    private func calculate(operator: String, num1: Float, num2: Float) -> String {
        switch(`operator`) {
            case "ADD": return self.result(number: num1 + num2)
            case "MIS": return self.result(number: num1 - num2)
            case "MUL": return self.result(number: num1 * num2)
            case "DIV":
                if num2 == 0 { return "0"}
                return self.result(number: num1 / num2)
            case "MOD":
                if num2 == 0 { return "0"}
                return self.result(number: Int(num1) % Int(num2))
            default: return "0"
        }
    }
    private func toIntIfAble(number: Float) -> String {
        let number_int = Int(floor(number))
        var result = ""
        if Float(number_int) == number {
            result = String(number_int)
        } else {
//            return String(format: "%.2f", number)
            result = String(number)
        }
        return result.count >= 9 ? result[0..<9] : result
    }
    private func toIntIfAble(number: Int) -> String {
        let result = String(number)
        return result.count >= 9 ? result[0..<9] : result
    }
    private func result(number: Float) -> String {
        if number > 999999999 {
           return String(999999999)
        }
        let result = self.toIntIfAble(number: number)
        if self.WRONG_WORLD {
//            print(result.hashValue)
//            print(result.hash)
            return self.toIntIfAble(number: result.hash / 999) // TODO! 需要一个全新的算法去随机这玩意儿
        }
        return result
    }
    private func result(number: Int) -> String {
        return result(number: Float(number))
    }
}

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
}

class Helper {
    static func createImageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage!
    }
}
