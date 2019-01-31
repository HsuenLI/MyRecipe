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
    
    var products = Prodcuts(isIngredientExpandable: false, isStepExpandable: false, title: "Kiwi Jam", ingredients: [Ingredient(name: "kiwi", input: "180g"), Ingredient(name: "sugar", input: "180g"),Ingredient(name: "lemon juice", input: "2tp")], steps: [Steps(step: 1, name: "Cut to slice", photoImage: "kiwi"), Steps(step: 2, name: "Fill lemon juice and sugar", photoImage: "kiwi"), Steps(step: 3, name: "Waiting around 5 minutes", photoImage: "kiwi"), Steps(step: 4, name: "Put in container for one day", photoImage: "kiwi")])
    
    var ingredient = [Ingredient]()
    var steps = [Steps]()
    
    lazy var detailHeader : DetailHeaderCell = {
        let dh = DetailHeaderCell()
        dh.detailsController = self
        return dh
    }()
    
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
        if button.tag == 0 {
            var indexPaths = [IndexPath]()
            for row in ingredient.indices{
                let indexPath = IndexPath(row: row, section: 0)
                indexPaths.append(indexPath)
            }
            products.isIngredientExpandable = !products.isIngredientExpandable
            button.setImage(products.isIngredientExpandable ? UIImage(named: "arrow_down")?.withRenderingMode(.alwaysOriginal) : UIImage(named: "arrow_up")?.withRenderingMode(.alwaysOriginal), for: .normal)
            if products.isIngredientExpandable{
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
            
            products.isStepExpandable = !products.isStepExpandable
            button.setImage(products.isStepExpandable ? UIImage(named: "arrow_down")?.withRenderingMode(.alwaysOriginal) : UIImage(named: "arrow_up")?.withRenderingMode(.alwaysOriginal), for: .normal)
            if products.isStepExpandable{
                
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
        if section == 0{
            if products.isIngredientExpandable{
                return 0
            }
            return ingredient.count
        }else{
            if products.isStepExpandable{
                return 0
            }
            return steps.count
        }
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




struct Ingredient{
    let name : String
    let input : String
    
    init(name : String, input : String){
        self.name = name
        self.input = input
    }
}

struct Steps{
    let step : Int
    let name : String
    let photoImage : String
    
    init(step: Int, name : String , photoImage : String){
        self.step = step
        self.name = name
        self.photoImage = photoImage
    }
    
}

struct Prodcuts{
    var isIngredientExpandable : Bool
    var isStepExpandable : Bool
    var title : String
    var ingredient : [Ingredient]
    var step : [Steps]
    
    init(isIngredientExpandable : Bool, isStepExpandable : Bool , title  : String , ingredients : [Ingredient] , steps : [Steps]){
        
        self.isIngredientExpandable = isIngredientExpandable
        self.isStepExpandable = isStepExpandable
        self.title = title
        self.ingredient = ingredients
        self.step = steps
    }
}

