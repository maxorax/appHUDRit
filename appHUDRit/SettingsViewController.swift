//
//  SettingsViewController.swift
//  appHUDRit
//
//  Created by Maxorax on 20.03.2021.
//

import UIKit


class SettingsViewController: UIViewController {
    
    var mSys = "км"
    var koef = 1.0
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        if mSys == "км" {
            segmentedControl.selectedSegmentIndex = 0
        } else {
            segmentedControl.selectedSegmentIndex = 1
        }
            self.segmentedControl.addTarget(self, action: #selector(selectedValue), for: .valueChanged)
    }
    
    @objc func selectedValue(target: UISegmentedControl){
        guard target == self.segmentedControl else {
            return
        }
        switch target.selectedSegmentIndex {
        case 0:
            mSys = "км"
            koef = 1.0
        case 1:
            mSys = "миль"
            koef = 0.621371
        default:
            return
        }
    }
}
