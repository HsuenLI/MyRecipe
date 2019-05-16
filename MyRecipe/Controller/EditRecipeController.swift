//
//  EditRecipeController.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/16.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class EditRecipeController : UICollectionViewController{
    
    var product : Product?
    var steps = [Step]()
    var ingredients = [Ingredient]()
    var productModel = [ProductModel]()
    
    private let titleCellId = "titleCellId"
    private let ingredientCellId = "ingredientCellId"
    private let stepCellId = "stepCellId"
    private let footerId = "footerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveButton))
        collectionView.backgroundColor = .white
        collectionView.register(NewRecipeTitleCell.self, forCellWithReuseIdentifier: titleCellId)
        collectionView.register(NewRecipeIngredientCell.self, forCellWithReuseIdentifier: ingredientCellId)
        collectionView.register(NewRecipeFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        collectionView.register(NewRecipeStepCell.self, forCellWithReuseIdentifier: stepCellId)
        fetchData()
    }
    
    @objc func handleSaveButton(){
        print("save")
    }
    
    private func  fetchData(){
        var unsortedStep = [Step]()
        for step in product!.steps!{
            let step = step as! Step
            unsortedStep.append(step)
        }
        let sortSteps = unsortedStep.sorted { (s1, s2) -> Bool in
            return s1.date!.compare(s2.date!) == .orderedAscending
        }
        self.steps = sortSteps
        
        var unsortedIngredient = [Ingredient]()
        for ingredient in product!.ingredients!{
            let ingredient = ingredient as! Ingredient
            unsortedIngredient.append(ingredient)
        }
        
        let sortIngredient = unsortedIngredient.sorted { (s1, s2) -> Bool in
            guard let firstDate = s1.date else {return false}
            guard let secondDate = s2.date else {return false}
            return firstDate.compare(secondDate) == .orderedAscending
        }
        self.ingredients = sortIngredient
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
        return productModel.count
    }
    
    
}
