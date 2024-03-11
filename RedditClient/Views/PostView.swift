import UIKit
import SDWebImage

class PostView: UIView {
    
    let kCONTENT_XIB_NAME = "PostView"
    var url: URL?
    var post: Post?
    weak var delegate: PostDelegate?
    
    @IBOutlet weak var bookmarkHidenView: UIView!
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
        addGestureRecognizerForDoubleTap()
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [url ?? "No url"], applicationActivities: nil)
        takeController().present(activityViewController, animated:true, completion:nil)
    }
    
    func prepareView(){
        self.imageView.image = nil
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
    }
    
    @IBAction func commentsAction(_ sender: Any) {
        guard let post else {return}
        delegate?.commentsClicked(post)
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
        
        DispatchQueue.main.async {
            self.drawBookmark()
        }
    }
    
    func addGestureRecognizerForDoubleTap(){
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewDoubleTapped))
        doubleTapGesture.numberOfTapsRequired = 2
        self.imageView.addGestureRecognizer(doubleTapGesture)
        self.imageView.isUserInteractionEnabled = true
    }
    
    @objc
    func imageViewDoubleTapped(){
        guard let post else {return}
        if self.post?.saved == false {
            PostData.shared.addPostToSaved(post)
            let savedImage = UIImage(systemName: "bookmark.fill")
            self.saved.setImage(savedImage, for: .normal)}
        UIView.transition(
            with: self,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: { self.bookmarkHidenView.isHidden = false },
            completion: { _ in
                UIView.transition(
                    with: self,
                    duration: 0.5,
                    options: .transitionCrossDissolve,
                    animations: { self.bookmarkHidenView.isHidden = true },
                    completion: { _ in self.delegate?.refreshTable()}
                )
            }
        )
    }
    
    
    func drawBookmark(){
        self.bookmarkHidenView.isHidden = true
        self.bookmarkHidenView.backgroundColor = .clear
        
        bookmarkHidenView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let path = UIBezierPath()
        let halfWidth: CGFloat = 100/2
        let halfHeight: CGFloat = 125/2
        let centerX = self.bookmarkHidenView.center.x
        let centerY = self.bookmarkHidenView.center.y - 125/2
        path.move(to: CGPoint(x: centerX - halfWidth,
                              y: centerY - halfHeight))
        path.addLine(to: CGPoint(x: centerX + halfWidth,
                                 y: centerY - halfHeight))
        path.addLine(to: CGPoint(x: centerX + halfWidth,
                                 y: centerY + halfHeight))
        path.addLine(to: CGPoint(x: centerX,
                                 y: centerY + 25))
        path.addLine(to: CGPoint(x: centerX - halfWidth,
                                 y: centerY + halfHeight))
        
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.black.withAlphaComponent(0.3).cgColor
        shapeLayer.lineWidth = 5
        self.bookmarkHidenView.layer.addSublayer(shapeLayer)
    }
    
}


