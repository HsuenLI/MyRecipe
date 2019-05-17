//
//  CustomAlertView.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/17.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

protocol CustomAlertViewDelegate {
    func didTapAlertViewButton(button : UIButton, alertType : alertType)
}

enum alertType{
    case BacK
    case Save
}

class CustomAlertView : UIView {
    
    var alertType : alertType?{
        didSet{
            guard let type = alertType else {return}
            modifyAlertTypeButtons(alertType : type)
        }
    }
    var delegate : CustomAlertViewDelegate?
    let alertView = UIView(backgroundColor: .white)
    let leftButton = UIButton(backgroundColor: Color.customRed.value, title: "Cancel", titleColor: Color.textColor.value, font: UIFont.customFont(name: "AvenirNext-Regular", size: 15), radius: 0)
    let rightButton = UIButton(backgroundColor: Color.theme.value, title: "Save", titleColor: Color.textColor.value, font: UIFont.customFont(name: "AvenirNext-Regular", size: 15), radius: 0)
    let alertMessageLabel = UILabel(text: "Press Save will edit previous record.", font: UIFont.customFont(name: "AvenirNext-Bold", size: 15), color: Color.textColor.value)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupBlurView()
        setupAlertView()
    }
    
    private func modifyAlertTypeButtons(alertType : alertType){
        if alertType == .BacK{
            leftButton.setTitle("Unchanged", for: .normal)
            rightButton.setTitle("Stay", for: .normal)
            alertMessageLabel.text = "Data unchanged, are your sure your want to leave?"
        }else{
            leftButton.setTitle("Cancel", for: .normal)
            rightButton.setTitle("Save", for: .normal)
            alertMessageLabel.text = "Press Save will edit previous record."
        }
    }
    
    fileprivate func setupBlurView(){
        let blurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()
        blurEffect.setValue(5, forKeyPath: "blurRadius")
        let blurView = UIVisualEffectView(backgroundColor: UIColor(white: 0, alpha: 0.5))
        blurView.effect = blurEffect
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
    }
    
    fileprivate func setupAlertView(){
        addSubview(alertView)
        alertView.layer.cornerRadius = 15
        alertView.constrainWidth(constant: 300)
        alertView.constrainHeight(constant: 250)
        alertView.centerInSuperview()
        let buttonsStackView = UIStackView(arrangedSubviews: [leftButton,rightButton])
        leftButton.addTarget(self, action: #selector(handleTapAlertButton), for: .touchUpInside)
        leftButton.tag = 0
        leftButton.layer.cornerRadius = 15
        leftButton.layer.maskedCorners = [.layerMinXMaxYCorner]
        rightButton.addTarget(self, action: #selector(handleTapAlertButton), for: .touchUpInside)
        rightButton.tag = 1
        rightButton.layer.cornerRadius = 15
        rightButton.layer.maskedCorners = [.layerMaxXMaxYCorner]
        buttonsStackView.distribution = .fillEqually
        alertView.addSubview(buttonsStackView)
        buttonsStackView.anchor(top: nil, leading: alertView.leadingAnchor, bottom: alertView.bottomAnchor, trailing:  alertView.trailingAnchor,size: .init(width: 0, height: 49))
        
        alertMessageLabel.numberOfLines = 0
        alertMessageLabel.textAlignment = .center
        alertView.addSubview(alertMessageLabel)
        alertMessageLabel.anchor(top: alertView.topAnchor, leading: alertView.leadingAnchor, bottom: buttonsStackView.topAnchor, trailing: alertView.trailingAnchor,padding: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTapAlertButton(sender : UIButton){
        if let type = alertType{
            delegate?.didTapAlertViewButton(button: sender, alertType: type)
        }
    }
    
}
