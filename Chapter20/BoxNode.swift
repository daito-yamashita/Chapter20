//
//  BoxNode.swift
//  Chapter20
//
//  Created by daito yamashita on 2021/03/26.
//

import SceneKit
import ARKit

class BoxNode: SCNNode {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        // ジオメトリを作る
        let box = SCNBox(width: 0.1, height: 0.05, length: 0.1, chamferRadius: 0.01)
        
        // 塗り
        box.firstMaterial?.diffuse.contents = UIColor.gray
        
        // ノードのgeometryプロパティに設定する
        geometry = box
        
        // 物理ノードを設定する
        let bodyShape = SCNPhysicsShape(geometry: geometry!, options: [:])
        physicsBody = SCNPhysicsBody(type: .dynamic, shape: bodyShape)
        // 重力の影響を受けない
        physicsBody?.isAffectedByGravity = false
        physicsBody?.friction = 2.0
        physicsBody?.restitution = 0.2
    }
}
