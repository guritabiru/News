//
//  ArticleDetailViewModel.swift
//  News
//
//  Created by Bimo Sekti Wicaksono on 12/09/23.
//

import Foundation
import RxSwift
import CoreData

class ArticleDetailViewModel {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public var successBookmarkArticle: PublishSubject<Bool> = PublishSubject()
    public var isBookmarked: PublishSubject<Bool> = PublishSubject()
    
    func saveArticle(article: Article) {
        let savedArticle = Article2(context: context)
        savedArticle.urlToImage = article.urlToImage
        savedArticle.url = article.url
        savedArticle.title = article.title
        savedArticle.desc = article.description
        savedArticle.publishedAt = article.publishedAt
        savedArticle.sourceName = article.source?.name
        
        do {
            try context.save()
            self.getBookmark(title: article.title!)
        } catch {
            
        }
    }
    
    func deleteArticle(title: String) {
        let fetchRequest: NSFetchRequest<Article2> = Article2.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(request)
            self.getBookmark(title: title)
        } catch {
            // error
        }
    }
    
    func getBookmark(title: String) {
        let request: NSFetchRequest<Article2> = Article2.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        var fetchedArticle: [Article2] = []
        do {
            fetchedArticle = try context.fetch(request)
            try context.save()
            isBookmarked.onNext(fetchedArticle.count > 0)
        } catch let error {
            print("Error fetching article \(error)")
        }
    }
}
