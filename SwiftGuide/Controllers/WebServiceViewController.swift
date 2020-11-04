//
//  WebServiceViewController.swift
//  SwiftGuide
//
//  Created by TING-CHIEN WANG on 2020/11/4.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import UIKit

class WebServiceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let methods = ["GET", "POST"]
    
    let baseGetURL = "https://httpbin.org/get"
    let basePostURL = "https://httpbin.org/post"

    let getParameters = ["para1":"value1","para2":"value2"]
    let getHeaders = ["header1":"value1","header2":"value2"]
    let postJSON = ["para1":"value1","para2":"value2"]
    let postURLencoded = "para1=value1&para2%5Bvalue21%5D=value22"
    let postFormData = ["para1":"value1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return methods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        cell.textLabel?.text = methods[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let manager = WSManager()
        
        switch indexPath.row {
        case 0:
            manager.requestWithUrl(urlString: baseGetURL, parameters: getParameters) { (data) -> (Void) in
                print(data.parseData().description)
            }
        default:
            break
        }
    }
    
}

extension Data{
    func parseData() -> NSDictionary{
        
        let dataDict = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) as! NSDictionary
        
        return dataDict!
    }
    
    mutating func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
