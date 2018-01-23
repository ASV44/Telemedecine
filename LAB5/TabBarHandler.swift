//
//  TabBarHandler.swift
//  LAB5
//
//  Created by Hackintosh on 1/13/18.
//  Copyright © 2018 Hackintosh. All rights reserved.
//

import UIKit

class TabBarHandler: NSObject, UITabBarDelegate {
    
    private var tabBar: UITabBar!
    
    private let middleIconName = "addIcon"
    
    private override init() {
        super.init()
    }
    
    static let shared = TabBarHandler()
    
    func setTabBar(_ tabBar: UITabBar) {
        self.tabBar = tabBar
        self.tabBar.delegate = self
        initTabBarMiddleIcon()
    }
    
    func initTabBarMiddleIcon() {
        let addIcon = UIImage(named: middleIconName)!.withRenderingMode(.alwaysOriginal)
        let middleItem = Int(tabBar.items!.count / 2)
        tabBar.items![middleItem] = UITabBarItem(title: nil, image: addIcon, selectedImage: nil)
    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(tabBar.items?.index(of: item)!)
    }
}
