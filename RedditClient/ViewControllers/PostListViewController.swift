import UIKit

class PostListViewController: UIViewController {
    let identifier = "postcell"
    let identifierForDetails = "detailsPost"
    var data: [Post] = []
    var after = ""
    var fetchMoreData = false
    var lastSelected: Post?

    @IBOutlet private weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        FetchData.fetchData.fetchPosts(subreddit: "ios", parametrs: [("limit", "8")]){
            [weak self] values, valueAfter in
            DispatchQueue.main.async {
                guard let self else {return}
                self.data = values
                self.after = valueAfter
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        switch segue.identifier {
        case self.identifierForDetails:
            let nextVc = segue.destination as! PostDetailsViewController
            DispatchQueue.main.async {
                guard var lastSelected = self.lastSelected else {return}
                nextVc.config(lastSelected)
            }

        default: break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if !self.fetchMoreData && position > tableView.contentSize.height-700-scrollView.frame.size.height {
            if self.after == "" { return }
            self.fetchMoreData = true
            FetchData.fetchData.fetchPosts(subreddit: "ios", parametrs: [("limit", "10"),("after", "\(after)")]){
               [weak self] values, valueAfter in
                DispatchQueue.main.async {
                    guard let self else {return}
                    self.data += values
                    self.after = valueAfter
                    self.tableView.reloadData()
                    self.fetchMoreData = false
                }
            }
        }
    }
}

extension PostListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)) as! PostTableViewCell
        let dataForCell = self.data[indexPath.row]
        cell.configure(dataForCell)
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        self.lastSelected = self.data[indexPath.row]
        self.performSegue(
            withIdentifier: self.identifierForDetails,
            sender: nil
        )
    }
    
}
