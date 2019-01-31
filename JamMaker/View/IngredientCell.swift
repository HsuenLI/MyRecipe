//
//  DetailsCell.swift
//  JamMaker
//
//  Created by Hsuen-Ju Li on 2019/1/29.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class IngredientCell : UICollectionViewCell {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Something"
        label.numberOfLines = 0
        return label
    }()
    
    let inputLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "1 tp"
        label.textAlignment = .center
        label.textColor = UIColor.gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(inputLabel)
        backgroundColor = .white
        titleLabel.anchor(top: nil, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: inputLabel.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        inputLabel.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 80, height: 0)
        inputLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}