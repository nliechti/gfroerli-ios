//
//  TableViewController.swift
//  gfrorli
//
//  Created by Niklas Liechti on 23.01.19.
//  Copyright © 2019 Niklas Liechti. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let request = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/")!)
        
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: {data, response, error -> Void in do {
            let jsonDecoder = JSONDecoder()
            let response = try jsonDecoder.decode(Sensor.self, from: data!)
            
            
        } catch {
            print("Error")
            }
        }).resume()
        
    }
}
