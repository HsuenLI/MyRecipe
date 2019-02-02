//
//  DetailHeaderCell.swift
//  JamMaker
//
//  Created by Hsuen-Ju Li on 2019/1/28.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class DetailHeaderCell : UICollectionReusableView{
    
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
        button.setImage(UIImage(named: "arrow_up")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    
    var detailsController = DetailsController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.rgb(red: 240, green: 96, blue: 98)
        setupView()
        roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 10)
    }
    
    func setupView(){
        addSubview(titleLabel)
        addSubview(arrowButton)
        
        titleLabel.anchor(top: nil, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 200, height: 0)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        arrowButton.anchor(top: nil, left: nil, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 44, height: 44)
        arrowButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func roundCorners(corners:CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    
}


