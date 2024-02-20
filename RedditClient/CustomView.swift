//
//  CustomView.swift
//  RedditClient
//
//  Created by Anastasiia Lysa on 18.02.2024.
//

import UIKit

class CustomView: UIView {

    required init?(coder: NSCoder){
        super.init(coder: coder)
        self.configureView()
    }

    private func configureView(){
        let s = self.loadViewFromXib()
        s.frame = self.bounds
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(s)
    }
    
    private func loadViewFromXib() -> UIView{
        guard let view = Bundle.main.loadNibNamed("CustomView", owner: self)?.first as? UIView else {return UIView()}
        return view
    }

    
}
