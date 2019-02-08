//
//  gearView.swift
//  JamMaker
//
//  Created by Hsuen-Ju Li on 2019/2/8.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class GearView : UIView{
    
    let addTitleButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Title", for: .normal)
        button.tintColor = UIColor.darkGray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    let saveButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.tintColor = UIColor.darkGray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    let separatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.3
        backgroundColor = .white
        addSubview(addTitleButton)
        addSubview(separatorView)
        addSubview(saveButton)
        
        addTitleButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 40)
        separatorView.anchor(top: addTitleButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 0.5)
        saveButton.anchor(top: separatorView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
