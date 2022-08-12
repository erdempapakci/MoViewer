//
//  Results.swift
//  MoViewer
//
//  Created by Erdem Papakçı on 10.08.2022.
//

import Foundation

struct Results: Codable {
    
    let results: [Movie]
    let page : Int
    let totalPages : Int
    let totalResults : Int
}
