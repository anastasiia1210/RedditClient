import UIKit

class PostDetailsViewController: UIViewController {
    @IBOutlet private weak var postView: PostView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func config(_ post: Post) {
        postView.nameTimeDomain.text = "\(post.authorFullname) · 15h · \(post.domain)"
        postView.titleText.text = post.title
        postView.rating.setTitle("\(post.ups + post.downs)", for: .normal)
        postView.comments.setTitle("\(post.numComments)", for: .normal)
        var nameIcon = ""
        if post.saved == true{ nameIcon = ".fill" }
        let savedImage = UIImage(systemName: "bookmark\(nameIcon)")
        postView.saved.setImage(savedImage, for: .normal)
        if let imageUrl = URL(string: post.image) {
            postView.imageView.sd_setImage(with: imageUrl)
        }
    }
}
