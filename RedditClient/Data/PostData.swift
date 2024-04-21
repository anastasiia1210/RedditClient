import Foundation
import UIKit

class PostData{
    static let shared = PostData()
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("saved.json")
    var data: [Post] = []
    var presentData: [Post] = []
    var savedData: [Post] = []
    var after: String = ""
    var fetchMoreData = false
    var onlySavedPosts = false
    
    func addPostToSaved(_ post: Post){
        if post.saved == true {return}
        post.saved = true
        self.savedData.append(post)
    }
    
    func removePostFromSaved(_ post: Post){
        post.saved = false
        self.savedData.removeAll{$0.permalink == post.permalink}
        if onlySavedPosts {
            self.presentData = self.savedData
        }
    }
    func loadPosts(reloadData: @escaping () -> Void){
        print(path.path)
        readPostsFromFile()
        FetchData.fetchData.fetchPosts(subreddit: "ios", parametrs: [("limit", "10")]){
            [weak self] values, valueAfter in
            DispatchQueue.main.async {
                guard let self else {return}
                self.data = self.checkIfPostsIsSaved(values)
                self.after = valueAfter
                self.presentData = self.data
                reloadData()
            }
        }
    }
    
    func loadForScrollPosts(reloadData: @escaping () -> Void){
        FetchData.fetchData.fetchPosts(subreddit: "ios", parametrs: [("limit", "10"),("after", "\(after)")]){
           [weak self] values, valueAfter in
            DispatchQueue.main.async {
                guard let self else {return}
                self.data += self.checkIfPostsIsSaved(values)
                self.after = valueAfter
                self.fetchMoreData = false
                self.presentData = self.data
                reloadData()
            }
        }
    }
    
    func checkIfPostsIsSaved(_ posts: [Post]) -> [Post]{
        for post in posts{
            if self.savedData.contains(where: {$0.permalink == post.permalink}){
                post.saved = true
            }
        }
        return posts
    }
    
    func savePostsInFile(){
        do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        var jsonString = try! String(data: encoder.encode(self.savedData), encoding: .utf8)
        if savedData.isEmpty {jsonString = ""}
        try jsonString?.write(to: path, atomically: true, encoding: .utf8)
        print(path.path)
        } catch {
        print(error.localizedDescription)
        }
    }
    
    func readPostsFromFile(){
        do {
            let data = try Data(contentsOf: self.path)
            self.savedData = try JSONDecoder().decode([Post].self, from: data)
               } catch {
                   print(error)
               }
    }
}
