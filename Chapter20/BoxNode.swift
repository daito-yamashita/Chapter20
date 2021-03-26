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
        
        // 物理ボディを設定する
        let bodyShape = SCNPhysicsShape(geometry: geometry!, options: [:])
        physicsBody = SCNPhysicsBody(type: .dynamic, shape: bodyShape)
        physicsBody?.friction = 1.0
        physicsBody?.restitution = 0.2
        
        // 衝突する相手を決める
        physicsBody?.categoryBitMask = Category.boxCategory
        physicsBody?.collisionBitMask = Category.all
    }
    
}
