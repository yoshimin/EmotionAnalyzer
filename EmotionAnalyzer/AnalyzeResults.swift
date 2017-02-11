//
//  AnalyzeResults.swift
//  EmotionAnalyzer
//
//  Created by 新谷　よしみ on 2017/02/10.
//  Copyright © 2017年 新谷　よしみ. All rights reserved.
//

import Himotoki

struct AnalyzeResults {
    var likedislike: Float
    var joysad: Float
    var angerfear: Float
}

extension AnalyzeResults: Decodable {
    static func decode(_ e: Extractor) throws -> AnalyzeResults {
        return try AnalyzeResults (
            likedislike: e <| "likedislike",
            joysad: e <| "joysad",
            angerfear: e <| "angerfear"
        )
    }
}
