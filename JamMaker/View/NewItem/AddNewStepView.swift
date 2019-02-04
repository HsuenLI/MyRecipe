//
//  AddNewStepView.swift
//  JamMaker
//
//  Created by Hsuen-Ju Li on 2019/2/2.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class AddNewStepView : UIView{
    
    let titleSpacing : CGFloat = 40
    var newItemController = NewItemController()
    let headerTitle : UILabel = {
        let label = UILabel()
        label.text = "Steps"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.rgb(red: 240, green: 96, blue: 98)
        return label
    }()
    let itemTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Discription:"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    let itemDescritionTextView : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        tv.layer.cornerRadius = 5.0
        tv.layer.masksToBounds = true
        tv.layer.borderWidth = 0.3
        tv.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        return tv
    }()
    let itemPhotoImageLabel : UILabel = {
        let label = UILabel()
        label.text = "Photo:"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    lazy var photoImageButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        button.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        button.layer.borderWidth = 0.3
        return button
    }()
    
    let addButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Add", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.rgb(red: 240, green: 96, blue: 98)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(headerTitle)
        headerTitle.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: titleSpacing)
        
        addSubview(itemTitleLabel)
        addSubview(itemDescritionTextView)
        itemTitleLabel.anchor(top: headerTitle.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: titleSpacing)
        itemDescritionTextView.anchor(top: itemTitleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 2*titleSpacing)
        addSubview(itemPhotoImageLabel)
        addSubview(photoImageButton)
        itemPhotoImageLabel.anchor(top: itemDescritionTextView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: titleSpacing)
        photoImageButton.anchor(top: itemPhotoImageLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        photoImageButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        addSubview(addButton)
        addButton.anchor(top: photoImageButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: titleSpacing)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
