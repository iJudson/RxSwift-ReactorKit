//
//  UIStoryboard+Instantiate.swift
//  RxBasicInterface
//
//  Created by 陈恩湖 on 2017/9/10.
//  Copyright © 2017年 Judson. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    
    static func getViewController(with identifier: String) -> UIViewController {
        return UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: identifier)
    }
    
    struct NavigationController {
        
        static var home: UINavigationController {
            return UIStoryboard.getViewController(with: "HomeViewControllerNav")  as! UINavigationController
        }
        static var medium: UINavigationController {
            return UIStoryboard.getViewController(with: "MediumViewControllerNav")  as! UINavigationController
        }
        static var broadcast: UINavigationController {
            return UIStoryboard.getViewController(with: "BroadcastViewControllerNav")  as! UINavigationController
        }
        static var group: UINavigationController {
            return UIStoryboard.getViewController(with: "GroupViewControllerNav")  as! UINavigationController
        }
        static var profile: UINavigationController {
            return UIStoryboard.getViewController(with: "ProfileViewControllerNav")  as! UINavigationController
        }
    }
    
    struct ViewController {
        static var home: HomeViewController {
            return UIStoryboard.getViewController(with: "HomeViewController") as! HomeViewController
        }
        static var discovery: MediumViewController {
            return UIStoryboard.getViewController(with: "MediumViewController") as! MediumViewController
        }
        static var broadcast: BroadcastViewController {
            return UIStoryboard.getViewController(with: "BroadcastViewController") as! BroadcastViewController
        }
        static var group: GroupViewController {
            return UIStoryboard.getViewController(with: "GroupViewController") as! GroupViewController
        }
        static var profile: ProfileViewController {
            return UIStoryboard.getViewController(with: "ProfileViewController") as! ProfileViewController
        }
    }
}
