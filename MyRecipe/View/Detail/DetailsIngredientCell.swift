//
//  DetailsIngredientCell.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/16.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class DetailsIngredientCell : UICollectionViewCell{
    
    var ingredient : Ingredient!{
        didSet{
            ingredientLabel.text = ingredient.input
        }
    }
    
    let ingredientLabel = UILabel(text: "", font: UIFont.customFont(name: "AvenirNext-Regular", size: 13), color: Color.textColor.value)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ingredientLabel)
        ingredientLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 18, bottom: 0, right: 18))
        let separator = UIView(backgroundColor: Color.borderColor.value)
        addSubview(separator)
        separator.anchor(top: bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 18, bottom: 0, right: 18), size: .init(width: 0, height: 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
