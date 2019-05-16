//
//  DetailsHeaderView.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/16.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

protocol DetailsHeaderViewDelegate {
    func tapToCollapsedSection(section : Int, header : DetailsHeaderView)
}

class DetailsHeaderView : UICollectionReusableView{
    
    var delegate : DetailsHeaderViewDelegate?
    var section : Int = 0
    var callapsed : Bool = false
    lazy var titleButton : UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.customFont(name: "AvenirNext-Bold", size: 18)
        btn.setTitleColor(Color.textColor.value, for: .normal)
        btn.addTarget(self, action: #selector(handleSectionCallapsed), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleSectionCallapsed(){
        delegate?.tapToCollapsedSection(section: section, header: self)
    }
    
    let arrowImageView = UIImageView(imageName: "arrow")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Color.customRed.value
        addSubview(titleButton)
        titleButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        addSubview(arrowImageView)
        arrowImageView.contentMode = .scaleAspectFill
        arrowImageView.clipsToBounds = true
        arrowImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 19),size: .init(width: 13, height: 13))
        arrowImageView.centerYInSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCollapsed(_ collapsed: Bool) {
        if collapsed{
            arrowImageView.image = UIImage(named: "arrow")
        }else{
            arrowImageView.image = UIImage(named: "arrow_more")
        }
    }
}
