//
//  AnalyzeRequestType.swift
//  EmotionAnalyzer
//
//  Created by 新谷　よしみ on 2017/02/10.
//  Copyright © 2017年 新谷　よしみ. All rights reserved.
//

import APIKit

protocol AnalyzeRequest: Request {
    
}

extension AnalyzeRequest {
    var baseURL: URL {
        return URL(string: "http://ap.mextractr.net/ma9")!
    }
}
