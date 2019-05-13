//
//  CustomNavigationController.swift
//  DairySaver
//
//  Created by Hsuen-Ju Li on 2019/5/7.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class CustomNavigationController : UINavigationController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = Color.theme.value
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "ChalkboardSE-Bold", size: 17)!, NSAttributedString.Key.foregroundColor: Color.textColor.value]
        navigationBar.tintColor = UIColor.white
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationBar.backIndicatorImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
        navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
