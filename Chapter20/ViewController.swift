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
    
    @IBAction func tapSceneView( _ sender: UITapGestureRecognizer) {
        
        // タップした2D座標
        let tapLoc = sender.location(in: sceneView)
        
        // 2D座標のヒットテスト
        let hitTestOptions = [SCNHitTestOption: Any]()
        
        // 検知平面とタップ座標のヒットテスト
        let results = sceneView.hitTest(tapLoc, options: hitTestOptions)
        if let result = results.first {
            // BoxNodeをタップしたなら飛ばす
            guard let node = result.node as? BoxNode else {
                return
            }
            // タップしたBoxNodeを飛ばす
            
            let frame = sceneView.session.currentFrame!
            let tf = frame.camera.transform
            
            // カメラの位置
            let cameraPos = SCNVector3(tf.columns.3.x, tf.columns.3.y, tf.columns.3.z)
            
            // カメラとノードの距離 len
            let x = node.position.x - cameraPos.x
            let y = node.position.y - cameraPos.y
            let z = node.position.z - cameraPos.z
            // ベクトルの長さ
            let len = sqrtf(x*x + y*y + z*z)
            // カメラからノード方向への単位ベクトル
            let unitVec = SCNVector3(x/len, y/len, z/len)
            
            // 飛ばす力
            let force: Float = 2.0
            // 力のベクトル
            let forceVec = SCNVector3(force*unitVec.x, force*unitVec.y, force*unitVec.z)
            // ノードを弾くように力を加える
            node.physicsBody?.applyForce(forceVec, asImpulse: true)
            
            // BoxNodeが重力の影響を受けるようにする
            node.physicsBody?.isAffectedByGravity = true
            
        } else {
            // 何もない時はタップした位置にBoxNodeを追加する
            
            // カメラの正面の位置にノードを追加する
            if let frame = sceneView.session.currentFrame {
                // トランスフォームを作る
                var transform = matrix_identity_float4x4
                transform.columns.3.z = -0.2
                
                // カメラ正面の位置を作る
                let tf = simd_mul(frame.camera.transform, transform)
                let pos = SCNVector3(tf.columns.3.x, tf.columns.3.y, tf.columns.3.z)
                
                // ノードを作る（物理ボディ）
                let boxNode = BoxNode()
                boxNode.position = pos
                sceneView.scene.rootNode.addChildNode(boxNode)
            }
        }
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
        
        // AR世界の重力を設定
        sceneView.scene.physicsWorld.gravity = SCNVector3(0, -1.0, 0)
        
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
