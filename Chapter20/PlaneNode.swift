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
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        plane.firstMaterial?.diffuse.contents = UIColor.green.withAlphaComponent(0.5)
        plane.widthSegmentCount = 10
        plane.heightSegmentCount = 10
        
        // ノードのgeometoryプロパティに設定する
        geometry = plane
        
        // X軸回りで90度回転
        transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        // 位置決めする
        position = SCNVector3(anchor.center.x, 0, anchor.center.z)
    }
    
    // 位置とサイズを更新する
    func update(anchor: ARPlaneAnchor) {
        // ダウンキャストする
        let plane = geometry as! SCNPlane
        
        // アンカからの平面の幅、高さを更新する
        plane.width = CGFloat(anchor.extent.x)
        plane.height = CGFloat(anchor.extent.z)
        
        // 座標を更新する
        position = SCNVector3(anchor.center.x, 0, anchor.center.z)
    }
}
