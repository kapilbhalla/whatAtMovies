//
//  MovieDetailsViewController.swift
//  whatsAtMovies
//
//  Created by Bhalla, Kapil on 4/4/17.
//  Copyright © 2017 Bhalla, Kapil. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    var url: String?
    var movieDesc: String?
    var movieName: String = ""

    @IBOutlet weak var movieImage: UIView!
    @IBOutlet weak var movieDetailsLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieDetailsContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        movieImageView.setImageWith((URL(string: url!)!))
        movieDetailsLabel.text = movieDesc
        movieDetailsLabel.sizeToFit()

        movieImage.bringSubview(toFront: movieDetailsContainer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
