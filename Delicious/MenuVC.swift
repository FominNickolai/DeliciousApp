//
//  MenuVC.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/21/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit

class MenuVC: UITableViewController {
    
    let cellId = "cellId"
    
    var menuItems = ["Main Menu", "Favorites", "Shopping List", "Recomendations", "New Recipes", "Exit"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = #imageLiteral(resourceName: "Background")
        let imageView = UIImageView(image: backgroundImage)
        
        tableView.register(MenuCell.self, forCellReuseIdentifier: cellId)
        
        tableView.backgroundView = imageView
        tableView.estimatedRowHeight = 45
        tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        tableView.separatorStyle = .none
        
    }
    
    deinit {
        print("MenuVC Deinit")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MenuCell
        
        // Configure the cell...
        cell.menuItem = menuItems[indexPath.row]
        
        return cell
    }
    
}
