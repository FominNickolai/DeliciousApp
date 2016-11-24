//
//  MenuVC.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/21/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class MenuVC: UIViewController {
    
    weak var mainVC: MainVC?
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let cellId = "cellId"
    
    var menuItems = ["Main Menu", "Favorites", "Shopping List", "Recomendations", "New Recipes", "Exit"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let backgroundImage = #imageLiteral(resourceName: "Background")
        let imageView = UIImageView(image: backgroundImage)
        
        tableView.backgroundView = imageView
        tableView.estimatedRowHeight = 45
        tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        tableView.separatorStyle = .none
        
        tableView.register(MenuCell.self, forCellReuseIdentifier: cellId)

    }
    
    deinit {
        print("MenuVC Deinit")
    }
    
}

extension MenuVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MenuCell
        
        // Configure the cell...
        cell.menuItem = menuItems[indexPath.row]
        
        return cell
    }
}

extension MenuVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            dismiss(animated: true, completion: nil)
        case 4:
            mainVC?.showAddVC()
        case 5:
            mainVC?.handleLogOutButton()
        default:
            break
        }
    }
    
}
