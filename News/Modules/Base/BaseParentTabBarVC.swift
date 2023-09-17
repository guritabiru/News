//
//  BaseParentTabBarVC.swift
//  News
//
//  Created by Bimo Sekti Wicaksono on 13/09/23.
//

import UIKit

class BaseParentTabBarVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBinding()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = true
    }
    
    open func setupView(){}
    
    open func setupBinding(){}

}
