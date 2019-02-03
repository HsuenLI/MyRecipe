//
//  AddNewIngredientView.swift
//  JamMaker
//
//  Created by Hsuen-Ju Li on 2019/2/2.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class AddNewIngredientView : UIView{
    
    let spacing : CGFloat = 40
    var newItemController = NewItemController()
    let headerTitle : UILabel = {
        let label = UILabel()
        label.text = "Ingredient"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.rgb(red: 240, green: 96, blue: 98)
        return label
    }()
    let itemTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Name:"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    lazy var itemTitleTextView : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        tv.layer.cornerRadius = 5.0
        tv.layer.masksToBounds = true
        tv.layer.borderWidth = 0.3
        tv.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        //tv.delegate = self
        return tv
    }()
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        handleTextInput()
//    }

    let itemAmountLabel : UILabel = {
        let label = UILabel()
        label.text = "Amount:"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    lazy var itemAmountTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Ex. 180g"
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        tf.borderStyle = .roundedRect
        //tf.addTarget(self, action: #selector(handleTextInput), for: .touchUpInside)
        return tf
    }()
    
//    @objc func handleTextInput(){
//        let isFormValidate = itemAmountTextField.text?.count ?? 0 > 0 && itemTitleTextView.text.count > 0
//        if isFormValidate{
//            addButton.isEnabled = true
//            addButton.backgroundColor = UIColor.rgb(red: 240, green: 98, blue: 96)
//        }else{
//            addButton.isEnabled = false
//            addButton.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
//        }
//    }
    let addButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Add", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.rgb(red: 240, green: 98, blue: 96)
        //button.isEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(headerTitle)
        headerTitle.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: spacing)
        addSubview(itemTitleLabel)
        addSubview(itemTitleTextView)
        itemTitleLabel.anchor(top: headerTitle.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 80, height: spacing)
        itemTitleTextView.anchor(top: headerTitle.bottomAnchor, left: itemTitleLabel.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 10, paddingBottom: 0, paddingRight: 5, width: 0, height: 2*spacing)
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        addSubview(separatorView)
        separatorView.anchor(top: itemTitleTextView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 0.5)
        
        addSubview(itemAmountLabel)
        addSubview(itemAmountTextField)
        itemAmountLabel.anchor(top: separatorView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 80, height: spacing)
        itemAmountTextField.anchor(top: separatorView.bottomAnchor, left: itemAmountLabel.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 10, paddingBottom: 0, paddingRight: 5, width: 0, height: spacing)
        
        addSubview(addButton)
        addButton.anchor(top: itemAmountTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: spacing)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
