//
//  MovieCollectionViewCell.swift
//  MoViewer
//
//  Created by Erdem Papakçı on 10.08.2022.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
    
   @IBOutlet private weak var movieImage:UIImageView!
    
    var movie: Movie? {
        
        didSet{
            backgroundView?.backgroundColor = .black
            if let movie = movie {
                movieImage.kf.setImage(with: "\(movie.posterPath )".url)
                
            }
        }
        
    }
    
}

extension String{
    var url: URL? {
        
        let posterURL = "https://image.tmdb.org/t/p/original"
        
        return URL(string: "\(posterURL)\(self)")
    }
    
}
