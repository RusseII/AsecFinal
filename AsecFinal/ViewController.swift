//
//  ViewController.swift
//  AsecAR
//
//  Created by Russell Ratcliffe on 10/8/17.
//  Copyright © 2017 DeepHire. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import SwiftSpinner
import SwiftyJSON
import Alamofire
import Alamofire_Synchronous


class ARController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = ARWorldTrackingConfiguration.PlaneDetection.horizontal
        sceneView.session.run(configuration)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let alert = UIAlertController(title: "Room Number", message: "Enter the room number of the room that you want to go to", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
            textField.keyboardType = .numberPad
            textField.textAlignment = .center
            //textField.cent
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
              SwiftSpinner.show("Creating Paths...")

            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
                // Put your code which should be executed with a delay here
                self.createPathObjects(number: (textField?.text!)!)
                SwiftSpinner.hide()
                
            })
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func emersonButton(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func mybuttom(_ sender: Any) {
    }

    
    func createPathObjects(number: String ) {
   
        
        
        

        let response =  Alamofire.request("http://104.196.195.245/coords?start=start&end=\(number)").responseJSON()
        var jsonData = JSON(response.result.value!)
        var jsonArray = jsonData["data"].array

//
//
//
//
//
       
        
        
        //        comment this ack in for request
        var coords = jsonArray!
        
//      var coords: JSON = [["x": 50, "y": 20, "z": 9.9568], ["x": 50, "y": 20, "z": 0], ["x": 53.7084, "y": (20 ), "z": 0], ["x": 53.7084, "y": (20 ), "z": -5.9182], ["x": 73.5204, "y": (20 ), "z": -5.9182] ]
        
        
        
       //3.7084000000000006
        //var x = [(55,20,15), (55,30,15), (55,30,15)]

//        var currentStartLocation = myCameraCoordinates()
//        currentStartLocation.x = 0
//        currentStartLocation.y = 0
//        currentStartLocation.z = 0
        var cc = getCameraCoordinates(sceneView: sceneView)
        
        print(coords, "Hi guys is this an optionAL?")
        for (index, _) in coords.enumerated() {
            print(index, "WOW!!")
            if index != (coords.count) - 1 {
                print("z")
            //make sure it doesn't crash on the final coordinate
                print(coords)
                print(coords[index])
                print(coords[index + 1]["x"].float!)
                            var xdistance = (coords[index]["x"].float! - coords[index + 1]["x"].float!)
                            var ydistance = (coords[index]["y"].float! - coords[index + 1]["y"].float!)
                            var zdistance = (coords[index]["z"].float! - coords[index + 1]["z"].float!)
                print(xdistance,ydistance, zdistance, "distances")
                
                var cos1 = Float(0.0)
                var cos2 = Float(0.0)
                var cos3 = Float(0.0)
                
                var newdx = Float(0.0)
                var newdy = Float(0.0)
                var newdz = Float(0.0)


                if xdistance < 0 {
                    xdistance = (xdistance * -1)
                    cos2 = Float(0.1)
                    cos3 = Float(0.1)
                    newdx = (xdistance/2)
                    cc.x += newdx
                }
                else if ydistance < 0 {
                    ydistance = (ydistance * -1)
                    cos1 = Float(0.1)
                    cos3 = Float(0.1)
                    newdy = (ydistance/2)
                    cc.y += newdy
                }
                else if zdistance < 0 {
                    zdistance = (zdistance * -1)
                    cos1 = Float(0.1)
                    cos2 = Float(0.1)
                    newdz = -(zdistance/2)
                    cc.z += newdz

                }
                
                else if xdistance > 0 {
                    cos2 = Float(0.1)
                    cos3 = Float(0.1)
                    newdx = -(xdistance/2)
                    cc.x += newdx
                }
                else if ydistance > 0 {
                    cos1 = Float(0.1)
                    cos3 = Float(0.1)
                    newdy = -(ydistance/2)
                    cc.y += newdy

                }
                else if zdistance > 0 {
                    cos1 = Float(0.1)
                    cos2 = Float(0.1)
                    newdz = (zdistance/2)
                    cc.z -= newdz
                }
                
            
                
//                cc.x = cc.x + (xdistance/2) //plus for right minus for left add a check to see
                print(xdistance, ydistance, zdistance)
                //comment next to lines back in
//                cc.y =  cc.y - (ydistance/2)
//                cc.z =  cc.z - (zdistance/2) + 0.2
            
            var cubeNode = SCNNode(geometry: SCNBox(width: CGFloat((xdistance + cos1)), height: CGFloat((ydistance) + cos2), length: CGFloat((zdistance) + cos3) , chamferRadius:0))
                        cubeNode.position = SCNVector3( cc.x , cc.y - 1  ,  cc.z)
                print("testing", xdistance + cos1)
                //makes it colored
//
                cc.x += xdistance/2
//                cc.y -= ydistance/2
                
                cc.z -= zdistance/2
            
                if xdistance > 0{
                     cubeNode.geometry?.firstMaterial?.diffuse.contents  = UIColor.red
//                        cc.x += 0.2
                }
                if ydistance > 0{
                     cubeNode.geometry?.firstMaterial?.diffuse.contents  = UIColor.yellow
//                    cc.y += 0.2
                }
                if zdistance > 0 {
                     cubeNode.geometry?.firstMaterial?.diffuse.contents  = UIColor.red
//                    cc.z += 0.2
                }
                //z is forward back, y up down x is left right
               
           sceneView.scene.rootNode.addChildNode(cubeNode)
            
            //currentStartLocation keeps track of where initial position should be set
        
                
            }
        }
    }


    
    struct myCameraCoordinates {
        var x = Float()
        var y = Float()
        var z = Float()
    }
    
    func getCameraCoordinates(sceneView:ARSCNView) -> myCameraCoordinates {
        let cameraTransform = sceneView.session.currentFrame?.camera.transform
        let cameraCoordinates = MDLTransform(matrix: cameraTransform!)
        
        var cc = myCameraCoordinates()
        cc.x = cameraCoordinates.translation.x
        cc.y = cameraCoordinates.translation.y
        cc.z = cameraCoordinates.translation.z
        print(cc.x, cc.y, cc.z, "coords")
        cc.x = 0
        cc.y = 0
        cc.z = 0
        
        return cc
    }
    
}


