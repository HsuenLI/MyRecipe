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
    func didAddTextInStep(text : String,button: UIButton, cell : NewRecipeStepCell)
}

class NewRecipeStepCell : UICollectionViewCell, UITextViewDelegate{
    var step : StepSource!{
        didSet{
            imageButton.setImage(step.stepImage, for: .normal)
            textView.text = step.text
            guard let image = step.checked ? "cellSave" : "cellUnsave" else {return}
            checkButton.setImage(UIImage(named: image), for: .normal)
        }
    }
    var stepDeleagate : NewRecipeStepCellDelegate?
    lazy var imageButton : UIButton = {
        let btn = UIButton()
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
    
    lazy var checkButton : UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setImage(UIImage(named: "cellUnsave"), for: .normal)
        btn.addTarget(self, action: #selector(handleCheckedButton), for: .touchUpInside)
        return btn
    }()
    
    let placeholderLabel = UILabel(text: "Enter your step here", font: UIFont.customFont(name: "AvenirNext-Regular", size: 13), color: Color.borderColor.value)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageButton)
        let buttonHeight : CGFloat = self.frame.width / 16  *  9
        imageButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,size: .init(width: 0, height: buttonHeight))
        addSubview(checkButton)
        checkButton.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor,padding: .init(top: 5, left: 0, bottom: 0, right: 20),size: .init(width: 18, height: 18))
        addSubview(textView)
        textView.anchor(top: imageButton.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: checkButton.leadingAnchor,padding: .init(top: 10, left: 20, bottom: 10, right: 10))
        checkButton.centerYAnchor.constraint(equalTo: textView.centerYAnchor).isActive = true
        let separator = UIView(backgroundColor: Color.borderColor.value)
        addSubview(separator)
        separator.anchor(top: bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 0.5))
        
        textView.addSubview(placeholderLabel)
        placeholderLabel.textAlignment = .left
        placeholderLabel.anchor(top: nil, leading: textView.leadingAnchor, bottom: nil, trailing: textView.trailingAnchor)
        placeholderLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        placeholderLabel.centerYAnchor.constraint(equalTo: textView.centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0{
            placeholderLabel.isHidden = true
            checkButton.isHidden = false
        }else{
            placeholderLabel.isHidden = false
            checkButton.isHidden = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.endEditing(true)
    }

    @objc func handleSelectImage(){
        stepDeleagate?.didTapSelectStepImage(cell : self)
    }
    
    @objc func handleCheckedButton(sender : UIButton){
        if let text = textView.text{
            stepDeleagate?.didAddTextInStep(text: text, button: sender, cell: self)
        }
    }
}
