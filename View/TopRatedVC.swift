//
//  TopRatedVC.swift
//  MoViewer
//
//  Created by Erdem Papakçı on 10.08.2022.
//

import UIKit

class TopRatedVC: UIViewController {
    @IBOutlet private weak var collectionView : UICollectionView!
    
    private var movies : [Movie]?
    private var page: Int = 1
    private var totalPages: Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fetch()
        let width = (view.frame.size.width - 20 ) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 190)
    }
    
    private func fetch(_ page: Int = 1) {
        API.fetchMovies("top_rated", page:page) { data in
            self.totalPages = data.totalPages
            self.movies = data.results
            self.collectionView.reloadData()
            self.title = "TOP RATED MOVIES"
        }
        
    }
    
    private func loadMoreData() {
        if page < totalPages {
            page += 1
            OperationQueue.main.addOperation {
                API.fetchMovies("top_rated", page:self.page) { data in
                    self.movies? += data.results
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
}
extension TopRatedVC : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopRated", for: indexPath) as! MovieCollectionViewCell
        cell.movie = movies?[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = movies?.count else {fatalError()}
        if indexPath.item == count - 1 {
            self.loadMoreData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
}
