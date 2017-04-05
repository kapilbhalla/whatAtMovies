//
//  moviesViewController.swift
//  whatsAtMovies
//
//  Created by Bhalla, Kapil on 4/3/17.
//  Copyright © 2017 Bhalla, Kapil. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class moviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // reference to the table view showing the movies
    @IBOutlet weak var mTableView: UITableView!
    
    var posts: [NSDictionary]?
    var selectedCell: PhotoCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mTableView.dataSource = self
        mTableView.delegate = self
        // Do any additional setup after loading the view.
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        moviesViewController.fetchMovies(successCallBack: setTableData, errorCallBack: handleErrors)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        
        mTableView.insertSubview(refreshControl, at: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showMovieDetailsSegue"){
            let cell = sender as! PhotoCell
            if let indexPath = mTableView.indexPathForSelectedRow{
                mTableView.deselectRow(at: indexPath, animated: true)
            }
            let destination = segue.destination as! MovieDetailsViewController
        
            destination.url = cell.mainImageURL
            destination.movieDesc = cell.movieDesc
            destination.movieName = cell.movieName!
        }
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        moviesViewController.fetchMovies(successCallBack: setTableData, errorCallBack: handleErrors)
        
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
    }

    // Data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = self.posts {
            return posts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! PhotoCell
        
        if let posts = self.posts {
            cell.movieTitle.text = posts[indexPath.row]["title"] as! String
            
            let movieDetails = posts[indexPath.row]["overview"] as! String
            cell.movieDetails.text = movieDetails
            let posterPath = posts[indexPath.row]["poster_path"] as! String
            let posterSize = "/w92"
            let fullSize = "/original"
            let posterImgUrl = "https://image.tmdb.org/t/p" + posterSize + posterPath
            let fullImageUrl = "https://image.tmdb.org/t/p" + fullSize + posterPath
            
            cell.mainImageURL = fullImageUrl
            cell.movieDesc = movieDetails
            cell.movieName = cell.movieTitle.text
            cell.posterImg.setImageWith(URL(string: posterImgUrl)!)
            
            // add red back ground color for the selected cell
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.blue
            cell.selectedBackgroundView = backgroundView
        }

        return cell
    }
    
    class func fetchMovies(successCallBack: @escaping (NSDictionary) -> (), errorCallBack: ((Error?) -> ())?) {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 5)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                errorCallBack?(error)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                //print(dataDictionary)
                successCallBack(dataDictionary)
            }
        }
        task.resume()
    }
    
    func setTableData (movies: NSDictionary) {
        // Hide HUD once the network request comes back (must be done on main UI thread)
        MBProgressHUD.hide(for: self.view, animated: true)
        
        self.posts = movies["results"] as! [NSDictionary]
        self.mTableView.reloadData()
    }
    
    func handleErrors (error: Error?){
        // Hide HUD once the network request comes back (must be done on main UI thread)
        MBProgressHUD.hide(for: self.view, animated: true)
        
        let errorMessage = "check network connectivity"
        let alertController = UIAlertController(title: "Network Error", message: errorMessage, preferredStyle: .alert)
        alertController.show(self, sender: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func bookMovieTicket (segue: UIStoryboardSegue){
        // Hook up this code with ticket booking page
        let movieInformationController = segue.source as! MovieDetailsViewController
        
        print ("booked tickets for " + movieInformationController.movieName)
    }
}


class PhotoCell: UITableViewCell {
    
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDetails: UILabel!
    
    var mainImageURL: String?
    var movieDesc: String?
    var movieName: String?
}
