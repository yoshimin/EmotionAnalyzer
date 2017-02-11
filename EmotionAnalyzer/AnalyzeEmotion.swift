//
//  AnalyzeEmotion.swift
//  EmotionAnalyzer
//
//  Created by 新谷　よしみ on 2017/02/11.
//  Copyright © 2017年 新谷　よしみ. All rights reserved.
//

import APIKit
import Himotoki

struct AnalyzeEmotion : AnalyzeRequest {
    typealias Response = AnalyzeResults
    
    public var text: String!
    
    init(_ text: String) {
        self.text = text
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/emotion_analyzer"
    }
    
    var parameters: Any? {
        return [
            "out": "json",
            "apikey": "KEY",
            "text": text,
        ]
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try decodeValue(object)
    }
}
