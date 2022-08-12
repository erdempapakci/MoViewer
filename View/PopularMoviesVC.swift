//
//  PopularMoviesVC.swift
//  MoViewer
//
//  Created by Erdem Papakçı on 10.08.2022.
//

import UIKit
import CoreMedia

private let identifier = "MovieCell"

class PopularMoviesVC: UIViewController {
    
    @IBOutlet private weak var collectionView : UICollectionView!
    
    private var movies : [Movie]?
    var moviTitle : String?
    var movier : Movie? = nil
    private var page: Int = 1
    private var totalPages: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = (view.frame.size.width - 20 ) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 190)
        fetch()
    }
    
    private func fetch(_ page: Int = 1) {
        API.fetchMovies("popular", page: page) { data in
            self.totalPages = data.totalPages
            self.movies = data.results
            self.collectionView.reloadData()
            
            self.title = "POPULAR MOVIES"
            
        }
    
    }
    
    private func loadMoreData() {
        if page < totalPages {
            page += 1
            OperationQueue.main.addOperation {
                API.fetchMovies("popular", page: self.page) { data in
                    self.movies? += data.results
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension PopularMoviesVC : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MovieCollectionViewCell
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
        
        guard let movie = movies?[indexPath.row] else {return}
        
        self.movier = movie
        performSegue(withIdentifier: "ToDetails", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetails" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.movie = movier
            
        }
    }
    
}


