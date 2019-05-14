//
//  NewRecipeIngredientCell.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/14.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

protocol NewRecipeIngredientCellDeleagate {
    func didTypeTextAddIngredient(text : String , cell : NewRecipeIngredientCell)
}

class NewRecipeIngredientCell : UICollectionViewCell, UITextFieldDelegate{
    
    var ingredientDeleage : NewRecipeIngredientCellDeleagate?
    let textfiled = UITextField(placeholder: "Enter your ingredient", textColor: Color.textColor.value, font: UIFont.customFont(name: ("AvenirNext-Regular"), size: 13))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textfiled)
        textfiled.returnKeyType = .done
        textfiled.delegate = self
        textfiled.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 45, bottom: 0, right: 45))
        let separator = UIView(backgroundColor: Color.borderColor.value)
        addSubview(separator)
        separator.anchor(top: bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 45, bottom: 0, right: 45),size: .init(width: 0, height: 0.5))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfiled.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textfiled.text else {return}
        ingredientDeleage?.didTypeTextAddIngredient(text: text, cell: self)
        self.endEditing(true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
