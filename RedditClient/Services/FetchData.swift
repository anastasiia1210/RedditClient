import Foundation

class FetchData{
    static let fetchData = FetchData()
    
    func fetchOnePost(subreddit: String, parametrs: [(String, String)]? = nil) async throws -> Post{
        
        var urlString = "https://www.reddit.com/r/\(subreddit)/top.json?"
        
        if let parametrs = parametrs {
            parametrs.forEach {
                urlString += "\($0.0)=\($0.1)&"
            }
            urlString.removeLast()
        }
        
        guard let url = URL(string: urlString) else {
            throw FetchDataError(message: "Invalid URL")
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoded = try decoder.decode(DecodedPost.self, from: data)
            let post = try Post(from: decoded)
            return post
        } catch {
            throw error
        }
    }
    
    func fetchPosts(subreddit: String, parametrs: [(String, String)]? = nil, completion: @escaping ([Post], String) -> Void) {
        
        var urlString = "https://www.reddit.com/r/\(subreddit)/top.json?"
        
        if let parametrs = parametrs {
            parametrs.forEach {
                urlString += "\($0.0)=\($0.1)&"
            }
            urlString.removeLast()
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            do {
                guard let data = data else {return}
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decoded = try decoder.decode(DecodedPost.self, from: data)
                let posts = try decoded.data.children.map { try Post(from: $0) }
                completion(posts, decoded.data.after ?? "")
            } catch {
                print("Error fetch posts")
                return
            }
        }
        
        task.resume()
    }
    
    func fetchComments(subreddit: String, postId: String, completion: @escaping ([Comment]) -> Void) {
        guard let url = URL(string: "https://www.reddit.com/r/\(subreddit)/comments/\(postId)/.json") else { return }
      
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            do {
                guard let data = data else { return }
                let decodedComments: [Comment]
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decoded = try decoder.decode([DecodedComment].self, from: data)
                decodedComments = try decoded[1].data.children.map { try Comment(from: $0) }
                
                completion(decodedComments)
            } catch {
                print("Error fetching comments: \(error)")
                completion([])
            }
        }
        
        task.resume()
    }
    
    func calculateTime(_ created: Int) -> String{
       let timeDiff = Int(NSDate().timeIntervalSince1970) - created
        if timeDiff < 60 {return "now"}
        if timeDiff < 3600 {return "\(Int(timeDiff/60))m"}
        if timeDiff < 86400 {return "\(Int(timeDiff/3600))h"}
        if timeDiff < 2678400 {return "\(Int(timeDiff/86400))d"}
        if timeDiff < 31536000 {return "\(Int(timeDiff/2678400))mon"}
        return "\(Int(timeDiff/31536000))y"
    }
}
