//
//  moviesViewController.swift
//  whatsAtMovies
//
//  Created by Bhalla, Kapil on 4/3/17.
//  Copyright © 2017 Bhalla, Kapil. All rights reserved.
//

import UIKit

class moviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // reference to the table view showing the movies
    @IBOutlet weak var mTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mTableView.dataSource = self
        mTableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20;    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        cell.textLabel!.text = "row \(indexPath.row)"
        print("row \(indexPath.row)")
        return cell
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
