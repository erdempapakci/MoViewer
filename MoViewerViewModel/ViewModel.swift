//
//  API.swift
//  MoViewer
//
//  Created by Erdem Papakçı on 10.08.2022.
//

import Foundation
import Alamofire





class API {
    
    class func fetchMovies(_ movies: String, page: Int, onSuccess: @escaping (Results) -> Void) {
         let coder = JSONDecoder()
        
        coder.keyDecodingStrategy = .convertFromSnakeCase
        let baseURL = "https://api.themoviedb.org/3/movie/"
        let posterURL = "https://image.tmdb.org/t/p/original"
        let apiKey = "b410d08e658ae71bbf36343e8779037b"
        
        
        let urlStr = "\(baseURL)\(movies)?api_key=\(apiKey)&page=\(page)"
        guard let url = URL(string: urlStr) else {fatalError("unable to get url")}
        AF.request(url).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else {fatalError("No data returned data from api")}
                guard let results = try? coder.decode(Results.self, from: data) else {fatalError("unable to parse data in to json")}
                DispatchQueue.main.async {
                    onSuccess(results)
                    
                }
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
}
