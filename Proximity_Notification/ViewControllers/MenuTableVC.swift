
//
//  MenuTableVC.swift
//  Proximity_Notification
//
//  Created by Yeontae Kim on 10/25/17.
//  Copyright © 2017 YTK. All rights reserved.
//

import UIKit

class MenuTableVC: UITableViewController {
     
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showSearch" {
            let tabViewControllers = segue.destination as! UITabBarController
            let nav = tabViewControllers.viewControllers![1] as! UINavigationController
            let destinationViewController = nav.viewControllers.first as! SearchPlantVC
        }
    }

}

