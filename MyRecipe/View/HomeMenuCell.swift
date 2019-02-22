//
//  HomeMenuCell.swift
//  JamMaker
//
//  Created by Hsuen-Ju Li on 2019/1/27.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

protocol homeCellOptionsDelegate {
    func handleHomeCellDelete(cell : HomeMenuCell)
    func handleHomeCellEdit(cell : HomeMenuCell)
}

class HomeMenuCell : CustomCell {
    
    var product : Product?{
        didSet{
            guard let image = product?.image else {return}
            imageView.image = UIImage(data: image)
            
            titleLabel.text = product?.title
        }
    }
    
    var delegate : homeCellOptionsDelegate?
    var homeOptionsView = HomeOptionsView()
    var viewIsExpandable = true
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = UIColor.customTextColor()
        label.textAlignment = .center
        return label
    }()
    
    lazy var optionButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "options"), for: .normal)
        button.tintColor = UIColor.customTextColor()
        button.addTarget(self, action: #selector(handleOptions), for: .touchUpInside)
        return button
    }()
    
    @objc func handleOptions(){
        addSubview(homeOptionsView)
        homeOptionsView.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 40, width: 80, height: 126)

        homeOptionsView.isHidden = viewIsExpandable ? false : true
        viewIsExpandable = !viewIsExpandable
    }

        override func setupView() {
            addSubview(imageView)
            imageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
            let separatorView = UIView()
            separatorView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            addSubview(separatorView)
            separatorView.anchor(top: imageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
            addSubview(titleLabel)
            titleLabel.anchor(top: separatorView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
            addSubview(optionButton)
            optionButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 44, height: 44)
            
            homeOptionsView.deleteButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
            homeOptionsView.editButton.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
    }
    
    @objc func handleDelete(){
        delegate?.handleHomeCellDelete(cell: self)
    }
    
    @objc func handleEdit(){
        delegate?.handleHomeCellEdit(cell: self)
    }
}
