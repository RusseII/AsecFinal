//
//  EmersonsViewController.swift
//  AsecFinal
//
//  Created by Tyler Lennox on 4/22/18.
//  Copyright © 2018 DeepHire. All rights reserved.
//

import UIKit



class EmersonsViewController: UIViewController {
//    
//    var wheelChairState: Bool?
//    
//    override func viewWillAppear(_ animated: Bool) {
//        wheelChairState = 
//    }
    
    @IBOutlet var startTextField: UITextField!
    @IBOutlet var endTextField: UITextField!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let startValue = startTextField.text
        let endValue = endTextField.text
        
        if let destinationViewController = segue.destination as? ARController {
            destinationViewController.startValue = startValue
            destinationViewController.endValue = endValue
            print ("Start Value: \(startValue)")
            print ("End Value: \(endValue)")
        }
    }

    @IBAction func Navigate(_ sender: UIButton) {
        print("hello navigate")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
