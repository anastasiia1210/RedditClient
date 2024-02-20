import Foundation

struct FetchData{
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
}
