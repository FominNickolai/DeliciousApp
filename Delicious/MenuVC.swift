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
    
    enum MenuItems: String {
        case NewRecipe = "New Recipes"
        case Exit = "Exit"
    }
    
    weak var mainVC: MainVC?
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let cellId = "cellId"
    
    var menuItems = [MenuItems.NewRecipe, MenuItems.Exit]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let backgroundImage = UIImage(named: "Background")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        
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
//MARK: UITableViewDataSource
extension MenuVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MenuCell
        
        cell.menuItem = menuItems[indexPath.row].rawValue
        
        return cell
    }
}
//MARK: UITableViewDelegate
extension MenuVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch menuItems[indexPath.item] {
        case .NewRecipe:
            mainVC?.showAddVC()
        case .Exit:
            mainVC?.handleLogOutButton()
        }
    }
    
}
