//
//  GameViewController.swift
//  Block Fun
//
//  Created by Shawn Haynes on 2/3/17.
//  Copyright © 2017 Shawn Haynes. All rights reserved.
//

//import UIKit
//import QuartzCore
//import SceneKit
//
//class GameViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//        
//        // create and add a camera to the scene
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        scene.rootNode.addChildNode(cameraNode)
//        
//        // place the camera
//        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
//        
//        // create and add a light to the scene
//        let lightNode = SCNNode()
//        lightNode.light = SCNLight()
//        lightNode.light!.type = .omni
//        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
//        scene.rootNode.addChildNode(lightNode)
//        
//        // create and add an ambient light to the scene
//        let ambientLightNode = SCNNode()
//        ambientLightNode.light = SCNLight()
//        ambientLightNode.light!.type = .ambient
//        ambientLightNode.light!.color = UIColor.darkGray
//        scene.rootNode.addChildNode(ambientLightNode)
//        
//        // retrieve the ship node
//        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
//        
//        // animate the 3d object
//        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
//        
//        // retrieve the SCNView
//        let scnView = self.view as! SCNView
//        
//        // set the scene to the view
//        scnView.scene = scene
//        
//        // allows the user to manipulate the camera
//        scnView.allowsCameraControl = true
//        
//        // show statistics such as fps and timing information
//        scnView.showsStatistics = true
//        
//        // configure the view
//        scnView.backgroundColor = UIColor.black
//        
//        // add a tap gesture recognizer
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleTap(_:)))
//        var gestureRecognizers = [UIGestureRecognizer]()
//        gestureRecognizers.append(tapGesture)
//        if let existingGestureRecognizers = scnView.gestureRecognizers {
//            gestureRecognizers.append(contentsOf: existingGestureRecognizers)
//        }
//        scnView.gestureRecognizers = gestureRecognizers
//    }
//    
//    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
//        // retrieve the SCNView
//        let scnView = self.view as! SCNView
//        
//        // check what nodes are tapped
//        let p = gestureRecognize.location(in: scnView)
//        let hitResults = scnView.hitTest(p, options: [:])
//        // check that we clicked on at least one object
//        if hitResults.count > 0 {
//            // retrieved the first clicked object
//            let result: AnyObject = hitResults[0]
//            
//            // get its material
//            let material = result.node!.geometry!.firstMaterial!
//            
//            // highlight it
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 0.5
//            
//            // on completion - unhighlight
//            SCNTransaction.completionBlock = {
//                SCNTransaction.begin()
//                SCNTransaction.animationDuration = 0.5
//                
//                material.emission.contents = UIColor.black
//                
//                SCNTransaction.commit()
//            }
//            
//            material.emission.contents = UIColor.red
//            
//            SCNTransaction.commit()
//        }
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Release any cached data, images, etc that aren't in use.
//    }
import UIKit
import SceneKit

class GameViewController: UIViewController {
    var counter = 0
    
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCamera()
        spawnShape()
        let myFloor = SCNFloor()
        myFloor.reflectivity = 10
        
        let myFloorNode = SCNNode(geometry: myFloor)
       myFloorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        myFloorNode.physicsBody?.isAffectedByGravity = false
        myFloorNode.position = SCNVector3(x: 0, y: -10, z: 0)
        scnScene.rootNode.addChildNode(myFloorNode)
    }
    func setupView() {
        scnView = self.view as! SCNView
        // 1
        scnView.showsStatistics = true
        // 2
        scnView.allowsCameraControl = true
        // 3
        scnView.autoenablesDefaultLighting = true
        scnView.delegate = self
    }
    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
    }
    func setupCamera() {
        // 1
        cameraNode = SCNNode()
        // 2
        cameraNode.camera = SCNCamera()
        // 3
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        // 4
        scnScene.rootNode.addChildNode(cameraNode)
    }
    func spawnShape() {
        // 1
        counter += 1
        var geometry:SCNGeometry
        // 2
        switch ShapeType.random() {
        case .Box:
            geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        case .Sphere:
            geometry = SCNSphere(radius: 0.5)
        case .Pyramid:
            geometry = SCNPyramid(width: 1.0, height: 1.0, length: 1.0)
        case .Torus:
            geometry = SCNTorus(ringRadius: 0.5, pipeRadius: 0.25)
        case .Capsule:
            geometry = SCNCapsule(capRadius: 0.3, height: 2.5)
        case .Cylinder:
            geometry = SCNCylinder(radius: 0.3, height: 2.5)
        case .Cone:
            geometry = SCNCone(topRadius: 0.25, bottomRadius: 0.5, height: 1.0)
        case .Tube:
            geometry = SCNTube(innerRadius: 0.25, outerRadius: 0.5, height: 1.0)
        }
        geometry.materials.first?.diffuse.contents = UIColor.random()
        // 4
        let geometryNode = SCNNode(geometry: geometry)
        // 5
        geometryNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        // 1
        let randomX = Float.random(min: -2, max: 2)
        let randomY = Float.random(min: 10, max: 18)
        // 2
        let force = SCNVector3(x: randomX, y: randomY , z: 0)
        // 3
        let position = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
        // 4
        geometryNode.physicsBody?.applyForce(force, at: position, asImpulse: true)
        scnScene.rootNode.addChildNode(geometryNode)
        //let delayActionSeq = SCNAction.fadeOut(duration: 1)
       // let removeNode = SCNAction.removeFromParentNode()
        //geometryNode.runAction(delayActionSeq)
      //  geometryNode.runAction(removeNode)
    }
}
// 1
extension GameViewController: SCNSceneRendererDelegate {
    // 2
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // 3
        if counter < 100{
        spawnShape()
        }
        }
}
