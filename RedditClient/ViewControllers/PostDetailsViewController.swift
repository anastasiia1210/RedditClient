import UIKit

class PostDetailsViewController: UIViewController {
    @IBOutlet private weak var postView: PostView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func config( _ post: Post) {
        postView.configure(post)
    }
}
