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
    let cellPading : CGFloat = 10
    let initImageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "sample")
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    var products = [Product]()
    
    fileprivate func initialImageViewWithoutProduct() {
        if products.count == 0{
            initImageView.isHidden = false
            if let window = UIApplication.shared.keyWindow{
                window.addSubview(initImageView)
                initImageView.anchor(top: window.topAnchor, left: window.leftAnchor, bottom: nil, right: window.rightAnchor, paddingTop: 120, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 300)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateHome), name: NewItemController.notificationUpdateHome, object: nil)
        collectionView.backgroundColor = .white
        collectionView.register(HomeMenuCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.customCollectionViewLayout(cellPadding: cellPading)
        
        setupNavigation()
        fetchProduct()
        
        initialImageViewWithoutProduct()
        
    }
    
    @objc func handleUpdateHome(){
        products.removeAll()
        fetchProduct()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        initialImageViewWithoutProduct()
    }
    
    fileprivate func setupNavigation(){
        let backIcon = UIImage(named: "back_icon")
        navigationController?.navigationBar.backIndicatorImage = backIcon
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backIcon
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: self, action: nil)
        
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
        initImageView.isHidden = true
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
        return products.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeMenuCell
        cell.product = products[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width-(2*cellPading)
        return CGSize(width: width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsController = DetailsController(collectionViewLayout : UICollectionViewFlowLayout())
        detailsController.selectedProduct = products[indexPath.item]
        navigationController?.pushViewController(detailsController, animated: true)
    }
    
}

//Fetch Data
extension HomeController{
    func fetchProduct(){
        let request : NSFetchRequest<Product> = Product.fetchRequest()
        let descriptor = NSSortDescriptor(key: "title", ascending: true)
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
        let newItemController = NewItemController(collectionViewLayout : UICollectionViewFlowLayout())
        newItemController.selectedProduct = products[indexPath.item]
        navigationController?.pushViewController(newItemController, animated: true)
    }
    
    
    func handleHomeCellDelete(cell: HomeMenuCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        let selectedProduct = products[indexPath.item]
        self.products.remove(at: indexPath.item)
        context.delete(selectedProduct)
        saveProduct()
        collectionView.deleteItems(at: [indexPath])
        collectionView.reloadData()
        self.initialImageViewWithoutProduct()
    }
    

 
}

