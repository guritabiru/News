//
//  Article.swift
//  News
//
//  Created by Bimo Sekti Wicaksono on 31/08/23.
//

import Foundation

struct Article: Decodable, Hashable {
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var source: Source?
}
