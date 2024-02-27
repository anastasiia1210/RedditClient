import UIKit
import SDWebImage

class PostView: UIView {
    
    let kCONTENT_XIB_NAME = "PostView"
    var url: URL?
    var post: Post?
    weak var delegate: PostDelegate? 
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var nameTimeDomain: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rating: UIButton!
    @IBOutlet weak var comments: UIButton!
    @IBOutlet weak var saved: UIButton!
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        self.configureView()
    }
    
    @IBAction func shareAction(_ sender: Any) {
        print(url ?? "emthy")
        let activityViewController = UIActivityViewController(activityItems: [url ?? "No url"], applicationActivities: nil)
        takeController().present(activityViewController, animated:true, completion:nil)
        print("yes")
    }
    
    func takeController() -> UIViewController {
      var rootViewController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
      while (rootViewController.presentedViewController != nil) {
        rootViewController = rootViewController.presentedViewController!
      }
      return rootViewController
    }
    
    func setupView() {
            self.configureView()
        }

    private func configureView(){
        let s = self.loadViewFromXib()
        s.frame = self.bounds
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(s)
    }
    
    private func loadViewFromXib() -> UIView{
        guard let view = Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self)?.first as? UIView else {return UIView()}
        return view
    }
    
    @IBAction func savedAction(_ sender: Any) {
        guard let post else {return}
        if post.saved {
            PostData.shared.removePostFromSaved(post)
        } else{
            PostData.shared.addPostToSaved(post)
        }
        var nameIcon = ""
        if self.post?.saved == true{ nameIcon = ".fill" }
        let savedImage = UIImage(systemName: "bookmark\(nameIcon)")
        saved.setImage(savedImage, for: .normal)
        self.delegate?.changeSaved()
        print(PostData.shared.savedData.count)
    }
    
    func configure(_ post: Post, _ d: UIViewController){
        self.delegate = d as? any PostDelegate
        self.post = post
        self.url = URL(string: post.permalink)
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
        }
    }
}


