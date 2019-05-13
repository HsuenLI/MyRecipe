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
        backgroundColor = UIColor(r: 240, g: 96, b: 98)
        setupView()
        roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 10)
    }
    
    func setupView(){
        addSubview(titleLabel)
        addSubview(arrowButton)
        
        titleLabel.anchor(top: nil, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 0, left: 8, bottom: 0, right: 0),size: .init(width: 200, height: 0))
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        arrowButton.anchor(top: nil, leading: nil, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 8),size: .init(width: 44, height: 44))
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


