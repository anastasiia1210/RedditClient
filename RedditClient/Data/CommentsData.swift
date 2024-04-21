import Foundation

class CommentsData: ObservableObject{
    
    @Published var comments: [Comment] = []
    let postId: String
    let subreddit: String = "ios"
    
    init(_ postId: String) {
        self.postId = postId
           fetchComments()
       }
    
    private func fetchComments() {
        FetchData.fetchData.fetchComments(subreddit: subreddit, postId: postId) { fetchedComments in
            DispatchQueue.main.async {
                self.comments = fetchedComments
            }
            }
        }
    
}


