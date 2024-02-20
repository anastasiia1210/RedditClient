
import UIKit
import SDWebImage

class PostViewController: UIViewController {

    @IBOutlet private weak var nameTimeDomain: UILabel!
    @IBOutlet private weak var titleText: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var rating: UIButton!
    @IBOutlet private weak var comments: UIButton!
    @IBOutlet private weak var saved: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        Task {
            do{
                let post = try await FetchData().fetchOnePost(subreddit: "ios", parametrs: [("limit", "1")])
                DispatchQueue.main.async {
                    do{
                        try self.setupView(post)
                    }catch{
                       print("Error \(error)")
                    }
                }
            } catch {
                print("Error \(error)")
            }
        }
    }
    
     func setupView(_ post: Post) throws{
         nameTimeDomain.text = "\(post.authorFullname) · 15h · \(post.domain)"
         titleText.text = post.title
         rating.setTitle("\(post.ups + post.downs)", for: .normal)
         comments.setTitle("\(post.numComments)", for: .normal)
         var nameIcon = ""
         if post.saved == true{ nameIcon = ".fill" }
         let savedImage = UIImage(systemName: "bookmark\(nameIcon)")
         saved.setImage(savedImage, for: .normal)
         if let imageUrl = URL(string: post.image) {
                     imageView.sd_setImage(with: imageUrl)
         } else { throw FetchDataError(message: "Invalid image URL") }
    }

}
