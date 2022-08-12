//
//  Movie.swift
//  MoViewer
//
//  Created by Erdem Papakçı on 10.08.2022.
//

import Foundation

struct Movie : Codable {
    
    let id : Int?
    var title : String?
    let overview : String?
    let posterPath : String
    let backdropPath : String
    let voteCount : Double
    let voteAverage : Double?
    let releaseDate : String
}
