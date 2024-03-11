import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postView: PostView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.postView.prepareView()
    }
    
    func configure(_ post: Post, _ d: UIViewController){
        postView.configure(post, d)
    }
    
}
