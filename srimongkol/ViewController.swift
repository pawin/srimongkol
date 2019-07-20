//
//  ViewController.swift
//  srimongkol
//
//  Created by win on 20/7/19.
//  Copyright © 2019 Srimongkol. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            let viewController = DateListViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            self.present(navigationController, animated: false)
        }
    }


}

