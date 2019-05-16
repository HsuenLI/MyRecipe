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

class HomeMenuCell : UICollectionViewCell {
    
    var product : Product?{
        didSet{
            guard let image = product?.image else {return}
            imageView.image = UIImage(data: image)
            
            titleLabel.text = product?.title
            let level = product?.level
            showLevelStar(level: level ?? 1)
        }
    }
    
    var delegate : homeCellOptionsDelegate?
    var homeOptionsView = HomeOptionsView()
    var viewIsExpandable = true
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = Color.borderColor.value.cgColor
        iv.layer.borderWidth = 0.5
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.customFont(name: "BradleyHandITCTT-Bold", size: 20)
        label.textColor = Color.textColor.value
        return label
    }()
    
    let levelLabel = UILabel(text: "LEVEL: ", font: UIFont.customFont(name: "AvenirNext-Regular", size: 13), color: Color.textColor.value)
    
    let modifyDateLabel : UILabel = {
        let label = UILabel()
        label.text = "Modified Date: 2019-05-01"
        label.textColor = Color.textColor.value
        label.font = UIFont.customFont(name: "AvenirNext-Regular", size: 13)
        return label
    }()
    
    lazy var optionButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "options"), for: .normal)
        button.tintColor = Color.customRed.value
        button.addTarget(self, action: #selector(handleOptions), for: .touchUpInside)
        return button
    }()
    
    let starImagView = UIImageView()
    let star2ImagView = UIImageView()
    let star3ImagView = UIImageView()
    let star4ImagView = UIImageView()
    let star5ImagView = UIImageView()
    
    func showLevelStar(level : Int32){
        let views = [starImagView,star2ImagView,star3ImagView,star4ImagView,star5ImagView]
        for view in views{
            view.image = UIImage(named: "star")?.withRenderingMode(.alwaysTemplate)
            view.tintColor = Color.customRed.value
        }
        
        if level == 1{
            for index in 1..<views.count{
                views[index].tintColor = Color.borderColor.value
            }
            return
        }
        if level == 3{
            for index in 3..<views.count{
                views[index].tintColor = Color.borderColor.value
            }
            return
        }
        
    }
    
    @objc func handleOptions(){
//        addSubview(homeOptionsView)
//        homeOptionsView.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 40, width: 80, height: 126)
//
//        homeOptionsView.isHidden = viewIsExpandable ? false : true
//        viewIsExpandable = !viewIsExpandable
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        addSubview(imageView)
        imageView.layer.cornerRadius = 45
        imageView.layer.masksToBounds = true
        imageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 0, left: 13, bottom: 0, right: 0),size: .init(width: 90, height: 90))
        imageView.centerYInSuperview()
        
        addSubview(optionButton)
        optionButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,padding: .init(top: 20, left: 0, bottom: 0, right: 20),size: .init(width: 20, height: 20))
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: imageView.trailingAnchor, bottom: nil, trailing: optionButton.leadingAnchor,padding: .init(top: 18, left: 14, bottom: 0, right: 5),size: .init(width: 0, height: 25))
        
        addSubview(levelLabel)
        levelLabel.anchor(top: titleLabel.bottomAnchor, leading: imageView.trailingAnchor, bottom: nil, trailing: nil,padding: .init(top: 19, left: 14, bottom: 0, right: 0),size: .init(width: 54, height: 18))
        
        let imageViews = [starImagView,star2ImagView,star3ImagView,star4ImagView,star5ImagView]
        let starStackView = UIStackView(arrangedSubviews: imageViews)
        addSubview(starStackView)
        starStackView.distribution = .equalSpacing
        starStackView.alignment = .leading
        starStackView.anchor(top: titleLabel.bottomAnchor, leading: levelLabel.trailingAnchor, bottom: nil, trailing: nil,padding: .init(top: 16, left: 20, bottom: 0, right: 0),size: .init(width: 140, height: 24))
        addSubview(modifyDateLabel)
        modifyDateLabel.textAlignment = .right
        modifyDateLabel.anchor(top: nil, leading: imageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 7, right: 15))
        
        let separatorView = UIView()
        separatorView.backgroundColor = Color.borderColor.value
        addSubview(separatorView)
        separatorView.anchor(top: bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,size : .init(width: 0, height: 0.5))
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
