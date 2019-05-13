//
//  Extension.swift
//  DairySaver
//
//  Created by Hsuen-Ju Li on 2019/5/7.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

extension UIFont {
    static func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        assert(font != nil, "Can't load font: \(name)")
        return font ?? UIFont.systemFont(ofSize: size)
    }
    
    static func mainFont(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "ChalkboardSE-Regular", size: size)
    }
}

extension UIView{
    convenience init(backgroundColor : UIColor){
        self.init()
        self.backgroundColor = backgroundColor
    }
}

extension UILabel{
    convenience init(text : String, font : UIFont,color: UIColor){
        self.init()
        self.text = text
        self.textColor = color
        self.font = font
    }
}

extension UITextField{
    convenience init(placeholder : String?, textColor : UIColor, font : UIFont){
        self.init()
        self.placeholder = placeholder
        self.textColor = textColor
        self.font = font
    }
}

extension UITextView{
    convenience init(textColor : UIColor, font : UIFont){
        self.init()
        self.textColor = textColor
        self.font = font
    }
}

extension UIButton{
    convenience init(backgroundColor : UIColor, title : String, titleColor : UIColor, font : UIFont, radius : CGFloat){
        self.init(type : .system)
        self.backgroundColor = backgroundColor
        self.setTitle(title,for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func  customButton(){
        self.backgroundColor = Color.theme.value
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.customFont(name: "ChalkboardSE-Bold", size: 15)
        self.layer.cornerRadius = 22
        self.layer.masksToBounds = true
    }
}

extension UIImageView{
    convenience init(imageName : String){
        self.init(image : UIImage(named: imageName))
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
}

extension UIView{
     func swipeDownDismissKeyboard(){
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDownDismissKeyboard))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }
    
    @objc func handleSwipeDownDismissKeyboard(){
        endEditing(true)
    }
}
