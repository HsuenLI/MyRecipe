//
//  NewItemController.swift
//  JamMaker
//
//  Created by Hsuen-Ju Li on 2019/2/2.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class NewItemController : UICollectionViewController{
    
    let headerId = "headerId"
    let cellId = "cellId"
    let cellPadding : CGFloat = 8
    let productInstructionTitle = ["Ingredient", "Steps"]
    let itemTitleTextField : UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Enter product name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25)])
        tf.font = UIFont.boldSystemFont(ofSize: 25)
        tf.textAlignment = .center
        tf.textColor = UIColor.customTextColor()
        return tf
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        collectionView.backgroundColor = .white
        collectionView.register(NewItemHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.customCollectionViewLayout(cellPadding: cellPadding)
        
        navigationController?.navigationBar.addSubview(itemTitleTextField)
        if let navigationBar = navigationController?.navigationBar{
            itemTitleTextField.anchor(top: navigationBar.topAnchor, left: navigationBar.leftAnchor, bottom: navigationBar.bottomAnchor, right: navigationBar.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 0, height: 0)
            itemTitleTextField.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor).isActive = true
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        itemTitleTextField.isHidden = true
    }
}

extension NewItemController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width - (2*cellPadding)
        return CGSize(width: width, height: 40)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! NewItemHeader
        header.titleLabel.text = productInstructionTitle[indexPath.section]
        return header
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return productInstructionTitle.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - (2*cellPadding)
        return CGSize(width: width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
