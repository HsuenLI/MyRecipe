//
//  HomeOptionsView.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/2/20.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class HomeOptionsView : UIView{
    
    //buttons
    let editButton : UIButton = {
        let button = UIButton(type : .system)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.backgroundColor = .white
        button.layer.borderWidth = 0.1
        return button
    }()
    
    let deleteButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.backgroundColor = .white
        button.layer.borderWidth = 0.1
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(editButton)
        editButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 2, width: 60, height: 60)
        addSubview(deleteButton)
        deleteButton.anchor(top: editButton.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 2, width: 60, height: 60)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
