//
//  DetailsVC.swift
//  MoViewer
//
//  Created by Erdem Papakçı on 10.08.2022.
//

import UIKit
import Kingfisher
import MBCircularProgressBar

class DetailsVC: UIViewController {
    @IBOutlet weak var userVote: MBCircularProgressBarView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var ratingText: UILabel!
    @IBOutlet weak var overviewText: UILabel!
    @IBOutlet weak var releaseDateText: UILabel!
    @IBOutlet weak var movieNameText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var movie : Movie? = nil
    private var urlString: String = ""
    
    override func viewDidLoad() {
        
        view.backgroundColor = .black
        self.userVote.value = 0
        movieNameText.text = movie?.title
        overviewText.text = movie?.overview
        releaseDateText.text = "Release Date: \(movie!.releaseDate)"
        ratingText.text = "User Score"
        
        imageView.kf.setImage(with: "\(movie!.posterPath )".url)
        mainImageView.kf.setImage(with: "\(movie!.backdropPath )".url)
        self.userVote.value = 0
      
    }
    override func viewDidAppear(_ animated: Bool) {
      
        UIView.animate(withDuration: 4.0) {
            
            self.userVote.value = (self.movie?.voteAverage)! * 10
        }
    }
    
}

