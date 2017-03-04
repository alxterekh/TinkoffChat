//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Alexander on 03/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, ConnectionManagerDelegate {
    
    @IBOutlet weak var peers: UITableView!
    
    var connectionManager: ConnectionManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        connectionManager = ConnectionManager()
        connectionManager.delegate = self
        peers.delegate = self
        peers.dataSource = self
    }
    
    // MARK: - UITableView related method implementation
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.0
    }
    
}






