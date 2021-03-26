//
//  TextNode.swift
//  Chapter20
//
//  Created by daito yamashita on 2021/03/26.
//

import SceneKit
import ARKit

class TextNode: SCNNode {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(str: String) {
        super.init()
        
        // 文字のジオメトリを作る
        let text = SCNText(string: str, extrusionDepth: 0.01)
        text.font = UIFont(name: "Furuta-Bold", size: 1)
        text.firstMaterial?.diffuse.contents = UIColor.red
        
        // テキストノードを作る
        let textNode = SCNNode(geometry: text)
        self.addChildNode(textNode)
        // ノードを囲む領域
        let (max, min) = textNode.boundingBox
        let w = abs(CGFloat(max.x - min.x))
        let h = abs(CGFloat(max.y - min.y))
        // 位置決め
        textNode.position = SCNVector3(-w/2, -h*1.2, 0)
        // 全体を縮小する
        self.scale = SCNVector3(0.01, 0.01, 0.01)
    }
}
