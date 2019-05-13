//
//  File.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/14.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class HomeEmptyView : UIView {
    
    let titleLabel = UILabel(text: "Press ADD Button to add new recipe", font: UIFont.customFont(name: "BradleyHandITCTT-Bold", size: 25), color: Color.textColor.value)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        titleLabel.constrainWidth(constant: 300)
        titleLabel.constrainHeight(constant: 300)
        titleLabel.centerInSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
