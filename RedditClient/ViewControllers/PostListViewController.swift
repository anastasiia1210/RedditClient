import UIKit

class PostListViewController: UIViewController, PostDelegate, UISearchBarDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var filterSavedButton: UIButton!
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    let identifier = "postcell"
    let identifierForDetails = "detailsPost"
    var lastSelected: Post?
    
    func changeSaved() {
        guard let text = searchBar.text else {return}
        if PostData.shared.onlySavedPosts && !text.isEmpty{
            PostData.shared.presentData = PostData.shared.savedData.filter({$0.title.lowercased().contains(text.lowercased())})
        }
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange: String) {
        if textDidChange.isEmpty{ PostData.shared.presentData = PostData.shared.savedData }else{
            PostData.shared.presentData = PostData.shared.savedData.filter({$0.title.lowercased().contains(textDidChange.lowercased())})}
            self.tableView.reloadData()
       }
    

    @IBOutlet private weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.isHidden = true
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        
        PostData.shared.loadPosts{self.tableView.reloadData()}
        self.tableView.keyboardDismissMode = .onDrag
    }
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        switch segue.identifier {
        case self.identifierForDetails:
            let nextVc = segue.destination as! PostDetailsViewController
            DispatchQueue.main.async {
                guard let lastSelected = self.lastSelected else {return}
                nextVc.config(lastSelected, self)
            }

        default: break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !PostData.shared.onlySavedPosts{
            let position = scrollView.contentOffset.y
            if !PostData.shared.fetchMoreData && position > tableView.contentSize.height-700-scrollView.frame.size.height {
                if PostData.shared.after == "" { return }
                PostData.shared.fetchMoreData = true
                PostData.shared.loadForScrollPosts{self.tableView.reloadData()}
            }
        }
    }
    @IBAction func filterSavedAction(_ sender: Any) {
        PostData.shared.onlySavedPosts = !PostData.shared.onlySavedPosts
        if PostData.shared.onlySavedPosts{
            PostData.shared.presentData = PostData.shared.savedData
        }else{
            PostData.shared.presentData = PostData.shared.data
        }
        var nameIcon = ""
        if !PostData.shared.onlySavedPosts{ nameIcon = ".fill" }
        let savedImage = UIImage(systemName: "bookmark.circle\(nameIcon)")
        filterSavedButton.setImage(savedImage, for: .normal)
        searchBar.isHidden = !PostData.shared.onlySavedPosts
        headerText.isHidden = PostData.shared.onlySavedPosts
        searchBar.text = ""
        tableView.reloadData()
    }
    
}

extension PostListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostData.shared.presentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)) as! PostTableViewCell
        cell.configure(PostData.shared.presentData[indexPath.row], self)
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        self.lastSelected = PostData.shared.presentData[indexPath.row]
        self.performSegue(
            withIdentifier: self.identifierForDetails,
            sender: nil
        )
    }
    
}
