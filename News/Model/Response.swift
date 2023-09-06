//
//  Response.swift
//  News
//
//  Created by Bimo Sekti Wicaksono on 31/08/23.
//

import Foundation

struct Response: Decodable, Hashable {
    var status: String
    var code: String?
    var message: String?
    var totalResults: Int?
    var articles: [Article]?
}
