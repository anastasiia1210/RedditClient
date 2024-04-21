import UIKit
import SwiftUI

class PostDetailsViewController: UIViewController{
    
    var post: Post?
    var destinationViewController: UIViewController?
    @IBOutlet weak var postView: PostView!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let post = post, let destinationViewController = destinationViewController {
            config(post, destinationViewController)
        }
        postView.delegate = destinationViewController as? any PostDelegate
        guard let post = post else {return}
        guard let d = destinationViewController else {return}
        config(post, d)
    
       //add SwiftUI
        let commentsListController: UIViewController = UIHostingController(rootView: CommentsList(postId: post.id, openCommentDetails: openCommentDetails(_:)))
        
        let commentsListView: UIView = commentsListController.view
        self.containerView.addSubview(commentsListView)
        commentsListView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            commentsListView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            commentsListView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            commentsListView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            commentsListView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor)
        ])
        
        commentsListController.didMove(toParent: self)
        
    }
    
    func openCommentDetails(_ comment: Comment) {
        let controllerDetails = UIHostingController(rootView: CommentDetails(comment: comment))
        self.navigationController?.pushViewController(controllerDetails, animated: true)
       }
    
    func config(_ post: Post, _ destinationViewController: UIViewController) {
        self.post = post
        self.destinationViewController = destinationViewController
        postView.comments.isUserInteractionEnabled = false
        postView.configure(post, destinationViewController)
    }
}
