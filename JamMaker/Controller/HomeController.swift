//
//  ViewController.swift
//  JamMaker
//
//  Created by Hsuen-Ju Li on 2019/1/27.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController {
    
    let cellId = "cellId"
    let cellPading : CGFloat = 10

    var items : [Item] = [Item(image: "kiwi", title: "Kiwi Jam"),
                          Item(image: "strawberry", title: "Strawberry Jam")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(HomeMenuCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.customCollectionViewLayout(cellPadding: cellPading)
        let backIcon = UIImage(named: "back_icon")
        navigationController?.navigationBar.backIndicatorImage = backIcon
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backIcon
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: self, action: nil)
        
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    fileprivate func setupNavigation(){
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Menu"
        navigationController?.navigationBar.largeTitleTextAttributes = attributedText(fontSize: 40)
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 240, green: 96, blue: 98)
        navigationController?.navigationBar.titleTextAttributes = attributedText(fontSize: 14)
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 240, green: 96, blue: 98)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddItem))
        navigationController?.navigationBar.tintColor = UIColor.rgb(red: 233, green: 206, blue: 111)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    @objc func handleAddItem(){
        let newItemController = NewItemController(collectionViewLayout : UICollectionViewFlowLayout())
        navigationController?.pushViewController(newItemController, animated: true)
    }
    
    fileprivate func attributedText(fontSize : CGFloat) -> [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: fontSize), NSAttributedString.Key.foregroundColor : UIColor.customTextColor()]
    }
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension HomeController : UICollectionViewDelegateFlowLayout{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeMenuCell
        cell.item = items[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width-(2*cellPading)
        return CGSize(width: width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsController = DetailsController(collectionViewLayout : UICollectionViewFlowLayout())
        navigationController?.pushViewController(detailsController, animated: true)
    }
    
}

struct Item{
    let image : String
    let title : String
    
    init(image:String,title:String){
        self.image = image
        self.title = title
    }
}

