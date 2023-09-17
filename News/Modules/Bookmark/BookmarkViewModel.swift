//
//  BookmarkViewModel.swift
//  News
//
//  Created by Bimo Sekti Wicaksono on 12/09/23.
//

import Foundation
import RxSwift

class BookmarkViewModel {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public var successGetBookmarkedArticles: PublishSubject<[Article]> = PublishSubject()
    
    func getBookmarkedArticles() {
        do {
            let items = try context.fetch(Article2.fetchRequest())
            var articles: [Article] = []
            items.forEach({ item in
                articles.append(Article(title: item.title, description: item.desc, url: item.url, urlToImage: item.urlToImage, publishedAt: item.publishedAt, source: Source(name: item.sourceName)))
                
            })
            successGetBookmarkedArticles.onNext(articles)
        } catch {
            //error
        }
    }
    
}
