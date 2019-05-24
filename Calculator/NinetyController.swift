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
    let MAX_LENGTH: Int = {
        return Helper.screenWidth > 320 ? 9 : 7
    }()
    var MAX_VALUE: Float = {
        return Helper.screenWidth > 320 ? 999999999 : 9999999 // MAX_LENGTH 个 9
    }()
    
    let backgroundImage_Focused: UIImage = Helper.createImageWithColor(color: UIColor.init(red: 225/255, green: 64/255, blue: 66/255, alpha: 1))
    
    @IBOutlet weak var monitor: UILabel!
    @IBOutlet weak var keyborads: UIStackView!
    var currentSymbol = "ADD"
    var number1 = "0" // saved one
//    var number2 = ""  // current shows
    var needClear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initStyleForButtons()     // red background color
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
    func initStyleForButtons () {
        let border_length = (Helper.screenWidth - 6) / 4
        let border_length_0 = border_length * 2 + 2
        for line in keyborads.arrangedSubviews {
            let lineStack = line as! UIStackView
            for button in lineStack.arrangedSubviews {
                let b = button as! UIButton
                b.setBackgroundImage(self.backgroundImage_Focused, for: UIControl.State.highlighted)
                // for constraint width
                if b.currentTitle == "0" {
                    b.frame = CGRect(x: 0, y: 0, width: border_length, height: border_length)
                    let constraintButtonWidth = NSLayoutConstraint (item: b,
                                                                    attribute: NSLayoutConstraint.Attribute.width,
                                                                    relatedBy: NSLayoutConstraint.Relation.equal,
                                                                    toItem: nil,
                                                                    attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                                    multiplier: 1,
                                                                    constant: border_length_0)
                    lineStack.addConstraint(constraintButtonWidth)
                } else {
                    b.frame = CGRect(x: 0, y: 0, width: border_length, height: border_length)
                    let constraintButtonWidth = NSLayoutConstraint (item: b,
                                                                    attribute: NSLayoutConstraint.Attribute.width,
                                                                    relatedBy: NSLayoutConstraint.Relation.equal,
                                                                    toItem: nil,
                                                                    attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                                    multiplier: 1,
                                                                    constant: border_length)
                    lineStack.addConstraint(constraintButtonWidth)
                }
                // for constraint height
                let constraintButtonHeight = NSLayoutConstraint (item: b,
                                                                 attribute: NSLayoutConstraint.Attribute.height,
                                                                 relatedBy: NSLayoutConstraint.Relation.equal,
                                                                 toItem: nil,
                                                                 attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                                 multiplier: 1,
                                                                 constant: border_length)
                lineStack.addConstraint(constraintButtonHeight)
            }
        }
    }
}

// for monitor view
extension NinetyController {
    // max number size: 7
    func addNumber(number: String) {
        self.clearIfNeed()
        var text = self.fetchCurrentText()
        var tempAppendString = number
        if text.count >= MAX_LENGTH {
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
        let number1 = Float(str_number1) ?? Float.random(in: 0..<MAX_VALUE)
        let number2 = str_number2 == "爱你心童" ? 52092 : Float(str_number2) ?? Float.random(in: 0..<MAX_VALUE)
        let result = self.calculate(operator: self.currentSymbol, num1: number1, num2: number2)
        self.reset(text: result)
        self.number1 = result
        self.needClear = true
    }
    private func calculate(operator: String, num1: Float, num2: Float) -> String {
        switch num2 {
            case 520:
                return "ILOVEU"
            case 92:
                return "爱你心童"
            case 52092:
                return "5201314"
            case 1314:
                return "FOREVER"
            case 5201314:
                let pres = ["ILOVEU", "FOREVER", "KISS!", "HUG~~", "It's ME", "DO IT!", "SMILE~", "LOVE U", "MISS U..", "抱抱～"]
                let index = Int.random(in: 0..<pres.count)
                return pres[index]
            default:
                break
        }
        // by default:
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
        return result.count >= MAX_LENGTH ? result[0..<MAX_LENGTH] : result
    }
    private func toIntIfAble(number: Int) -> String {
        let result = String(number)
        return result.count >= MAX_LENGTH ? result[0..<MAX_LENGTH] : result
    }
    private func result(number: Float) -> String {
        if number > MAX_VALUE {
            return String(number)[0..<MAX_LENGTH]
        }
        let result = self.toIntIfAble(number: number)
        if self.WRONG_WORLD {
//            print(result.hashValue)
//            print(result.hash)
//            return self.toIntIfAble(number: result.hash / 999) // TODO! 需要一个全新的算法去随机这玩意儿
            return self.hash(text: result)
        }
        return result
    }
    private func result(number: Int) -> String {
        return result(number: Float(number))
    }
}

extension NinetyController {
    func hash(text: String) -> String {
        return hash(text: text.hash, length: text.count)
    }
    func hash(text: Int, length: Int) -> String {
        let number_length = length_it(number: text)
        var loop_length = number_length > length ? length : number_length
        loop_length = loop_length > 7 ? loop_length / 2 : loop_length
        var current = text
        var queue: [Int] = []
        while(loop_length > 0) {
            let value = current - current / 10 * 10
            current /= 10
            loop_length -= 1
            queue.append(value)
        }
        var sum = 0
        for i in 0..<queue.count {
            let pow_ = pow(10, i)
            let value = queue[queue.count - i - 1] * Int(truncating: NSDecimalNumber(decimal: pow_))
            sum += value
        }
        if sum < 9 {
            sum = Int.random(in: 0..<9)
        }
        return String(sum)
    }
    func length_it(number: Int) -> Int {
        var count = 0
        var current = number
        while(current > 0) {
            current /= 10
            count += 1
        }
        return count
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
    // Screen width.
    public static var screenWidth: CGFloat {
        print("WIDTH:: \(UIScreen.main.bounds.width)")
        return UIScreen.main.bounds.width
    }
    
    // Screen height.
    public static var screenHeight: CGFloat {
        print("HEIGHT:: \(UIScreen.main.bounds.height)")
        return UIScreen.main.bounds.height
    }
    
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
