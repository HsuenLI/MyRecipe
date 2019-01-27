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

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout{
            layout.sectionInset = .init(top: cellPading, left: cellPading, bottom: cellPading, right: cellPading)
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Menu"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 40), NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 240, green: 96, blue: 98)
        
    }


}

extension HomeController : UICollectionViewDelegateFlowLayout{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width-(2*cellPading)
        return CGSize(width: width, height: 200)
    }
    
    
}

