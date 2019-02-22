//
//  NewItemController.swift
//  JamMaker
//
//  Created by Hsuen-Ju Li on 2019/2/2.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit
import CoreData

class NewItemController : UICollectionViewController{
    
    static let notificationUpdateHome = NSNotification.Name(rawValue: "updateHomeFeed")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let headerId = "headerId"
    let ingredientCellId = "ingredientCellId"
    let stepCellId = "stepCellId"
    let cellPadding : CGFloat = 8
    let productInstructionTitle = ["Ingredients", "Steps"]
    var product : Product?
    var ingredients = [Ingredient]()
    var steps = [Step]()
    var stepsCellHeight : CGFloat = 0
    var productTitle = ""
    let gearView = GearView()
    var selectedProduct : Product?{
        didSet{
            fetchData()
        }
    }
    var gearViewIsAppear = false
    
    //MARK : Blank view
    let blankWindow = UIView()
    let imagePicker = UIImagePickerController()
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
    
    //MARK : Top Item Image
    let productCoverImageButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleItemPhoto), for: .touchUpInside)
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 0.5
        return button
    }()
    
    fileprivate func fetchData(){
        guard let product = selectedProduct else {return}
        navigationController?.navigationBar.prefersLargeTitles = false
        productTitle = product.title!
        navigationItem.title = product.title
        guard let imageData = product.image else {return}
        productCoverImageButton.setImage(UIImage(data: imageData)?.withRenderingMode(.alwaysOriginal), for: .normal)
        var sortIngredient = [Ingredient]()
        for ingredient in product.ingredients!{
            sortIngredient.append(ingredient as! Ingredient)
        }
        ingredients = sortIngredient.sorted { (i1, i2) -> Bool in
            i1.input?.compare(i2.input!) == .orderedAscending
        }
        
        var sortSteps = [Step]()
        for step in product.steps!{
            sortSteps.append(step as! Step)
        }
        
        steps = sortSteps.sorted(by: { (s1, s2) -> Bool in
            s1.count < s2.count
        })
        collectionView.reloadData()
        saveProdcut()
    }
    
    @objc func handleItemPhoto(){
        let headerImagePicker = UIImagePickerController()
        headerImagePicker.delegate = self
        headerImagePicker.allowsEditing = true
        present(headerImagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        view.addSubview(productCoverImageButton)
        productCoverImageButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 195)
        setupCollectionView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureView))
        view.addGestureRecognizer(tapGesture)
        
        let cellTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleCellTap))
        collectionView.addGestureRecognizer(cellTapGesture)
    }
    
    @objc func handleCellTap(_ gesture : UILongPressGestureRecognizer){
        let point = gesture.location(in: collectionView)
        guard let cell = collectionView.indexPathForItem(at: point) else {return}
        let alert = UIAlertController(title: "Delete", message: "Continue to delete", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: "Continue", style: .destructive) { (action) in
            if cell.section == 0{
                self.ingredients.remove(at: cell.row)
            }else{
                self.steps.remove(at: cell.row)
            }
            self.collectionView.reloadData()
        }
        alert.addAction(deleteAction)
        present(alert,animated: true)
    }
    
    func getCellAtPoint(_ point: CGPoint) -> UICollectionViewCell? {
        // Function for getting item at point. Note optionals as it could be nil
        let indexPath = collectionView?.indexPathForItem(at: point)
        var cell : UICollectionViewCell?
        
        if indexPath != nil {
            cell = collectionView?.cellForItem(at: indexPath!)
        } else {
            cell = nil
        }
        
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gearView.removeFromSuperview()
    }
    
    @objc func handleTapGestureView(){
        gearView.removeFromSuperview()
    }
    
    fileprivate func setupNavigation(){
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear"), style: .plain, target: self, action: #selector(handleAddTitleAndSave))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25), NSAttributedString.Key.foregroundColor : UIColor.customTextColor()]
    }
    
    //Add Navigation title for item name
    @objc func handleAddTitleAndSave(){
        if let window = UIApplication.shared.keyWindow{
            window.addSubview(gearView)
            gearView.anchor(top: window.topAnchor, left: nil, bottom: nil, right: window.rightAnchor, paddingTop: 90, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 100, height: 80.5)
            gearView.isHidden = gearViewIsAppear ? false : true
            gearViewIsAppear = !gearViewIsAppear
            gearView.addTitleButton.addTarget(self, action: #selector(handleNavigationTitle), for: .touchUpInside)
            if navigationItem.title == ""{
                gearView.saveButton.isEnabled = false
            }else{
                gearView.saveButton.isEnabled = true
            }
            gearView.saveButton.addTarget(self, action: #selector(handleSavePressed), for: .touchUpInside)
        }
    }
    
    @objc func handleNavigationTitle(){
            let alert = UIAlertController(title: "Set item title", message: nil, preferredStyle: .alert)
            var inputTextfield : UITextField?
            alert.addTextField { (textfield) in
                inputTextfield = textfield
            }
            let addAction = UIAlertAction(title: "Add", style: .default, handler: { (action) in
                self.navigationItem.title = inputTextfield?.text ?? ""
                self.productTitle = (inputTextfield?.text)!
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(addAction)
            present(alert,animated: true)
    }
    
    @objc func handleSavePressed(){
        if let selectedProduct = selectedProduct{
            context.delete(selectedProduct)
        }
        let product = Product(context: context)
        product.title = productTitle
        product.image = productCoverImageButton.currentImage?.pngData()
        product.isStepsExpandable = false
        product.isIngredientExpandable = false
        
        for ingredient in ingredients{
            ingredient.productTitle = product
        }
        
        for step in steps{
            step.productTitle = product
        }
        
        NotificationCenter.default.post(name: NewItemController.notificationUpdateHome, object: nil)
        saveProdcut()
        navigationController?.popToRootViewController(animated: true)
    }
    
    fileprivate func setupCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.register(NewItemHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(IngredientCell.self, forCellWithReuseIdentifier: ingredientCellId)
        collectionView.register(StepsCell.self, forCellWithReuseIdentifier: stepCellId)
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout{
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 2*cellPadding, right: 0)
        }
        collectionView.contentInset = UIEdgeInsets(top: 200, left: cellPadding, bottom: 0, right: cellPadding)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = collectionView.contentOffset.y
        if contentOffsetY > -200{
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.productCoverImageButton.isHidden = true
            }, completion: nil)
        }else if contentOffsetY <= -200{
            productCoverImageButton.isHidden = false
        }
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
            return steps.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ingredientCellId, for: indexPath) as! IngredientCell
            cell.ingredient = ingredients[indexPath.item]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: stepCellId, for: indexPath) as! StepsCell
            cell.step = steps[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - (2*cellPadding)
        if indexPath.section == 0 {
            return CGSize(width: width, height: 40)
        }else{
            stepsCellHeight = 4 + 80 + 4 + (width * 0.8) + 5
            return CGSize(width: width, height: stepsCellHeight)
        }

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
            blankWindow.addSubview(crossButton)
            crossButton.anchor(top: blankWindow.topAnchor, left: nil, bottom: nil, right: blankWindow.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 44, height: 44)
            crossButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
            
            blankWindow.frame = window.frame
            if section == 0{
                newIngredientView.itemTitleTextView.text = ""
                newIngredientView.itemAmountTextField.text = ""
                blankWindow.addSubview(newIngredientView)
                newIngredientView.anchor(top: nil, left: blankWindow.leftAnchor, bottom: nil, right: blankWindow.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 216)
                newIngredientView.centerYAnchor.constraint(equalTo: blankWindow.centerYAnchor).isActive = true
            }else{
                newStepView.itemDescritionTextView.text = ""
                newStepView.photoImageButton.setImage(UIImage(named: "photo"), for: .normal)
                blankWindow.addSubview(newStepView)
                newStepView.anchor(top: nil, left: blankWindow.leftAnchor, bottom: nil, right: blankWindow.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 550)
                newStepView.centerYAnchor.constraint(equalTo: blankWindow.centerYAnchor).isActive = true
            }
        }
    }
    
    //Press cross image to close add item view (ingredient view or step view)
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
                blankWindow.alpha = 1
            }else{
                productCoverImageButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            if picker == imagePicker{
                newStepView.photoImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
                blankWindow.alpha = 1
            }else{
                productCoverImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleAddButton(button : UIButton){
        if button.tag == 0{
            guard let ingredientName = newIngredientView.itemTitleTextView.text else {return}
            guard let inputAmount = newIngredientView.itemAmountTextField.text else {return}
            let ingredient = Ingredient(context: context)
            ingredient.name = ingredientName
            ingredient.input = inputAmount
            ingredients.append(ingredient)
            newIngredientView.addButton.isEnabled = false
            newIngredientView.addButton.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        }else{
            guard let stepName = newStepView.itemDescritionTextView.text else {return}
            guard let image = newStepView.photoImageButton.currentImage else {return}
            let count = steps.count + 1
            let step = Step(context: context)
            //if image != UIImage(named: "photo"){
            step.name = stepName
            step.count = Int32(count)
            step.image = image.pngData()
            let width = collectionView.frame.width - (2*cellPadding)
            stepsCellHeight = 4 + 80 + 4 + (width * 0.8) + 5
//            }else{
//                stepsCellHeight = 40
//                step = Steps(step: count, name: stepName, photoImage: nil)
//            }
            steps.append(step)
        }
        blankWindow.alpha = 0
        collectionView.reloadData()
    }
    
    func saveProdcut(){
        do{
            try context.save()
        }catch let err{
            print("Failed to save product: ", err)
        }
    }

}
