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
import CoreLocation



class ARController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = ARWorldTrackingConfiguration.PlaneDetection.horizontal
//        configuration.worldAlignment = .gravityAndHeading

        sceneView.session.run(configuration)
        
//        var poo = CLHeading()
//        poo.trueHeading.n
//        print(poo.x, poo.y, poo.z, "CLHEADING")

        
    }
    
    var locationCallback: ((CLLocation) -> ())? = nil
    var headingCallback: ((CLLocationDirection) -> ())? = nil
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("ni")
        guard let currentLocation = locations.last else { return }
        locationCallback?(currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("ni")

        headingCallback?(newHeading.trueHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ni")

        print("⚠️ Error while updating location " + error.localizedDescription)
    }
    
    
    let locationManager: CLLocationManager = {
        
        $0.requestWhenInUseAuthorization()
        $0.startUpdatingHeading()
        return $0
    }(CLLocationManager())
    
    
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
    
    
   
    
    
 

    
//    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//    }
    
    func createPathObjects(number: String ) {
   
        
//
//
        let response =  Alamofire.request("http://35.185.12.212/coords?username=emerson&start=main_door_0&end=\(number)").responseJSON()

        var jsonData = JSON(response.result.value!)
        var jsonArray = jsonData["data"].array
        var coords = jsonArray!

//      var coords: JSON = [["x": 50, "y": 20, "z": 9.9568], ["x": 50, "y": 20, "z": 0], ["x": 53.7084, "y": (20 ), "z": 0], ["x": 53.7084, "y": (20 ), "z": -5.9182], ["x": 73.5204, "y": 20, "z": -5.9182] ]
//
        
//        var coords: JSON = [["x":0,"y":1,"z":0],["x":0,"y":1,"z":0],["x":0,"y":1,"z":-1.2565],["x":0,"y":1,"z":-2.9855],["x":-1.4308,"y":1,"z":-2.9855],["x":-2.4055,"y":1,"z":-2.9855],["x":-8.1498,"y":1,"z":-2.9855],["x":-8.1498,"y":1,"z":-5.9959],["x":-11.9744,"y":1,"z":-5.9959],["x":-11.9744,"y":1,"z":-7.3408]]
//
//         var coords: JSON = [["x":0,"y":1,"z":0],["x":0,"y":1,"z":0],["x":0,"y":1,"z":-1.2565],["x":0,"y":1,"z":-2.9855],["x":-1.4308,"y":1,"z":-2.9855],["x":-2.4055,"y":1,"z":-2.9855],["x":-8.1498,"y":1,"z":-2.9855],["x":-8.1498,"y":1,"z":-5.9959]]
//
        
       //3.7084000000000006
        //var x = [(55,20,15), (55,30,15), (55,30,15)]

//        var currentStartLocation = myCameraCoordinates()
//        currentStartLocation.x = 0
//        currentStartLocation.y = 0
//        currentStartLocation.z = 0
        var cc = getCameraCoordinates(sceneView: sceneView)
        
        print(coords, "Hi guys is this an optionAL?")
        for (index, _) in coords.enumerated() {
//            print(index, "WOW!!")
            if index != (coords.count) - 1 {
//                print("z")
            //make sure it doesn't crash on the final coordinate
//                print(coords)
//                print(coords[index])
//                print(coords[index + 1]["x"].float!)
                            var xdistance = (coords[index + 1]["x"].float! - coords[index]["x"].float!)
//                            var ydistance = (coords[index]["y"].float! - coords[index + 1]["y"].float!)
                var ydistance = Float(0.0)
                            var zdistance = (coords[index]["z"].float! - coords[index + 1]["z"].float!)
//                print(xdistance,ydistance, zdistance, "distances")
                
                print(xdistance,ydistance, zdistance, "distances")

                var cos1 = Float(0.0)
                var cos2 = Float(0.0)
                var cos3 = Float(0.0)
                
                var newdx = Float(0.0)
                var newdy = Float(0.0)
                var newdz = Float(0.0)
                var xdistanceRecorder = Float(0.0)
                var zdistanceRecorder = Float(0.0)



                if xdistance < 0 {
                    cos2 = Float(0.1)
                    cos3 = Float(0.1)
                    newdx = (xdistance/2)
                    cc.x += newdx
                    xdistanceRecorder = xdistance
                                        xdistance = (xdistance * -1)

                }
                else if ydistance < 0 {
                    cos1 = Float(0.1)
                    cos3 = Float(0.1)
                    newdy = (ydistance/2)
                    cc.y += newdy
                                        ydistance = (ydistance * -1)

                }
                else if zdistance < 0 {
//                    zdistance = (zdistance * -1)
                    cos1 = Float(0.1)
                    cos2 = Float(0.1)
                    newdz = (zdistance/2)
                    cc.z -= newdz
                    zdistanceRecorder = zdistance

                                        zdistance = (zdistance * -1)


                }
                
                else if xdistance > 0 {
                    cos2 = Float(0.1)
                    cos3 = Float(0.1)
                    newdx = (xdistance/2)
                    cc.x += newdx
                    xdistanceRecorder = xdistance

                }
                else if ydistance > 0 {
                    cos1 = Float(0.1)
                    cos3 = Float(0.1)
                    newdy = (ydistance/2)
                    cc.y += newdy

                }
                else if zdistance > 0 {
                    cos1 = Float(0.1)
                    cos2 = Float(0.1)
                    newdz = (zdistance/2)
                    cc.z -= newdz
                    zdistanceRecorder = zdistance

                }
                
                  print( cc.x , cc.y - 1  ,  cc.z, xdistance,ydistance, zdistance, "distances2")
                //neg distance is right
                //pos is forward
                //left is positive
            
                
//                cc.x = cc.x + (xdistance/2) //plus for right minus for left add a check to see
//                print(xdistance, ydistance, zdistance)
                //comment next to lines back in
//                cc.y =  cc.y - (ydistance/2)
//                cc.z =  cc.z - (zdistance/2) + 0.2
            
                
                
            var cubeNode = SCNNode(geometry: SCNBox(width: CGFloat((xdistance + cos1)), height: CGFloat((ydistance) + cos2), length: CGFloat((zdistance) + cos3) , chamferRadius:0))
            
                print("transform", cubeNode.worldTransform)
//                print("testing", xdistance + cos1)
                //makes it colored
                                        cubeNode.position = SCNVector3( cc.x , cc.y - 2
                                            ,  cc.z)
//cubeNode.rotation = SCNVector4(0,1,0, 90)
                
                
                //this effect next line, not the current one
                cc.x += xdistanceRecorder/2
//                cc.y -= ydistance/2
                cc.z -= zdistanceRecorder/2

            
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


