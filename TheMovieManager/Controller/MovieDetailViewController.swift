

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var watchlistBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var favoriteBarButtonItem: UIBarButtonItem!
    
    var movie: Movie!
    
    var isWatchlist: Bool {
        return MovieModel.watchlist.contains(movie)
    }
    
    var isFavorite: Bool {
        return MovieModel.favorites.contains(movie)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = movie.title
        
        toggleBarButton(watchlistBarButtonItem, enabled: isWatchlist)
        toggleBarButton(favoriteBarButtonItem, enabled: isFavorite)
        
        self.imageView.image = UIImage(named: "PosterPlaceholder")
        TMDBClient.downloadPosterImage(posterPath: movie.posterPath ?? "") { data, error in
            guard let data = data else {
                return
            }
            self.imageView.image = UIImage(data: data)
        }
    }
    
    @IBAction func watchlistButtonTapped(_ sender: UIBarButtonItem) {
        TMDBClient.markWatchlist(movieId: movie.id, watchlist: !self.isWatchlist, completionHandler: self.handleWatchlistResponse(bool:error:))
    }
    
    func handleWatchlistResponse(bool: Bool, error: Error?) {
        if bool {
            if self.isWatchlist {
                MovieModel.watchlist = MovieModel.watchlist.filter() { $0 != self.movie}
            } else {
                MovieModel.watchlist.append(self.movie)
            }
            toggleBarButton(watchlistBarButtonItem, enabled: self.isWatchlist)
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        TMDBClient.markFavorite(movieId: movie.id, watchlist: !self.isFavorite, completionHandler: self.handleFavoriteResponse(bool:error:))
    }
    
    func handleFavoriteResponse(bool: Bool, error: Error?) {
        if bool {
            if self.isFavorite {
                MovieModel.favorites = MovieModel.favorites.filter() { $0 != self.movie}
            } else {
                MovieModel.favorites.append(self.movie)
            }
            toggleBarButton(favoriteBarButtonItem, enabled: self.isFavorite)
        }
    }
    
    func toggleBarButton(_ button: UIBarButtonItem, enabled: Bool) {
        if enabled {
            button.tintColor = UIColor.primaryDark
        } else {
            button.tintColor = UIColor.gray
        }
    }
    
    
}
