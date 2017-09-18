//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Portia Sharma on 9/17/17.
//  Copyright © 2017 Portia Sharma. All rights reserved.
//

import UIKit
import AFNetworking


class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var endpoint: String = ""
    var movies: [NSDictionary]?
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var activityIdicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        activityIdicator.startAnimating()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        
        let reFreshControl = UIRefreshControl()
        reFreshControl.addTarget(self, action: #selector(MoviesViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        reFreshControl.tintColor = UIColor.red
        moviesTableView.addSubview(reFreshControl)
        
        fetchMovies(successCallBack: {dataDictionary in
            self.movies = dataDictionary["results"] as? [NSDictionary]
            self.moviesTableView.reloadData()
            //KRProgressHUD.showSuccess(withMessage: "Success!")
        }, errorCallBack: {err in
            print("There was an error: \(err.debugDescription)")
            //self.networkErrorLabel.isHidden = false
            //KRProgressHUD.set(font: .systemFont(ofSize: 15))
            //KRProgressHUD.showError(withMessage: "Unable to load movies.")
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityIdicator.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
        return movies.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: "MovieCell", for:
            indexPath) as! MovieTableViewCell
        
        let movie = movies?[indexPath.row]
        if let title = movie?["title"] {
            cell.titleLabel.text = title as? String
        }
        else{
            cell.titleLabel.text = "no title"
        }
        if let overview = movie?["overview"] {
            cell.overviewLabel.text = (overview as! String)
            cell.overviewLabel.sizeToFit()
        }
        else{
            cell.overviewLabel.text = "no overview"
        }
        if let posterPath = movie?["poster_path"] as? String {
            let posterUrl = URL(string: "https://image.tmdb.org/t/p/w500" + posterPath)
            cell.posterImageView.setImageWith(posterUrl!)
        }
        else{
            cell.posterImageView.image = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moviesTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func fetchMovies(successCallBack: @escaping (NSDictionary) -> (), errorCallBack: ((Error?) -> ())?) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                errorCallBack?(error)
                self.errorLabel.isEnabled = true
                self.errorLabel.text = "\(error).localizedDescription"
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                //print(dataDictionary)
                successCallBack(dataDictionary)
                self.errorLabel.isEnabled = false
            }
        }
        task.resume()
    }

    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies(successCallBack: { dataDictionary in
            self.movies = dataDictionary["results"] as? [NSDictionary]
        }) { err in
             print("There was a refresh error: \(err.debugDescription)")
        }
        refreshControl.endRefreshing()
        self.moviesTableView.reloadData()
    }

    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        let selectedCell = sender as! UITableViewCell
        let selectedIndexPath = moviesTableView.indexPath(for: selectedCell)
        let selectedMovie = movies![selectedIndexPath!.row]
        
        let nextViewController = segue.destination as! DetailViewController
        nextViewController.movieSelected = selectedMovie
     }
    
    
}
