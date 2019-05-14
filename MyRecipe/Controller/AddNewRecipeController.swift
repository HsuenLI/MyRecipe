//
//  AddNewRecipeController.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/14.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class AddNewRecipeController : UICollectionViewController{
    
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var ingredients = [Ingredient]()
    var steps = [Step]()
    var headerView : AddNewRecipeHeader?
    private let headerId = "headerId"
    private let cellId = "cellId"
    let headerimagePicker = UIImagePickerController()
    let stepCellImagePickerController  = UIImagePickerController()
    var selectedStepCell : NewRecipeStepCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationItem.title = "New Recipe"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleAddNewRecipeButton))
        navigationController?.customNavigationBar()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(AddNewRecipeHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(AddNewRecipeHomeCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.keyboardDismissMode = .interactive
    }
    
    @objc func handleAddNewRecipeButton(){
        //TODO : Handle save to database
    }
    
    init(){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension AddNewRecipeController : UICollectionViewDelegateFlowLayout{
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? AddNewRecipeHeader
        headerView?.addDelegate = self
        return headerView!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height = view.frame.width / 16 * 9 + 66
        return .init(width: view.frame.width, height: height)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AddNewRecipeHomeCell
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height : CGFloat = view.frame.height
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 50, left: 0, bottom: 0, right: 0)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.bounces = scrollView.contentOffset.y > 100
        headerView?.titleTextFiled.resignFirstResponder()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension AddNewRecipeController : AddNewRecipeHeaderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func didTapHeaderImageButtonAddImaage() {
        alertSelectionSourceType(imagePickerController: headerimagePicker)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(picker)
        var selectedImage : UIImage = UIImage()
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImage = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImage = originalImage
        }
        if picker == headerimagePicker{
            headerView?.headerImageButton.setImage(selectedImage, for: .normal)
        }else{
            selectedStepCell?.imageButton.setImage(selectedImage, for: .normal)
        }

        
        dismiss(animated: true, completion: nil)
    }
    
    func didTypeRecipeTitle(title: String) {
        print(title)
    }

}

extension AddNewRecipeController : AddNewRecipeHomeCellDelegate{
    func didTapAddNewStepImageButton(cell: NewRecipeStepCell) {
        selectedStepCell = cell
        alertSelectionSourceType(imagePickerController: stepCellImagePickerController)
    }
    
    func didTypeAddNewStepContent(text: String, cell: NewRecipeStepCell) {
        print(text)
    }
    
    func didTypeTextAddIngredient(text: String, cell: NewRecipeIngredientCell) {
        print(text)
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
}

