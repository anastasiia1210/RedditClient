import Foundation

struct FetchData{
    
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
}
