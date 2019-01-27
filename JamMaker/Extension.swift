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
}


class CustomCell : UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        backgroundColor = UIColor.rgb(red: 240, green: 96, blue: 98)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
