//
//  HomeOptionsView.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/2/20.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

protocol HomeOptionsViewDelegate {
    func didTapOptionsButtons(sender : UIButton)
}
class HomeOptionsView : UIView{
    
    var delegate : HomeOptionsViewDelegate?
    //buttons
    lazy var editButton : UIButton = {
        let button = UIButton(type : .system)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        button.backgroundColor = Color.theme.value
        button.layer.borderWidth = 0.1
        button.tag = 0
        button.addTarget(self, action: #selector(handleOptionButtons(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var  deleteButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Del", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        button.backgroundColor = Color.customRed.value
        button.layer.borderWidth = 0.1
        button.tag = 1
        button.addTarget(self, action: #selector(handleOptionButtons(sender:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Color.borderColor.value
        layer.borderWidth = 0.5
        layer.borderColor = Color.borderColor.value.cgColor
        deleteButton.constrainWidth(constant: 44)
        deleteButton.constrainHeight(constant: 44)
        editButton.constrainHeight(constant: 44)
        editButton.constrainWidth(constant: 44)
        let buttonsStackView = UIStackView(arrangedSubviews: [deleteButton,editButton])
        addSubview(buttonsStackView)
        buttonsStackView.alignment = .center
        buttonsStackView.spacing = 10
        buttonsStackView.centerInSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleOptionButtons(sender : UIButton){
        delegate?.didTapOptionsButtons(sender: sender)
    }
}
