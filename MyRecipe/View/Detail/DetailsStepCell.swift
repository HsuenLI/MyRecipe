//
//  DetailsStepCell.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/16.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class DetailsStepCell : UICollectionViewCell{
    
    var step : Step!{
        didSet{
            guard let imageData = step.image else {return}
            stepImageView.image = UIImage(data: imageData)
            textView.text = step.text
        }
    }
    
    let stepImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView : UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isSelectable = false
        tv.textColor = Color.textColor.value
        tv.isScrollEnabled = false
        tv.font = UIFont.customFont(name: "AvenirNext-Regular", size: 13)
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stepImageView)
        let imageHeight : CGFloat = self.frame.width / 16 * 9
        stepImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,size: .init(width: frame.width, height: imageHeight))
        addSubview(textView)
        textView.anchor(top: stepImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 5, left: 18, bottom: 5, right: 18))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
