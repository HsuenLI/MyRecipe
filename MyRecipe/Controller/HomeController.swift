//
//  ViewController.swift
//  JamMaker
//
//  Created by Hsuen-Ju Li on 2019/1/27.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit
import CoreData

class HomeController: UICollectionViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let cellId = "cellId"
    let emptyView = HomeEmptyView()

    var products = [Product]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateHome), name: NewItemController.notificationUpdateHome, object: nil)
        collectionView.backgroundColor = .white
        collectionView.backgroundView = emptyView
        collectionView.register(HomeMenuCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNavigation()
        fetchProduct()
        
        
    }
    
    @objc func handleUpdateHome(){
        products.removeAll()
        fetchProduct()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        setupNavigation()
        fetchProduct()
    }
    
    fileprivate func setupNavigation(){
        let backIcon = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorImage = backIcon
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backIcon
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: self, action: nil)
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Home"
        navigationController?.navigationBar.largeTitleTextAttributes = attributedText(fontSize: 40)
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(handleAddItem))
        navigationController?.navigationBar.tintColor = Color.customRed.value
    }
    
    @objc func handleAddItem(){
        let addNewRecipeController = NewRecipeController()
        navigationController?.pushViewController(addNewRecipeController, animated: true)
    }
    
    fileprivate func attributedText(fontSize : CGFloat) -> [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.font : UIFont.customFont(name: "BradleyHandITCTT-Bold", size: fontSize), NSAttributedString.Key.foregroundColor : Color.customRed.value]
    }
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension HomeController : UICollectionViewDelegateFlowLayout{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       emptyView.isHidden = products.count != 0
        return products.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeMenuCell
        cell.product = products[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 124)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsController = ShowDetailsController()
        detailsController.product = self.products[indexPath.item]
        navigationController?.pushViewController(detailsController, animated: true)
    }
    
}

//Fetch Data
extension HomeController{
    func fetchProduct(){
        let request : NSFetchRequest<Product> = Product.fetchRequest()
        let descriptor = NSSortDescriptor(key: "modifiedDate", ascending: false)
        request.sortDescriptors = [descriptor]
        do{
            products = try self.context.fetch(request)
        }catch let err{
            print("Failed to fetch product on home controller:", err)
        }
        
        collectionView.reloadData()
    }
    
    func saveProduct(){
        do{
            try context.save()
        }catch let err{
            print("Failed to save product on home controller:", err)
        }
    }
}

//Cell options button
extension HomeController : homeCellOptionsDelegate{
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func handleHomeCellEdit(cell: HomeMenuCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        print(indexPath)
        //let newItemController = NewItemController(collectionViewLayout : UICollectionViewFlowLayout())
       // newItemController.selectedProduct = products[indexPath.item]
       // navigationController?.pushViewController(newItemController, animated: true)
    }
    
    
    func handleHomeCellDelete(cell: HomeMenuCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        let selectedProduct = products[indexPath.item]
        self.products.remove(at: indexPath.item)
        context.delete(selectedProduct)
        saveProduct()
        collectionView.deleteItems(at: [indexPath])
        collectionView.reloadData()
    }
    

 
}


