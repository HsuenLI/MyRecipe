//
//  EditRecipeController.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/16.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit
import CoreData

class EditRecipeController : UICollectionViewController{
    
    var product : Product?
    var unsaveIngredient = [Ingredient]()
    var unsaveStep = [Step]()
    var ingredientSource = [Source]()
    var stepSource = [StepSource]()
    
    private let titleCellId = "titleCellId"
    private let ingredientCellId = "ingredientCellId"
    private let stepCellId = "stepCellId"
    private let headerId = "headerId"
    var titleImagePicker = UIImagePickerController()
    var stepImagePicker = UIImagePickerController()
    var ingredientHeader = EditRecipeHeaderView()
    var stepHeader = EditRecipeHeaderView()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    lazy var customAlertView : CustomAlertView = {
        let view = CustomAlertView()
        view.delegate = self
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Mode"
        navigationController?.customNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveButton))
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named : "back"), style: .plain, target: self, action: #selector(handleBackButton))
        collectionView.backgroundColor = .white
        collectionView.register(NewRecipeTitleCell.self, forCellWithReuseIdentifier: titleCellId)
        collectionView.register(NewRecipeIngredientCell.self, forCellWithReuseIdentifier: ingredientCellId)
        collectionView.register(EditRecipeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(NewRecipeStepCell.self, forCellWithReuseIdentifier: stepCellId)
        fetchData()
    }
    
    @objc func handleBackButton(){
        if let window = UIApplication.shared.keyWindow{
            customAlertView.alertType = .BacK
            window.addSubview(customAlertView)
            customAlertView.anchor(top: window.topAnchor, leading: window.leadingAnchor, bottom: window.bottomAnchor, trailing: window.trailingAnchor)
        }
    }
    
    @objc func handleSaveButton(){
        if let window = UIApplication.shared.keyWindow{
            customAlertView.alertType = .Save
            window.addSubview(customAlertView)
            customAlertView.anchor(top: window.topAnchor, leading: window.leadingAnchor, bottom: window.bottomAnchor, trailing: window.trailingAnchor)
        }
    }
    
    private func  fetchData(){
        var unsortedStep = [Step]()
        for step in product!.steps!{
            let step = step as! Step
            unsortedStep.append(step)
        }
        unsaveStep = unsortedStep
        let sortSteps = unsortedStep.sorted { (s1, s2) -> Bool in
            return s1.date!.compare(s2.date!) == .orderedAscending
        }
        for step in sortSteps{
            let singleStep = StepSource(stepImage: UIImage(data: step.image!)!, date: step.date!, text: step.text!, checked: true)
            stepSource.append(singleStep)
        }
        
        var unsortedIngredient = [Ingredient]()
        for ingredient in product!.ingredients!{
            let ingredient = ingredient as! Ingredient
            unsortedIngredient.append(ingredient)
        }
        unsaveIngredient = unsortedIngredient
        let sortIngredient = unsortedIngredient.sorted { (s1, s2) -> Bool in
            guard let firstDate = s1.date else {return false}
            guard let secondDate = s2.date else {return false}
            return firstDate.compare(secondDate) == .orderedAscending
        }
        for ingredient in sortIngredient{
            let singleIngredient = Source(ingredients: ingredient.input!, date: ingredient.date!, checked: true)
            ingredientSource.append(singleIngredient)
        }
    }
    
    init(){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditRecipeController : UICollectionViewDelegateFlowLayout{
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! EditRecipeHeaderView
        if indexPath.section == 1{
            header.headerButton.setTitle("Tap to add more ingredients", for: .normal)
            ingredientHeader = header
        }else if indexPath.section == 2{
            header.headerButton.setTitle("Tap to add more steps", for: .normal)
            stepHeader = header
        }
        header.delegate = self
        header.section = indexPath.section
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section != 0 {
            return .init(width: view.frame.width, height: 40)
        }
        return CGSize(width: 0, height: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return ingredientSource.count
        default:
            return stepSource.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: titleCellId, for: indexPath) as! NewRecipeTitleCell
            if let productImage = product?.image{
                headerCell.headerImageButton.setImage(UIImage(data: productImage), for: .normal)
            }
            headerCell.titleTextFiled.text = product?.title
            switch product?.level{
            case 1 :
                headerCell.easyButton.setTitleColor(Color.theme.value, for: .normal)
            case 3:
                headerCell.mediumButton.setTitleColor(Color.theme.value, for: .normal)
            case 5:
                headerCell.hardButton.setTitleColor(Color.theme.value, for: .normal)
            default:
                break
            }
            headerCell.addDelegate = self
            headerCell.editRecipeController = self
            return headerCell
        case 1:
            let ingredientCell = collectionView.dequeueReusableCell(withReuseIdentifier: ingredientCellId, for: indexPath) as! NewRecipeIngredientCell
            ingredientCell.ingredientDelegate = self
            ingredientCell.checkButton.isHidden = false
            ingredientCell.source = ingredientSource[indexPath.item]
            return ingredientCell
        default:
            let stepCell = collectionView.dequeueReusableCell(withReuseIdentifier: stepCellId, for: indexPath) as! NewRecipeStepCell
            stepCell.stepDeleagate = self
            stepCell.step = stepSource[indexPath.item]
            stepCell.checkButton.isHidden = false
            return stepCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section{
        case 0 :
            let height = view.frame.width / 16 * 9 + 89
            return .init(width: view.frame.width, height: height)
        case 1:
            return .init(width: view.frame.width, height: 27)
        default:
            let imageHeight = view.frame.width / 16 * 9
            let height = imageHeight + 45
            return .init(width: view.frame.width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section{
        case 0 :
            return .init(top: 0, left: 0, bottom: 23, right: 0)
        case 1:
            return.init(top: 23, left: 0, bottom: 23, right: 0)
        default:
            return.init(top: 17, left: 0, bottom: 0, right: 0)
        }
    }
}

//TitleCell Deleagate
extension EditRecipeController : EditRecipeHeaderViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func didTapHeaderImageButtonAddImaage() {
        alertSelectionSourceType(imagePickerController: titleImagePicker)
    }
    
    func didTypeRecipeTitle(textFiled : UITextField) {
        product?.title = textFiled.text
    }
    
    
    func didSelectLevel(button: UIButton) {
        switch button.tag{
        case 2:
            product?.level = Int32(3)
        case 3:
            product?.level = Int32(5)
        default:
            product?.level = Int32(1)
        }
    }
    
    func removeNavigationRightItme(){
        navigationItem.rightBarButtonItem = nil
    }
    
    func alertSelectionSourceType(imagePickerController : UIImagePickerController){
        let alert = UIAlertController(title: nil , message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.delegate = self
                imagePickerController.allowsEditing = false
                imagePickerController.sourceType = .camera
                self.present(imagePickerController,animated:  true)
            }
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                imagePickerController.delegate = self
                imagePickerController.allowsEditing = true
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController,animated: true)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(r: 142, g: 142, b: 147), forKey: "titleTextColor")
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(photoLibrary)
        present(alert,animated: true)
    }
    
    //Image Picker controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(picker)
        var selectedImage : UIImage = UIImage()
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImage = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImage = originalImage
        }
        if picker == titleImagePicker{
            let indexPath = IndexPath(item: 0, section: 0)
            let cell = collectionView.cellForItem(at: indexPath) as! NewRecipeTitleCell
            cell.headerImageButton.setImage(selectedImage, for: .normal)
            product?.image = selectedImage.jpegData(compressionQuality: 0.3)
        }else{
            let item = stepSource.count - 1
            let indexPath = IndexPath(item: item, section: 2)
            let cell = collectionView.cellForItem(at: indexPath) as! NewRecipeStepCell
            cell.imageButton.setImage(selectedImage, for: .normal)
        }
        
        
        dismiss(animated: true, completion: nil)
    }
}

//Ingredient and step delegate
extension EditRecipeController : NewRecipeTitleCellDelegate, NewRecipeIngredientCellDeleagate, NewRecipeFooterViewDelegate, NewRecipeStepCellDelegate{
    
    
    func handleToAddMore(section: Int) {
        if section == 1{
            ingredientSource.append(Source(ingredients: "", date: Date(), checked: false))
        }else if section == 2{
            stepSource.append(StepSource(stepImage: UIImage(named: "notImage")!, date: Date(), text: "", checked: false))
        }
        collectionView.reloadData()
    }
    
    
    func didTypeTextAddIngredient(text: String, button : UIButton, cell: NewRecipeIngredientCell) {
        view.endEditing(true)
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        ingredientSource[indexPath.item].ingredients = text
        ingredientSource[indexPath.item].date = Date()
        ingredientSource[indexPath.item].checked = !ingredientSource[indexPath.item].checked
        guard let image = ingredientSource[indexPath.item].checked ? "cellSave" : "cellUnsave" else {return}
        button.setImage(UIImage(named: image), for: .normal)
        if ingredientSource[indexPath.item].checked{
            ingredientHeader.headerButton.isEnabled = true
            ingredientHeader.headerButton.backgroundColor = Color.customRed.value
        }else{
            ingredientHeader.headerButton.isEnabled = false
            ingredientHeader.headerButton.backgroundColor = Color.borderColor.value
        }
    }
    
    func didTapSelectStepImage(cell: NewRecipeStepCell) {
        alertSelectionSourceType(imagePickerController: stepImagePicker)
    }
    
    func didAddTextInStep(text: String, button: UIButton, cell: NewRecipeStepCell) {
        view.endEditing(true)
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        var step = stepSource[indexPath.item]
        stepSource[indexPath.item].text = text
        step.date = Date()
        step.stepImage = cell.imageButton.currentImage!
        stepSource[indexPath.item].checked = !stepSource[indexPath.item].checked
        guard let image = stepSource[indexPath.item].checked ? "cellSave" : "cellUnsave" else {return}
        button.setImage(UIImage(named: image), for: .normal)
        if stepSource[indexPath.item].checked{
            stepHeader.headerButton.isEnabled = true
            stepHeader.headerButton.backgroundColor = Color.customRed.value
        }else{
            stepHeader.headerButton.isEnabled = false
            stepHeader.headerButton.backgroundColor = Color.borderColor.value
        }
    }
}


extension EditRecipeController : CustomAlertViewDelegate{
    func didTapAlertViewButton(button: UIButton, alertType : alertType) {
        if alertType == .Save{
            if button.tag == 0{
                customAlertView.removeFromSuperview()
            }else{
                saveNewDataInDatabase()
                customAlertView.removeFromSuperview()
                navigationController?.popToRootViewController(animated: true)
            }
        }else{
            if button.tag == 0{
                customAlertView.removeFromSuperview()
                self.navigationController?.popToRootViewController(animated: true)
            }else{
                customAlertView.removeFromSuperview()
            }
        }
    }
    
    private func saveNewDataInDatabase(){
        guard let product = self.product else {return}
        dataPrepare(product: product)
    }
    
    fileprivate func dataPrepare(product : Product){
                var ingredients = [Ingredient]()
                var steps = [Step]()
                product.modifiedDate = Date()
                for ingredient in ingredientSource{
                    if ingredient.checked{
                        let singleIngredient = Ingredient(context: context)
                        singleIngredient.input = ingredient.ingredients
                        singleIngredient.product = product
                        singleIngredient.date = ingredient.date
                        ingredients.append(singleIngredient)
                    }
                }

                for step in stepSource{
                    if step.checked{
                        let singleStep = Step(context: context)
                        singleStep.date = step.date
                        singleStep.image = step.stepImage.jpegData(compressionQuality: 0.3)
                        singleStep.text = step.text
                        singleStep.product = product
                        steps.append(singleStep)
                    }
                }
        for ingredient in unsaveIngredient{
            context.delete(ingredient)
            saveDataContext()
        }
        
        for step in unsaveStep{
            context.delete(step)
            saveDataContext()
        }
                unsaveIngredient = ingredients
                unsaveStep = steps
                saveDataContext()
    }
    
    fileprivate func saveDataContext(){
        do{
            try context.save()
        }catch let err{
            print("Failed to save data in database: ", err)
        }
    }
}
