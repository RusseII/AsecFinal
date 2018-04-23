//
//  SettingsViewController.swift
//  AsecFinal
//
//  Created by Tyler Lennox on 4/22/18.
//  Copyright © 2018 DeepHire. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var wheelBool: UISwitch!

    @IBAction func wheelBoolPressed(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wheelBool.isOn = UserDefaults.standard.bool(forKey: "switchState")
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
