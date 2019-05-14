//
//  SecondViewController.swift
//  Geobriku_Map
//
//  Created by Kristine Legzdina on 23/04/2019.
//  Copyright © 2019 Kristine Legzdina. All rights reserved.
//

import UIKit
protocol secondControllerDelagate {
    func enableFilterKm (dist: Bool)
    func enableFilterDesc (noDes: Bool)
}
class SecondViewController: UIViewController {
    
    @IBOutlet weak var withoutDescription: UISwitch!
    @IBOutlet weak var filter10km: UISwitch!
    var boolForDesc : Bool = false
    var boolForFilter10 : Bool = false
    
    var delegate: secondControllerDelagate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        withoutDescription.isOn = UserDefaults.standard.bool(forKey: "switch1")
        filter10km.isOn = UserDefaults.standard.bool(forKey: "switch2")
    }
    
    @IBAction func descFilter(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "switch1")
        if withoutDescription.isOn{
            boolForDesc = true
        }
        else{
            boolForDesc = false
        }
        if delegate != nil{
            delegate?.enableFilterDesc(noDes: boolForDesc)
        }
    }
    
    @IBAction func kmFilter(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "switch2")
        if filter10km.isOn{
            boolForFilter10 = true
        }else{
            boolForFilter10 = false
        }
        if delegate != nil{
            delegate?.enableFilterKm(dist: boolForFilter10)
        }
    }
}
