<h1 align="center">MoViewer</h1>
<p align="center">

 <img src="https://img.shields.io/badge/status-Active-green" height="20"> <img src="https://img.shields.io/badge/architecture-MVVM-yellow" height="20"> <img src="https://img.shields.io/badge/language-Swift-yellow" height="20"> 

 
 The Movie Database (TMDb) iOS App in Swift - https://developers.themoviedb.org/3/getting-started/introduction
 
 
 <img src="https://user-images.githubusercontent.com/73407945/184416862-fdfeb7f2-7344-47a9-8c9b-4af33eca6048.png" width="200" height="400" /> <img src="https://user-images.githubusercontent.com/73407945/184416823-1bf4e85e-9da5-42c4-a7dd-25fd6c281dc5.png" width="200" height="400" /><img src="https://user-images.githubusercontent.com/73407945/184417759-c7a1f623-eb6b-49a1-99c3-600adcc32639.png" width="200" height="400" />



 
## Technical specs
 - Language: Swift
- Architecture: MVVM
- ViewModels for storing UI state
- Swift standard coding/decoding for custom objects
 
 ## Features
 - Top Rated Movies Tab
- Popular Movies Tab
- Movie Detail view (Overview, Images, Release Date, User Score)
 
 ## Model
 ```javascript 
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
 ```
  ```javascript
 struct Results: Codable {
    
    let results: [Movie]
    let page : Int
    let totalPages : Int
    let totalResults : Int
}
```

 ## Popular movies view controller
 

 ```javascript
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
```
                            
 ## Extensions
                            
  ```javascript                         
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

  ```  
## Details view controller
 

<img src="https://user-images.githubusercontent.com/73407945/184419693-0a4bdba5-8bb8-45da-882f-f03653246d08.gif" width="200" height="400" />


 ```javascript
 import Alamofire
 import MBCircularProgressBar
  ```
 ```javascript 
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

  ```
 ## Collection view cell
 ```javascript 
 import Kingfisher 
 ```
 ```javascript 
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
 ```
 
 
 ## Networking 
 ```javascript 
 class func fetchMovies(_ movies: String, page: Int, onSuccess: @escaping (Results) -> Void) {
         let coder = JSONDecoder()
        
        coder.keyDecodingStrategy = .convertFromSnakeCase
        let baseURL = "https://api.themoviedb.org/3/movie/"
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
  ```
