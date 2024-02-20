import UIKit

class PostView: UIView {
    
    let kCONTENT_XIB_NAME = "PostView"
    
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
    
}


