import SwiftUI

struct CommentDetails: View {
    let comment: Comment
    
    var body: some View {
        VStack{
            Text("/u/\(comment.authorFullname) · \(FetchData.fetchData.calculateTime(comment.created))") .frame(maxWidth: .infinity, alignment: .leading)
          
            Text(comment.body).frame(maxWidth: .infinity, alignment: .leading).padding()
           
            Text("Rating: \(comment.ups+comment.downs)").frame(maxWidth: .infinity, alignment: .leading)
           
            ShareLink(item: URL(string: comment.permalink)!) {
                   Text("Share")
                        .foregroundStyle(.black)
                        .frame(width: 100, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
        }
        .frame(maxWidth: .infinity)
        .padding(5)
         Spacer()
    }
}

#Preview {
    CommentDetails(comment: Comment())
}

