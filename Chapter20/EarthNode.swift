//
//  EarthNode.swift
//  Chapter20
//
//  Created by daito yamashita on 2021/03/26.
//

import SceneKit
import ARKit

class EarthNode: SCNNode {
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        
        // ジオメトリ
        let earth = SCNSphere(radius: 0.05)
        
        // テクスチャ
        earth.firstMaterial?.diffuse.contents = UIImage(named: "earth_1024")
        
        // ノードのgeometryプロパティに設定
        geometry = earth
        
        // 物理ボディを設定
        let bodyShape = SCNPhysicsShape(geometry: geometry!, options: [:])
        physicsBody = SCNPhysicsBody(type: .dynamic, shape: bodyShape)
        // 摩擦
        physicsBody?.friction = 1.0
        // 回転時の摩擦
        physicsBody?.rollingFriction = 1.0
        // 反発力
        physicsBody?.restitution = 0.5
        
        // 衝突する相手を決める
        physicsBody?.categoryBitMask = Category.earthCategory
        physicsBody?.collisionBitMask = Category.all
    }
}
