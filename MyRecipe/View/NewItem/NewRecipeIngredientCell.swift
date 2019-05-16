//
//  NewRecipeIngredientCell.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/14.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

protocol NewRecipeIngredientCellDeleagate {
    func didTypeTextAddIngredient(text : String , button : UIButton, cell : NewRecipeIngredientCell)
}

class NewRecipeIngredientCell : UICollectionViewCell, UITextFieldDelegate{
    
    var source : Source!{
        didSet{
            ingredientTextfield.text = source.ingredients
            guard let image = source.checked ? "cellSave" : "cellUnsave" else {return}
            checkButton.setImage(UIImage(named: image), for: .normal)
        }
    }
    
    var ingredientDelegate : NewRecipeIngredientCellDeleagate?
    let ingredientTextfield = UITextField(placeholder: "Enter your ingredient", textColor: Color.textColor.value, font: UIFont.customFont(name: ("AvenirNext-Regular"), size: 13))
    lazy var checkButton : UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setImage(UIImage(named: "cellUnsave"), for: .normal)
        btn.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        btn.tag = 1
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(checkButton)
        checkButton.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 45),size: .init(width: 18, height: 18))
        checkButton.centerYInSuperview()
        addSubview(ingredientTextfield)
        ingredientTextfield.returnKeyType = .done
        ingredientTextfield.addTarget(self, action: #selector(handleTextDidChaged(sender:)), for: .editingChanged)
        ingredientTextfield.delegate = self
        ingredientTextfield.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: checkButton.leadingAnchor,padding: .init(top: 0, left: 45, bottom: 0, right: 10))
        let separator = UIView(backgroundColor: Color.borderColor.value)
        addSubview(separator)
        separator.anchor(top: bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 45, bottom: 0, right: 45),size: .init(width: 0, height: 0.5))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientTextfield.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.endEditing(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleSaveButton(sender : UIButton){
        guard let text = ingredientTextfield.text else {return }
        ingredientDelegate?.didTypeTextAddIngredient(text: text, button: sender, cell: self)
    }
    
    @objc func handleTextDidChaged(sender : UITextField){
        if let text = sender.text{
            if text.count == 0{
                let attributedText = NSMutableAttributedString(string: "Please type ingredient before add another", attributes: [NSAttributedString.Key.foregroundColor : Color.customRed.value])
                sender.attributedPlaceholder = attributedText
                checkButton.isHidden = true
            }else{
                checkButton.isHidden = false
            }
        }
    }
}
