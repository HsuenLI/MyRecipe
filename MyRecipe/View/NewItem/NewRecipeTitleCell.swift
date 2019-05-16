//
//  NewRecipeTitleCell.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/15.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

protocol NewRecipeTitleCellDelegate {
    func didTapHeaderImageButtonAddImaage()
    func didTypeRecipeTitle(textFiled : UITextField)
    func didSelectLevel(button : UIButton)
}

class NewRecipeTitleCell : UICollectionViewCell{
    
    var newRecipeController : NewRecipeController?
    var addDelegate : NewRecipeTitleCellDelegate?
    
    //Outlets
    lazy var headerImageButton : UIButton = {
        let btn = UIButton()
        let attributedText = NSMutableAttributedString(string: "Tap to add image", attributes: [NSAttributedString.Key.font :  UIFont.customFont(name: "AvenirNext-Bold", size: 15), NSAttributedString.Key.foregroundColor : Color.textColor.value])
        attributedText.append(NSAttributedString(string: "*", attributes: [NSAttributedString.Key.foregroundColor : Color.customRed.value,NSAttributedString.Key.font :  UIFont.customFont(name: "AvenirNext-Bold", size: 15)]))
        btn.setAttributedTitle(attributedText, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font =  UIFont.customFont(name: "AvenirNext-Bold", size: 15)
        btn.backgroundColor = UIColor(r: 245, g: 245, b: 245)
        btn.setTitleColor(Color.textColor.value, for: .normal)
        btn.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(handleHeaderImageButton), for: .touchUpInside)
        return btn
    }()
    
    let titleLabel = UILabel()
    let titleTextFiled = UITextField(placeholder: "Give a delicious name for recipe", textColor: Color.textColor.value, font: UIFont.customFont(name: "AvenirNext-Regular", size: 15))
    
    let levelLabel = UILabel(text: "Level: ", font: UIFont.customFont(name: "AvenirNext-Regular", size: 13), color: Color.textColor.value)
    let easyButton = UIButton(backgroundColor: .white, title: "EASY", titleColor: Color.customRed.value, font: UIFont.customFont(name: "AvenirNext-Regular", size: 13), radius: 5)
    let mediumButton = UIButton(backgroundColor: .white, title: "Medium", titleColor: Color.customRed.value, font: UIFont.customFont(name: "AvenirNext-Regular", size: 13), radius: 5)
        let hardButton = UIButton(backgroundColor: .white, title: "Hard", titleColor: Color.customRed.value, font: UIFont.customFont(name: "AvenirNext-Regular", size: 13), radius: 5)
    let separator = UIView(backgroundColor: Color.borderColor.value)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerImageButton)
        let height : CGFloat = self.frame.width / 16 * 9
        headerImageButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,size : .init(width: 0, height: height))
        
        addSubview(titleLabel)
        let attributedText = NSMutableAttributedString(string: "Title: ", attributes: [NSAttributedString.Key.font :  UIFont.customFont(name: "AvenirNext-Regular", size: 13), NSAttributedString.Key.foregroundColor : Color.textColor.value])
        attributedText.append(NSAttributedString(string: "*", attributes: [NSAttributedString.Key.foregroundColor : Color.customRed.value,NSAttributedString.Key.font :  UIFont.customFont(name: "AvenirNext-Regular", size: 13)]))
        titleLabel.attributedText = attributedText
        titleLabel.anchor(top: headerImageButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 26, left: 26, bottom: 0, right: 26),size: .init(width: 0, height: 18))
        
        addSubview(titleTextFiled)
        titleTextFiled.delegate = self
        titleTextFiled.addTarget(self, action: #selector(handleTextFieldEdit(sender:)), for: .editingChanged)
        titleTextFiled.returnKeyType = .done
        titleTextFiled.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 2, left: 34, bottom: 0, right: 35),size: .init(width: 0, height: 20))
        
        let stackView = UIStackView(arrangedSubviews: [levelLabel,easyButton,mediumButton,hardButton])
        easyButton.tag = 1
        easyButton.addTarget(self, action: #selector(handleLevelButtons), for: .touchUpInside)
        mediumButton.tag = 2
        mediumButton.addTarget(self, action: #selector(handleLevelButtons), for: .touchUpInside)
        hardButton.tag = 3
        hardButton.addTarget(self, action: #selector(handleLevelButtons), for: .touchUpInside)
        
        addSubview(stackView)
        stackView.distribution = .fillEqually
        stackView.anchor(top: titleTextFiled.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 5, left: 26, bottom: 0, right: 26),size: .init(width: 0, height: 18))
        
        
        addSubview(separator)
        separator.anchor(top: bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 34, bottom: 0, right: 35),size: .init(width: 0, height: 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewRecipeTitleCell : UITextFieldDelegate{
    @objc func handleHeaderImageButton(){
        addDelegate?.didTapHeaderImageButtonAddImaage()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    @objc func handleTextFieldEdit(sender : UITextField){
        if let text = sender.text{
            if text.count > 0{
                addDelegate?.didTypeRecipeTitle(textFiled: sender)
            }else{
                let attributedText = NSMutableAttributedString(string: "Please give a title for recipe", attributes: [NSAttributedString.Key.foregroundColor : Color.customRed.value])
                sender.attributedPlaceholder = attributedText
                newRecipeController?.removeNavigationRightItme()
            }
        }

    }
    
    @objc func handleLevelButtons(sender : UIButton){
        let buttons = [easyButton,mediumButton,hardButton]
        for button in buttons{
            if sender.tag == button.tag{
                button.setTitleColor(Color.theme.value, for: .normal)
                addDelegate?.didSelectLevel(button: sender)
            }else{
                button.setTitleColor(Color.customRed.value, for: .normal)
            }
        }
    }
}

