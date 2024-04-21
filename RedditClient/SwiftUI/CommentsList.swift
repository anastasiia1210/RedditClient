import SwiftUI

struct CommentsList: View {
    let postId: String
    let openCommentDetails: (_ comment: Comment) -> Void
    @StateObject private var data: CommentsData
    
    init(postId: String, openCommentDetails: @escaping (_ comment: Comment) -> Void) {
            self.postId = postId
            self.openCommentDetails = openCommentDetails
            _data = StateObject(wrappedValue: CommentsData(postId))
        }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(data.comments) { comment in
                        Button {action: do {openCommentDetails(comment)}} label: {CommentCell(comment: comment)}
                        .foregroundColor(Color.primary)
                    }
                }
            }
        }
    }
    }

//#Preview {
//   CommentsList(postId: "1bn71me")
//}

