//
//  DetailsTitleCell.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/16.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class DetailsTitleCell : UICollectionViewCell{
    
    var product : Product!{
        didSet{
            guard let imageData = product.image else {return}
            titleImageView.image = UIImage(data: imageData)
            let level = product.level
            showLevelStar(level: level)
        }
    }
    
    let titleImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let levelLabel = UILabel(text: "Level: ", font: UIFont.customFont(name: "AvenirNext-Regular", size: 13), color: Color.textColor.value)
    let starImagView = UIImageView()
    let star2ImagView = UIImageView()
    let star3ImagView = UIImageView()
    let star4ImagView = UIImageView()
    let star5ImagView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleImageView)
        let imageHeight : CGFloat = self.frame.width / 16 * 9
        titleImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,size: .init(width: 0, height: imageHeight))
        
        addSubview(levelLabel)
        levelLabel.constrainWidth(constant: 100)
        let imageViews = [starImagView,star2ImagView,star3ImagView,star4ImagView,star5ImagView]
        let starStackView = UIStackView(arrangedSubviews: imageViews)
        starStackView.constrainWidth(constant: 120)
        starStackView.constrainHeight(constant: 24)
        let levelStackView = UIStackView(arrangedSubviews: [levelLabel,starStackView])
        addSubview(levelStackView)
        levelStackView.centerXInSuperview()
        levelStackView.anchor(top: titleImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 9, left: 0, bottom: 0, right: 0),size: .init(width: 220, height: 24))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
}
