//
//  DetailHeaderCell.swift
//  JamMaker
//
//  Created by Hsuen-Ju Li on 2019/1/28.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class DetailHeaderCell : UICollectionViewCell{
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Ingredient"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.white
        return label
    }()
    
    let arrowButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.setImage(UIImage(named: "arrow_down")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.rgb(red: 240, green: 96, blue: 98)
        roundCorners(corners: [.topLeft, .topRight] , radius: 5)
        
        addSubview(titleLabel)
        addSubview(arrowButton)
        
        titleLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        arrowButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 44, height: 44)
        arrowButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
