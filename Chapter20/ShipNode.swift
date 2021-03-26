//
//  ShipNode.swift
//  Chapter20
//
//  Created by daito yamashita on 2021/03/26.
//

import SceneKit
import ARKit

class ShipNode: SCNNode {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implimented")
    }
    
    override init() {
        super.init()
        
        // art.scnassets/ship.scnからshipノードを作る
        let sceneURL = Bundle.main.url(forResource: "ship", withExtension: "scn", subdirectory: "art.scnassets")!
        
        // ノードを作る
        let ship = SCNReferenceNode(url: sceneURL)!
        
        // データをNodeに読み込む
        ship.load()
        
        // 機首をz軸に正方向に向ける
        ship.eulerAngles.y = -.pi
        
        // 半分のサイズにする
        self.addChildNode(ship)
        self.scale = SCNVector3Make(0.2, 0.2, 0.2)
    }
}
