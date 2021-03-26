//
//  PlaneNode.swift
//  Chapter20
//
//  Created by daito yamashita on 2021/03/25.
//

import SceneKit
import ARKit

class PlaneNode: SCNNode {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        // 平面のジオメトリを作る
        let planeHeight: Float = 0.01
        let plane = SCNBox(
            width: CGFloat(anchor.extent.x),
            height: CGFloat(planeHeight),
            length: CGFloat(anchor.extent.z),
            chamferRadius: 0.0
        )
        
        // 平面の塗り
        plane.firstMaterial?.diffuse.contents = UIColor.green.withAlphaComponent(0.5)
        
        // ワイヤーフレーム表示の分割数
        plane.widthSegmentCount = 10
        plane.heightSegmentCount = 1
        plane.lengthSegmentCount = 10
        
        // ノードのgeometoryプロパティに設定する
        geometry = plane
        
        // 位置決めする
        // planeの厚みを考慮して -planeHeight する
        position = SCNVector3(anchor.center.x, -planeHeight, anchor.center.z)
        
        // 平面ノードの物理ボディを作る
        let bodyShape = SCNPhysicsShape(geometry: geometry!, options: [:])
        // .staticで落下しない
        physicsBody = SCNPhysicsBody(type: .static, shape: bodyShape)
        // 摩擦
        physicsBody?.friction = 3.0
        // 反発
        physicsBody?.restitution = 0.2
        
        // 衝突する相手を決める
        // 自身のカテゴリ
        physicsBody?.categoryBitMask = Category.planeCategory
        //衝突相手（平面以外）
        physicsBody?.collisionBitMask = Category.all ^ Category.planeCategory
    }
    
    // 位置とサイズを更新する
    func update(anchor: ARPlaneAnchor) {
        // ダウンキャストする
        let plane = geometry as! SCNBox
        
        // アンカからの平面サイズを更新
        plane.width = CGFloat(anchor.extent.x)
        plane.length = CGFloat(anchor.extent.z)
        
        // 物理ボディの形を更新する
        let bodyShape = SCNPhysicsShape(geometry: geometry!, options: [:])
        physicsBody?.physicsShape = bodyShape
        
        // 座標を更新する
        position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
    }
}
