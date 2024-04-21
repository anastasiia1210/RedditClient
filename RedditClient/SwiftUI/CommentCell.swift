import SwiftUI

struct CommentCell: View {
    let comment: Comment
    
    var body: some View {
        VStack(alignment: .leading){
            Text("/u/\(comment.authorFullname) · \(FetchData.fetchData.calculateTime(comment.created))")
            Spacer()
            Text(comment.body) .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
            Spacer()
            Text("Rating: \(comment.ups+comment.downs)")
        }
        .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
        .padding(5)
        .background(Color(.systemBackground))
    }
    
}

#Preview {
    CommentCell(comment: Comment())
}

