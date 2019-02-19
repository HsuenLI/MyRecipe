//
//  NewItemHeader.swift
//  JamMaker
//
//  Created by Hsuen-Ju Li on 2019/2/2.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class NewItemHeader : DetailHeaderCell {
    
    let addButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "add_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    var newItemController = NewItemController()
    
    override func setupView() {
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 200, height: 0)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubview(addButton)
        addButton.anchor(top: nil, left: nil, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 44, height: 44)
        addButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
