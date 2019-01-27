//
//  Extension.swift
//  JamMaker
//
//  Created by Hsuen-Ju Li on 2019/1/27.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

extension UIColor{
    static func rgb(red : CGFloat, green : CGFloat, blue : CGFloat) -> UIColor{
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    static func customTextColor() -> UIColor{
        return UIColor.rgb(red: 233, green: 206, blue: 111)
    }
}


class CustomCell : UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        backgroundColor = UIColor.rgb(red: 240, green: 96, blue: 98)
        setupView()
    }
    
    func setupView(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UIView{
    func anchor(top : NSLayoutYAxisAnchor?, left : NSLayoutXAxisAnchor?, bottom : NSLayoutYAxisAnchor?, right : NSLayoutXAxisAnchor?, paddingTop : CGFloat, paddingLeft : CGFloat, paddingBottom : CGFloat, paddingRight : CGFloat, width : CGFloat, height : CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left{
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom{
            bottom.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right{
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0{
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0{
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func fullConstraint(){
        anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
