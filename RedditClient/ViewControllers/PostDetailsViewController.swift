import UIKit

class PostDetailsViewController: UIViewController{
    
    var post: Post?
    var destinationViewController: UIViewController?
    @IBOutlet weak var postView: PostView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let post = post, let destinationViewController = destinationViewController {
            config(post, destinationViewController)
        }
        postView.delegate = destinationViewController as? any PostDelegate
        guard let post = post else {return}
        guard let d = destinationViewController else {return}
        config(post, d)
    }
   
    func config( _ post: Post, _ destinationViewController: UIViewController) {
        self.post = post
        self.destinationViewController = destinationViewController
        postView.comments.isUserInteractionEnabled = false
        
        postView.configure(post, destinationViewController)
    }
}
