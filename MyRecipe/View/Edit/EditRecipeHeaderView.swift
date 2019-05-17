//
//  EditRecipeHeaderView.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/16.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

protocol  EditRecipeHeaderViewDelegate {
    func handleToAddMore(section : Int)
}

class  EditRecipeHeaderView : UICollectionReusableView{
    
    var delegate : EditRecipeHeaderViewDelegate?
    var section = 0
    
    lazy var headerButton = UIButton(backgroundColor: Color.customRed.value, title: "", titleColor: .white, font: UIFont.customFont(name: "AvenirNext-Bold", size: 13), radius: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerButton)
        headerButton.constrainWidth(constant: 260)
        headerButton.constrainHeight(constant: 40)
        headerButton.centerXInSuperview()
        headerButton.addTarget(self, action: #selector(handleToAddMore), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleToAddMore(){
        delegate?.handleToAddMore(section: section)
    }
}
