//
//  AddRecipeContentController.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/14.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

protocol AddNewREcipeContentControllerDelegate{
    func didTapAddNewStepImageButton(cell : NewRecipeStepCell)
    func didTypeAddNewStepContent(text : String,cell : NewRecipeStepCell)
    func didTypeTextAddIngredient(text : String , cell : NewRecipeIngredientCell)
}

class AddNewRecipeContentController : UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var delegate : AddNewREcipeContentControllerDelegate?
    private let headerId = "headerId"
    private let ingredientCell = "ingredientCell"
    private let stepCell = "stepCell"
    
    var ingredientCount = 0
    var stepCount = 0
    var seletcedStepCell : NewRecipeStepCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(AddNewRecipeContentHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(NewRecipeIngredientCell.self, forCellWithReuseIdentifier: ingredientCell)
        collectionView.register(NewRecipeStepCell.self, forCellWithReuseIdentifier: stepCell)
        collectionView.keyboardDismissMode = .interactive
    }
    
    init(){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AddNewRecipeContentHeader
        header.delegate = self
        header.section = indexPath.section
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 40)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return ingredientCount
        }else{
            return stepCount
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ingredientCell, for: indexPath) as! NewRecipeIngredientCell
            cell.ingredientDeleage = self
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: stepCell, for: indexPath) as! NewRecipeStepCell
            cell.stepDeleage = self
            return cell
        }
 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return .init(width: view.frame.width, height: 27)
        }else{
            let imageHeight = view.frame.width / 16 * 9
            let height = imageHeight + 45
            return .init(width: view.frame.width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 23, left: 0, bottom: 40, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
}

extension AddNewRecipeContentController : AddNewRecipeContentHeaderDelegate{
    func didTapToAddNewContent(section : Int) {
        if section == 0{
            ingredientCount += 1
        }else{
            stepCount += 1
        }
        collectionView.reloadData()
    }
}

extension AddNewRecipeContentController : NewRecipeStepCellDelegate, NewRecipeIngredientCellDeleagate{
    func didTapSelectStepImage(cell : NewRecipeStepCell) {
        delegate?.didTapAddNewStepImageButton(cell: cell)
    }
    
    func didAddTextInStep(text: String, cell : NewRecipeStepCell) {
        delegate?.didTypeAddNewStepContent(text: text, cell: cell)
    }
    
    func didTypeTextAddIngredient(text : String , cell : NewRecipeIngredientCell){
        delegate?.didTypeTextAddIngredient(text: text, cell: cell)
    }
    
}
