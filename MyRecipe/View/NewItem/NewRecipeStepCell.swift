//
//  NewRecipeStepCell.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/14.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

protocol NewRecipeStepCellDelegate{
    func didTapSelectStepImage(cell : NewRecipeStepCell)
    func didAddTextInStep(text : String, cell : NewRecipeStepCell)
}
class NewRecipeStepCell : UICollectionViewCell, UITextViewDelegate{
    
    var stepDeleage : NewRecipeStepCellDelegate?
    lazy var imageButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Tap to add step image", for: .normal)
        btn.setTitleColor(Color.textColor.value, for: .normal)
        btn.backgroundColor = UIColor(r: 250, g: 250, b: 250)
        btn.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(handleSelectImage), for: .touchUpInside)
        return btn
    }()
    
    lazy var textView : UITextView = {
        let tv = UITextView()
        tv.textColor = Color.textColor.value
        tv.font = UIFont.customFont(name: "AvenirNext-Regular", size: 13)
        tv.textAlignment = .left
        tv.adjustsFontForContentSizeCategory = true
        tv.delegate = self
        return tv
    }()
    
    let placeholderLabel = UILabel(text: "Enter your step here", font: UIFont.customFont(name: "AvenirNext-Regular", size: 13), color: Color.borderColor.value)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageButton)
        let buttonHeight : CGFloat = self.frame.width / 16  *  9
        imageButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,size: .init(width: 0, height: buttonHeight))
        addSubview(textView)
        textView.anchor(top: imageButton.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 10, left: 20, bottom: 10, right: 20))
        let separator = UIView(backgroundColor: Color.borderColor.value)
        addSubview(separator)
        separator.anchor(top: bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 0.5))
        
        textView.addSubview(placeholderLabel)
        placeholderLabel.textAlignment = .left
        placeholderLabel.anchor(top: textView.topAnchor, leading: textView.leadingAnchor, bottom: textView.bottomAnchor, trailing: textView.trailingAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0{
            placeholderLabel.isHidden = true
        }else{
            placeholderLabel.isHidden = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.stepDeleage?.didAddTextInStep(text: textView.text, cell: self)
        self.endEditing(true)
    }

    @objc func handleSelectImage(){
        stepDeleage?.didTapSelectStepImage(cell : self)
    }
    
}
