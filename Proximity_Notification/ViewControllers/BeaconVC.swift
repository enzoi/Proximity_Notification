
//
//  BeaconVC.swift
//  Proximity_Notification
//
//  Created by Yeontae Kim on 10/25/17.
//  Copyright © 2017 YTK. All rights reserved.
//

import UIKit
import CoreBluetooth

class BeaconVC: UIViewController, CBCentralManagerDelegate {
    
    @IBOutlet weak var scanToggleButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var centralManager: CBCentralManager!
    var isBluetoothPoweredOn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
        case .poweredOn:
            isBluetoothPoweredOn = true
            scanToggleButton.title = "Stop Scanning"
        case .poweredOff:
            isBluetoothPoweredOn = false
            scanToggleButton.title = "Scan"
        default:
            break
        }
    }
}


// MARK: Table View

extension BeaconVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "BeaconTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! BeaconTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // TODO: Send the Beacon Information to Detail ViewController
        
    }

}
