//
//  AddNewRecipeHeader.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/14.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

protocol AddNewRecipeHeaderDelegate {
    func didTapHeaderImageButtonAddImaage()
    func didTypeRecipeTitle(title : String)
}

class AddNewRecipeHeader : UICollectionReusableView{
    
    var addDelegate : AddNewRecipeHeaderDelegate?
    
    //Outlets
    lazy var headerImageButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Tap to add image", for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font =  UIFont.customFont(name: "AvenirNext-Bold", size: 15)
        btn.backgroundColor = UIColor(r: 245, g: 245, b: 245)
        btn.setTitleColor(Color.textColor.value, for: .normal)
        btn.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(handleHeaderImageButton), for: .touchUpInside)
        return btn
    }()
    
    let titleLabel = UILabel(text: "Title: ", font: UIFont.customFont(name: "AvenirNext-Regular", size: 13), color: Color.textColor.value)
    let titleTextFiled = UITextField(placeholder: "Give a delicious name for recipe", textColor: Color.textColor.value, font: UIFont.customFont(name: "AvenirNext-Regular", size: 15))
    let separator = UIView(backgroundColor: Color.borderColor.value)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerImageButton)
        let height : CGFloat = self.frame.width / 16 * 9
        headerImageButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,size : .init(width: 0, height: height))
        
        addSubview(titleLabel)
        titleLabel.anchor(top: headerImageButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 26, left: 26, bottom: 0, right: 26),size: .init(width: 0, height: 18))
        
        addSubview(titleTextFiled)
        titleTextFiled.delegate = self
        titleTextFiled.returnKeyType = .done
        titleTextFiled.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 2, left: 34, bottom: 0, right: 35),size: .init(width: 0, height: 20))
        
        addSubview(separator)
        separator.anchor(top: bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 34, bottom: 0, right: 35),size: .init(width: 0, height: 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddNewRecipeHeader : UITextFieldDelegate{
    @objc func handleHeaderImageButton(){
        addDelegate?.didTapHeaderImageButtonAddImaage()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {return false}
        addDelegate?.didTypeRecipeTitle(title: text)
        return true
    }
}
