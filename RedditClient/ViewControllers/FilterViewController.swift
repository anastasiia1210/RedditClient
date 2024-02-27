//
//  FilterViewController.swift
//  RedditClient
//
//  Created by Anastasiia Lysa on 26.02.2024.
//

import UIKit

class FilterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func filterSavedAction(_ sender: Any) {
        self.onlySavedPosts = !onlySavedPosts
        var nameIcon = ""
        if !self.onlySavedPosts{ nameIcon = ".fill" }
        let savedImage = UIImage(systemName: "bookmark.circle\(nameIcon)")
        filterSavedButton.setImage(savedImage, for: .normal)
        
    }


}
