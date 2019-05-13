//
//  ColorAndUIColorExtention.swift
//  AppCodaMVC
//
//  Created by Hsuen-Ju Li on 2019/4/28.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

extension UIColor {
    
    /**
     Creates an UIColor from HEX String in "#363636" format
     
     - parameter hexString: HEX String in "#363636" format
     - returns: UIColor from HexString
     */
    convenience init(hexString: String) {
        
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner          = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    /**
     Creates an UIColor Object based on provided RGB value in integer
     - parameter red:   Red Value in integer (0-255)
     - parameter green: Green Value in integer (0-255)
     - parameter blue:  Blue Value in integer (0-255)
     - returns: UIColor with specified RGB values
     */
    convenience init(r: Int, g: Int, b: Int) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
}

enum Color{
    
    case theme
    case subtitle
    case textColor
    case borderColor
    case customOrange
    case customGreen
    case customRed
    

}

extension Color{

    var value : UIColor{
        var instanceColor = UIColor.clear

        switch self {
        case .theme:
            instanceColor = UIColor(hexString: "#6ED0F3")
        case .subtitle:
            instanceColor = UIColor(r: 137, g: 137, b: 137)
        case . textColor:
            instanceColor = UIColor(hexString: "#4A4A4A")
        case .borderColor:
            instanceColor = UIColor(hexString: "#D2D2D2")
        case . customOrange:
            instanceColor = UIColor(hexString: "#EE9A40")
        case .customRed:
            instanceColor = UIColor(hexString: "#E98888")
        case .customGreen:
            instanceColor = UIColor(hexString: "#60BF89")
        }
        return instanceColor
    }
}
