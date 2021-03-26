//
//  ViewController.swift
//  Chapter20
//
//  Created by daito yamashita on 2021/03/25.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var nodes: Array<SCNNode>!
    
    @IBAction func tapSceneView( _ sender: UITapGestureRecognizer) {
        
        // タップした2D座標
        let tapLoc = sender.location(in: sceneView)
        
        // 検知平面とタップ座標のヒットテスト
        let results = sceneView.hitTest(tapLoc, types: .existingPlaneUsingExtent)
        
        // 検知平面をタップしていたら最前面のヒットデータをresuluに入れる
        // 配列の最初の値が最前面にある平面になる
        guard let result = results.first else {
            return
        }
        
        // 検出した平面のアンカを取得する
        if let anchor = result.anchor as? ARPlaneAnchor {
            // 水平面でない場合は処理を中断する
            if anchor.alignment == .vertical {
                return
            }
        }
        
        // 箱ノードを作る
        let boxNode = BoxNode()
        // 地球ノードを作る
        let earthNode = EarthNode()
        nodes = [boxNode, earthNode]
        
        // 追加するノードをランダムに選ぶ
        let index = Int(arc4random()) % (nodes.count)
        let node = nodes[index]
        
        // タップされた座標から位置決めする
        let pos = result.worldTransform.columns.3
        let y = pos.y + 0.2
        node.position = SCNVector3(pos.x, y, pos.z)

        // シーンに箱ノードを追加する
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // シーンを作る
        sceneView.scene = SCNScene()
        
        // デバッグ表示（ワイヤーフレーム）
        sceneView.debugOptions = .showWireframe
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // 平面の検出を有効にする
        configuration.planeDetection = [.horizontal, .vertical]

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    // ノードが追加された
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 平面アンカではないときは中断する
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        // アンカが示す位置に平面ノードを追加する
        node.addChildNode(PlaneNode(anchor: planeAnchor))
    }
    
    // ノードが更新された
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        // 平面アンカでないときは中断する
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        // PlaneNodeでない時は中断する
        guard let planeNode = node.childNodes.first as? PlaneNode else {
            return
        }
        
        // ノードの位置とサイズを更新する
        planeNode.update(anchor: planeAnchor)
        
    }
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
