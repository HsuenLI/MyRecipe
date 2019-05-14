//
//  AddNewRecipeHomeCell.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/14.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

protocol AddNewRecipeHomeCellDelegate {
    func didTapAddNewStepImageButton(cell: NewRecipeStepCell)
    func didTypeAddNewStepContent(text: String, cell: NewRecipeStepCell)
    func didTypeTextAddIngredient(text : String , cell : NewRecipeIngredientCell)
}

class AddNewRecipeHomeCell : UICollectionViewCell{
    
    let addNewRecipeContentController = AddNewRecipeContentController()
    var delegate : AddNewRecipeHomeCellDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let contentView = addNewRecipeContentController.view else{return}
        addSubview(contentView)
        addNewRecipeContentController.delegate = self
        contentView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddNewRecipeHomeCell : AddNewREcipeContentControllerDelegate{
    func didTypeTextAddIngredient(text: String, cell: NewRecipeIngredientCell) {
        delegate?.didTypeTextAddIngredient(text: text, cell: cell)
    }
    
    func didTypeAddNewStepContent(text: String, cell: NewRecipeStepCell) {
        delegate?.didTypeAddNewStepContent(text: text, cell: cell)
    }
    
    func didTapAddNewStepImageButton(cell: NewRecipeStepCell) {
        delegate?.didTapAddNewStepImageButton(cell: cell)
    }
}
