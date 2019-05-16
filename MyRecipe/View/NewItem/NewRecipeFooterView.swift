//
//  NewRecipeFooterView.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/15.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

protocol NewRecipeFooterViewDelegate {
    func handleToAddMore(section : Int)
}

class NewRecipeFooterView: UICollectionReusableView{
    
    var delegate : NewRecipeFooterViewDelegate?
    var section = 0
    
    lazy var footerButton = UIButton(backgroundColor: Color.customRed.value, title: "Tap to add Ingredients", titleColor: .white, font: UIFont.customFont(name: "AvenirNext-Bold", size: 13), radius: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(footerButton)
        footerButton.constrainWidth(constant: 260)
        footerButton.constrainHeight(constant: 40)
        footerButton.centerXInSuperview()
        footerButton.addTarget(self, action: #selector(handleToAddMore), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleToAddMore(){
        delegate?.handleToAddMore(section: section)
    }
}
