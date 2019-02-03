//
//  NewItemController.swift
//  JamMaker
//
//  Created by Hsuen-Ju Li on 2019/2/2.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class NewItemController : UICollectionViewController{
    
    let headerId = "headerId"
    let ingredientCellId = "ingredientCellId"
    let stepCellId = "stepCellId"
    let cellPadding : CGFloat = 8
    let productInstructionTitle = ["Ingredient", "Steps"]
    let blankWindow = UIView()
    let crossButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "cross_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    lazy var newItemHeader : NewItemHeader = {
        let header = NewItemHeader()
        header.newItemController = self
        return header
    }()
    
    lazy var newIngredientView : AddNewIngredientView = {
        let view = AddNewIngredientView()
        view.newItemController = self
        view.addButton.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
        view.addButton.tag = 0
        return view
    }()
    
    lazy var newStepView : AddNewStepView = {
        let view = AddNewStepView()
        view.newItemController = self
        view.photoImageButton.addTarget(self, action: #selector(handlePhotoPicker), for: .touchUpInside)
        view.addButton.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
        view.addButton.tag = 1
        return view
    }()
    
    var ingredients = [Ingredient]()
    let imagePicker = UIImagePickerController()
    let itemHeaderImageButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleItemPhoto), for: .touchUpInside)
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 0.5
        return button
    }()
    
    @objc func handleItemPhoto(){
        let headerImagePicker = UIImagePickerController()
        headerImagePicker.delegate = self
        headerImagePicker.allowsEditing = true
        present(headerImagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Title", style: .plain, target: self, action: #selector(handleAddTitle))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25), NSAttributedString.Key.foregroundColor : UIColor.customTextColor()]
        view.addSubview(itemHeaderImageButton)
        itemHeaderImageButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 195)
        collectionView.backgroundColor = .white
        collectionView.register(NewItemHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(IngredientCell.self, forCellWithReuseIdentifier: ingredientCellId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: stepCellId)
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout{
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 2*cellPadding, right: 0)
        }
        collectionView.contentInset = UIEdgeInsets(top: 200, left: cellPadding, bottom: 0, right: cellPadding)
    }
    
    @objc func handleAddTitle(){
        let alert = UIAlertController(title: "Set item title", message: nil, preferredStyle: .alert)
        var inputTextfield : UITextField?
        alert.addTextField { (textfield) in
            inputTextfield = textfield
        }
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { (action) in
            self.navigationItem.title = inputTextfield?.text ?? ""
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert,animated: true)
    }
    
}

extension NewItemController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width - (2*cellPadding)
        return CGSize(width: width, height: 40)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! NewItemHeader
        header.titleLabel.text = productInstructionTitle[indexPath.section]
        header.addButton.addTarget(self, action: #selector(handleHeaderAddPressed), for: .touchUpInside)
        header.addButton.tag = indexPath.section
        return header
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return productInstructionTitle.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return ingredients.count
        }else{
            return 5
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ingredientCellId, for: indexPath) as! IngredientCell
            cell.ingredient = ingredients[indexPath.item]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: stepCellId, for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - (2*cellPadding)
        return CGSize(width: width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

//View to add new item
extension NewItemController{
    @objc func handleHeaderAddPressed(button : UIButton){
        blankWindow.alpha = 1
        if button.tag == 0{
            newIngredientView.isHidden = false
        }else{
            newStepView.isHidden = false
        }
        setupAddItemView(section : button.tag)
    }
    
    fileprivate func setupAddItemView(section : Int){
        if let window = UIApplication.shared.keyWindow{
            blankWindow.backgroundColor = UIColor(white: 0, alpha: 0.7)
            window.addSubview(blankWindow)
            blankWindow.frame = window.frame
            if section == 0{
                newIngredientView.itemTitleTextView.text = ""
                newIngredientView.itemAmountTextField.text = ""
                blankWindow.addSubview(newIngredientView)
                blankWindow.addSubview(crossButton)
                crossButton.anchor(top: blankWindow.topAnchor, left: nil, bottom: nil, right: blankWindow.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 44, height: 44)
                crossButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
                newIngredientView.anchor(top: nil, left: blankWindow.leftAnchor, bottom: nil, right: blankWindow.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 216)
                newIngredientView.centerYAnchor.constraint(equalTo: blankWindow.centerYAnchor).isActive = true
            }else{
                blankWindow.addSubview(newStepView)
                newStepView.anchor(top: nil, left: blankWindow.leftAnchor, bottom: nil, right: blankWindow.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 550)
                newStepView.centerYAnchor.constraint(equalTo: blankWindow.centerYAnchor).isActive = true
            }
        }
    }
    
    @objc func handleDismiss() {
        blankWindow.alpha = 0
        newIngredientView.isHidden = true
        newStepView.isHidden = true
    }
}

extension NewItemController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc func handlePhotoPicker(){
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        UIView.animate(withDuration: 0.8) {
            self.blankWindow.alpha = 0
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            if picker == imagePicker{
                newStepView.photoImageButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            }else{
                itemHeaderImageButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            if picker == imagePicker{
                newStepView.photoImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            }else{
                itemHeaderImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        blankWindow.alpha = 1
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleAddButton(button : UIButton){
        if button.tag == 0{
            let ingredientName = newIngredientView.itemTitleTextView.text
            let inputAmount = newIngredientView.itemAmountTextField.text
            if ingredientName?.count ?? 0 > 0 && inputAmount?.count ?? 0 > 0{
                newIngredientView.itemTitleTextView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
                newIngredientView.itemAmountTextField.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
                
                let ingredient = Ingredient(name: ingredientName!, input: inputAmount!)
                ingredients.append(ingredient)
            }else{
                newIngredientView.itemTitleTextView.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                newIngredientView.itemAmountTextField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
            }
        }else{
            
        }
        blankWindow.alpha = 0
        collectionView.reloadData()
    }
}
