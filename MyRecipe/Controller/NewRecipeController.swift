//
//  NewRecipeController.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/15.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit
import CoreData

struct Source {
    var ingredients : String
    var date : Date
    var checked : Bool
}

struct StepSource{
    var stepImage : UIImage
    var date : Date
    var text : String
    var checked : Bool
}

class NewRecipeController : UICollectionViewController{
    
    private let  context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let  titleCellId = "titleCellId"
    private let ingredientCellId = "ingredientCellId"
    private let footerId  = "footerId"
    private let stepCellId = "stepCellId"
    var level : Int = 1
    var ingredientCount = 1
    var stepCount = 1
    var titleImagePicker = UIImagePickerController()
    var stepImagePicker = UIImagePickerController()
    var recipeTitle : String?
    var recipeimage : UIImage?
    var ingredientFooter = NewRecipeFooterView()
    var stepFooter = NewRecipeFooterView()
    var ingredients = [Source]()
    var steps = [StepSource]()
    var databaseIngredient = [Ingredient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(NewRecipeTitleCell.self, forCellWithReuseIdentifier: titleCellId)
        collectionView.register(NewRecipeIngredientCell.self, forCellWithReuseIdentifier: ingredientCellId)
        collectionView.register(NewRecipeFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        collectionView.register(NewRecipeStepCell.self, forCellWithReuseIdentifier: stepCellId)
        navigationItem.title = "New Recipe"
        navigationController?.customNavigationBar()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .interactive
    }
    
    @objc func handleAddNewRecipeButton(){
        //TODO : Handle save to database
        guard let title = recipeTitle else {return}
        let randomID = NSUUID().uuidString
        let product = Product(context: context)
        product.id = randomID
        product.title = title
        if let titleImage = recipeimage{
            product.image = titleImage.jpegData(compressionQuality: 0.3)
        }else{
            product.image = UIImage(named: "notImage")?.jpegData(compressionQuality: 0.3)
        }
        product.modifiedDate = Date()
        product.level = Int32(level)
        for ingredient in ingredients{
            if ingredient.checked{
                let singleIngredient = Ingredient(context: context)
                singleIngredient.input = ingredient.ingredients
                singleIngredient.product = product
                singleIngredient.date = ingredient.date
                self.saveDateInDatabase()
            }
        }
        
        for step in steps{
            if step.checked{
                let singleStep = Step(context: context)
                singleStep.date = step.date
                singleStep.image = step.stepImage.jpegData(compressionQuality: 0.3)
                singleStep.text = step.text
                singleStep.product = product
                self.saveDateInDatabase()
            }
        }
        
        saveDateInDatabase()
        self.navigationController?.popViewController(animated: true)
    }
    
    init(){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewRecipeController : UICollectionViewDelegateFlowLayout{
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! NewRecipeFooterView
        if indexPath.section == 1{
            footer.footerButton.setTitle("Tap to add more Ingredients", for: .normal)
            ingredientFooter = footer
            if ingredients.count > 0{
                ingredientFooter.footerButton.isEnabled = false
                ingredientFooter.footerButton.backgroundColor = Color.borderColor.value
            }else{
                ingredientFooter.footerButton.isEnabled = true
                ingredientFooter.footerButton.backgroundColor = Color.customRed.value
            }
        }else if indexPath.section == 2{
            footer.footerButton.setTitle("Tap to add more steps", for: .normal)
            stepFooter = footer
            if steps.count > 0{
                stepFooter.footerButton.isEnabled = false
                stepFooter.footerButton.backgroundColor = Color.borderColor.value
            }else{
                stepFooter.footerButton.isEnabled = true
                stepFooter.footerButton.backgroundColor = Color.customRed.value
            }
        }
        footer.delegate = self
        footer.section = indexPath.section
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
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
            return ingredients.count
        default:
            return steps.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: titleCellId, for: indexPath) as! NewRecipeTitleCell
            headerCell.addDelegate = self
            headerCell.newRecipeController = self
            return headerCell
        case 1:
            let ingredientCell = collectionView.dequeueReusableCell(withReuseIdentifier: ingredientCellId, for: indexPath) as! NewRecipeIngredientCell
            ingredientCell.ingredientDelegate = self
            ingredientCell.source = ingredients[indexPath.item]
            return ingredientCell
        default:
            let stepCell = collectionView.dequeueReusableCell(withReuseIdentifier: stepCellId, for: indexPath) as! NewRecipeStepCell
            stepCell.stepDeleagate = self
            stepCell.step = steps[indexPath.item]
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
            return .init(top: 0, left: 0, bottom: 0, right: 0)
        case 1:
            return.init(top: 50, left: 0, bottom: 23, right: 0)
        default:
            return.init(top: 17, left: 0, bottom: 17, right: 0)
        }
    }
}

//TitleCell Deleagate
extension NewRecipeController : NewRecipeTitleCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func didTapHeaderImageButtonAddImaage() {
        alertSelectionSourceType(imagePickerController: titleImagePicker)
    }
    
    func didTypeRecipeTitle(textFiled : UITextField) {
        self.recipeTitle = textFiled.text
        if textFiled.text!.count > 0{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleAddNewRecipeButton))
        }
    }
    
    func didSelectLevel(button: UIButton) {
        switch button.tag{
        case 2:
            self.level = 3
        case 3:
            self.level = 5
        default:
            self.level = 1
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
            recipeimage = selectedImage
        }else{
            let item = steps.count - 1
            let indexPath = IndexPath(item: item, section: 2)
            let cell = collectionView.cellForItem(at: indexPath) as! NewRecipeStepCell
            cell.imageButton.setImage(selectedImage, for: .normal)
            steps[indexPath.item].stepImage = selectedImage
        }
        
        
        dismiss(animated: true, completion: nil)
    }
}

//Ingredient and step delegate
extension NewRecipeController : NewRecipeIngredientCellDeleagate, NewRecipeFooterViewDelegate, NewRecipeStepCellDelegate{

    
    func handleToAddMore(section: Int) {
        if section == 1{
            ingredients.append(Source(ingredients: "", date: Date(), checked: false))
        }else if section == 2{
            steps.append(StepSource(stepImage: UIImage(named: "notImage")!, date: Date(), text: "", checked: false))
        }
        collectionView.reloadData()
    }
    
    
    func didTypeTextAddIngredient(text: String, button : UIButton, cell: NewRecipeIngredientCell) {
        view.endEditing(true)
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        ingredients[indexPath.item].ingredients = text
        ingredients[indexPath.item].date = Date()
        ingredients[indexPath.item].checked = !ingredients[indexPath.item].checked
        guard let image = ingredients[indexPath.item].checked ? "cellSave" : "cellUnsave" else {return}
        button.setImage(UIImage(named: image), for: .normal)
        if ingredients[indexPath.item].checked{
            ingredientFooter.footerButton.isEnabled = true
            ingredientFooter.footerButton.backgroundColor = Color.customRed.value
        }else{
            ingredientFooter.footerButton.isEnabled = false
            ingredientFooter.footerButton.backgroundColor = Color.borderColor.value
        }
        print(ingredients)
    }
    
    func didTapSelectStepImage(cell: NewRecipeStepCell) {
        alertSelectionSourceType(imagePickerController: stepImagePicker)
    }
    
    func didAddTextInStep(text: String, button: UIButton, cell: NewRecipeStepCell) {
        view.endEditing(true)
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        var step = steps[indexPath.item]
        steps[indexPath.item].text = text
        step.date = Date()
        step.stepImage = cell.imageButton.currentImage!
        steps[indexPath.item].checked = !steps[indexPath.item].checked
        guard let image = steps[indexPath.item].checked ? "cellSave" : "cellUnsave" else {return}
        button.setImage(UIImage(named: image), for: .normal)
        if steps[indexPath.item].checked{
            stepFooter.footerButton.isEnabled = true
            stepFooter.footerButton.backgroundColor = Color.customRed.value
        }else{
            stepFooter.footerButton.isEnabled = false
            stepFooter.footerButton.backgroundColor = Color.borderColor.value
        }
        print(steps)
    }
}

extension NewRecipeController{
    fileprivate func saveDateInDatabase(){
        do{
            try context.save()
        }catch let err{
            print("Failed to save data in database: ", err)
        }
    }
}

