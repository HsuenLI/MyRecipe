//
//  DetailsController.swift
//  JamMaker
//
//  Created by Hsuen-Ju Li on 2019/1/28.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class DetailsController : UICollectionViewController {
    
    let headerId = "headerId"
    let ingredientCellId = "ingredientCellId"
    let stepsCellId = "stepsCellId"
    let cellPadding : CGFloat = 8
    let productInstructionTitle = ["Ingredients", "Steps"]
    var selectedProduct : Product?
    
    var ingredients = [Ingredient]()
    var steps = [Step]()
    
    lazy var detailHeader : DetailHeaderCell = {
        let dh = DetailHeaderCell()
        dh.detailsController = self
        return dh
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupNavigation()
        setupCollectionView()
        fetchProductDetails()
    }
    
    fileprivate func fetchProductDetails(){
        guard let selectedProduct = selectedProduct else {return}
        
        var sortIngredient = [Ingredient]()
        for ingredient in selectedProduct.ingredients!{
            sortIngredient.append(ingredient as! Ingredient)
        }
        ingredients = sortIngredient.sorted { (i1, i2) -> Bool in
            i1.input?.compare(i2.input!) == .orderedAscending
        }
        
        var sortSteps = [Step]()
        for step in selectedProduct.steps!{
            sortSteps.append(step as! Step)
        }
        
        steps = sortSteps.sorted(by: { (s1, s2) -> Bool in
            s1.count < s2.count
        })
    }
    
    fileprivate func setupNavigation(){
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = selectedProduct?.title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : Color.textColor.value]
    }
    
    fileprivate func setupCollectionView(){
        collectionView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        collectionView.register(DetailHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(IngredientCell.self, forCellWithReuseIdentifier: ingredientCellId)
        collectionView.register(StepsCell.self, forCellWithReuseIdentifier: stepsCellId)
        //collectionView.customCollectionViewLayout(cellPadding: cellPadding)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension DetailsController : UICollectionViewDelegateFlowLayout{
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! DetailHeaderCell
        
        header.titleLabel.text = productInstructionTitle[indexPath.section]
        header.arrowButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        header.arrowButton.tag = indexPath.section
        return header
    }
    
    @objc func buttonPressed(button : UIButton){
        guard let product = selectedProduct else {return}
        if button.tag == 0 {
            var indexPaths = [IndexPath]()
            for row in ingredients.indices{
                let indexPath = IndexPath(row: row, section: 0)
                indexPaths.append(indexPath)
            }
            product.isIngredientExpandable = !product.isIngredientExpandable
            button.setImage(product.isIngredientExpandable ? UIImage(named: "arrow_down")?.withRenderingMode(.alwaysOriginal) : UIImage(named: "arrow_up")?.withRenderingMode(.alwaysOriginal), for: .normal)
            if product.isIngredientExpandable{
                collectionView.deleteItems(at: indexPaths)
            }else{
                collectionView.insertItems(at: indexPaths)
            }
        }else{
            var indexPaths = [IndexPath]()
            for row in steps.indices{
                let indexPath = IndexPath(row: row, section: 1)
                indexPaths.append(indexPath)
            }
            
            product.isStepsExpandable = !product.isStepsExpandable
            button.setImage(product.isStepsExpandable ? UIImage(named: "arrow_down")?.withRenderingMode(.alwaysOriginal) : UIImage(named: "arrow_up")?.withRenderingMode(.alwaysOriginal), for: .normal)
            if product.isStepsExpandable{
                
                collectionView.deleteItems(at: indexPaths)
            }else{
                collectionView.insertItems(at: indexPaths)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width - (2*cellPadding)
        return CGSize(width: width, height: 40)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return productInstructionTitle.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let product = selectedProduct{
            if section == 0{
                if product.isIngredientExpandable{
                    return 0
                }
                return ingredients.count
            }else{
                if product.isStepsExpandable{
                    return 0
                }
                return steps.count
            }
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let ingredientCell = collectionView.dequeueReusableCell(withReuseIdentifier: ingredientCellId, for: indexPath) as! IngredientCell
            ingredientCell.ingredient = ingredients[indexPath.row]
            return ingredientCell
        }
        let stepsCell = collectionView.dequeueReusableCell(withReuseIdentifier: stepsCellId, for: indexPath) as! StepsCell
        stepsCell.step = steps[indexPath.item]
        return stepsCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - (2*cellPadding)
        if indexPath.section == 0 {
            return CGSize(width: width, height: 50)
        }
        let height = 4 + 80 + 4 + (width * 0.8) + 5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
