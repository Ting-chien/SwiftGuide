//
//  MainViewController.swift
//  SwiftGuide
//
//  Created by 王庭謙 on 2020/6/7.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let categoryList = [
        ["CustomTextField", "ImageDownloader"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "UIKit related SDK"
        case 1:
            return "Functional applied"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = categoryList[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let identifier = categoryList[indexPath.section][indexPath.row]
        let storyboard = UIStoryboard(name: identifier, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier+"ViewController")
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

