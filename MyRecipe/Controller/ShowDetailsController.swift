//
//  ShowDetailsController.swift
//  MyRecipe
//
//  Created by Hsuen-Ju Li on 2019/5/16.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

struct ProductModel{
    let sectionName : String
    let content : [AnyObject]
    var isCallapsed : Bool
}

class ShowDetailsController : UICollectionViewController{
    
    private let  headerId = "headerId"
    private let titleCellId = "titleCellId"
    private let  ingredientCellId = "ingredientCellId"
    private let stepCellId = "stepCellId"
    
    var product : Product?
    var steps = [Step]()
    var ingredients = [Ingredient]()
    var productModel = [ProductModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(DetailsTitleCell.self, forCellWithReuseIdentifier: titleCellId)
        collectionView.register(DetailsIngredientCell.self, forCellWithReuseIdentifier: ingredientCellId)
        collectionView.register(DetailsStepCell.self, forCellWithReuseIdentifier: stepCellId)
        collectionView.register(DetailsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        navigationItem.title = product?.title
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.customNavigationBar()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEditProduct))
        fetchData()
        stepProductModel()
    }
    
    @objc func  handleEditProduct(){
        let editRecipeController = EditRecipeController()
        editRecipeController.product = product
        navigationController?.pushViewController(editRecipeController, animated: true)
    }
    
    private func stepProductModel(){
        //First item is fake date
        productModel = [ProductModel(sectionName: "title", content: [product!], isCallapsed: false), ProductModel(sectionName: "Ingredients", content: ingredients, isCallapsed: false), ProductModel(sectionName: "Steps", content: steps, isCallapsed: false)]
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

extension ShowDetailsController : UICollectionViewDelegateFlowLayout{
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return productModel.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! DetailsHeaderView
        header.titleButton.setTitle(productModel[indexPath.section].sectionName, for: .normal)
        header.delegate = self
        header.callapsed = productModel[indexPath.section].isCallapsed
        header.section = indexPath.section
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section{
        case 0:
            return .init(width: 0, height: 0)
       default :
            return .init(width: view.frame.width, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return .init(top: 0, left: 0, bottom: 0, right: 0)
        case 1:
            return .init(top: 9, left: 0, bottom: 0, right: 0)
        default:
            return .init(top: 20, left: 0, bottom: 0, right: 0)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let isCallapsed = productModel[section].isCallapsed
        switch section {
        case 0:
            return 1
        case 1:
            if !isCallapsed{
                return 0
            }
            return productModel[section].content.count
        default:
            if !isCallapsed{
                return 0
            }
            return productModel[section].content.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: titleCellId, for: indexPath) as! DetailsTitleCell
            cell.product = product
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ingredientCellId, for: indexPath) as! DetailsIngredientCell
            let ingredients : [Ingredient] = productModel[indexPath.section].content as! [Ingredient]
            cell.ingredient = ingredients[indexPath.item]
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: stepCellId, for: indexPath) as! DetailsStepCell
            let steps : [Step] = productModel[indexPath.section].content as! [Step]
            cell.step = steps[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section{
        case 0 :
            let height = view.frame.width / 16 * 9 + 36
            return .init(width: view.frame.width, height: height)
        case 1:
            return .init(width: view.frame.width, height: 40)
        default:
            let frame = CGRect(x: 0, y: 0, width: view.frame.width - 36, height: 280)
             let dummyCell = DetailsStepCell(frame: frame)
            dummyCell.textView.text = steps[indexPath.item].text
            dummyCell.layoutIfNeeded()
            let targetSize = CGSize(width: view.frame.width - 36, height: 1000)
            let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
            let height = max(280, estimatedSize.height + 5)
            return .init(width: view.frame.width, height: height)
        }
    }
}

extension ShowDetailsController : DetailsHeaderViewDelegate{
    
    func tapToCollapsedSection(section: Int, header: DetailsHeaderView) {
        var indexPaths = [IndexPath]()
        for item in productModel[section].content.indices{
            indexPaths.append(IndexPath(item: item, section: section))
        }
        let isCallapsed = productModel[section].isCallapsed
        productModel[section].isCallapsed = !isCallapsed
        header.setCollapsed(isCallapsed)
        if isCallapsed{
            collectionView.deleteItems(at: indexPaths)
        }else{
            collectionView.insertItems(at: indexPaths)
        }
    }
}
