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
    let productInstructionTitle = ["Ingredient", "Steps"]
    
    let products = Prodcuts(title: "Kiwi Jam", ingredients: [Ingredient(name: "kiwi", input: "180g"), Ingredient(name: "sugar", input: "180g"),Ingredient(name: "lemon juice", input: "2tp")], steps: [Steps(name: "1. Cut to slice"), Steps(name: "2. Fill lemon juice and sugar"), Steps(name: "3. Waiting around 5 minutes"), Steps(name: "4. Put in container for one day")])
    var ingredient = [Ingredient]()
    var steps = [Steps]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = products.title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.customTextColor()]
        collectionView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        collectionView.register(DetailHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(IngredientCell.self, forCellWithReuseIdentifier: ingredientCellId)
        collectionView.register(StepsCell.self, forCellWithReuseIdentifier: stepsCellId)
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout{
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 2*cellPadding, right: 0)
        }

        collectionView.contentInset = UIEdgeInsets(top: cellPadding, left: cellPadding, bottom: 0, right: cellPadding)
        ingredient = products.ingredient
        steps = products.step
    }
}

extension DetailsController : UICollectionViewDelegateFlowLayout{
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! DetailHeaderCell
        
        header.titleLabel.text = productInstructionTitle[indexPath.section]
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width - (2*cellPadding)
        return CGSize(width: width, height: 40)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return productInstructionTitle.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return ingredient.count
        }
        return steps.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let ingredientCell = collectionView.dequeueReusableCell(withReuseIdentifier: ingredientCellId, for: indexPath) as! IngredientCell
            ingredientCell.titleLabel.text = ingredient[indexPath.row].name
            ingredientCell.inputLabel.text = ingredient[indexPath.row].input
            return ingredientCell
        }
        let stepsCell = collectionView.dequeueReusableCell(withReuseIdentifier: stepsCellId, for: indexPath) as! StepsCell
        stepsCell.titleLabel.text = steps[indexPath.row].name
        stepsCell.photoImageView.image = UIImage(named: "strawberry")
        return stepsCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - (2*cellPadding)
        if indexPath.section == 0 {
            return CGSize(width: width, height: 50)
        }
        return CGSize(width: width, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}

struct Ingredient{
    let name : String
    let input : String
    
    init(name : String, input : String){
        self.name = name
        self.input = input
    }
}

struct Steps{
    let name : String
    init(name : String) {
        self.name = name
    }
}

struct Prodcuts{
    let title : String
    let ingredient : [Ingredient]
    let step : [Steps]
    
    init(title  : String , ingredients : [Ingredient] , steps : [Steps]){
        self.title = title
        self.ingredient = ingredients
        self.step = steps
    }
}

