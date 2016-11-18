//
//  ViewController.swift
//  thomaskamps-pset3
//
//  Created by Thomas Kamps on 15-11-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movies = ["tt0172089"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMovieSegue" {
            let movieVC = segue.destination as? MovieViewController
            let movieIndex = tableView.indexPathForSelectedRow?.row
            movieVC?.imdbID = movies[movieIndex!]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! FavoritesTableViewCell
        
        let imdbID = self.movies[indexPath.row]

        if let searchIM = self.searchIMG[searchKey] as? UIImage {
            cell.poster.image = searchIM
        } else {
            cell.poster.image = UIImage(named: "default_poster")
        }
        
        return cell
    }

}

