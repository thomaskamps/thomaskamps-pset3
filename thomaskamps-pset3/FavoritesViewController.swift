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

    var movies: [String] = []
    var movieData: Dictionary <String, Dictionary <String, String>> = [:]
    var moviePoster: Dictionary <String, Data> = [:]
    
    func getJSON(givenID: String){
        let reqURL = URL(string: "https://www.omdbapi.com/?plot=full&r=json&i="+givenID)
        URLSession.shared.dataTask(with: reqURL! as URL, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Geen error")
                return
            }
            
            do {
                let parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let parsedDataDict = parsedData as Dictionary
                DispatchQueue.main.async {
                    self.movieData[givenID] = [:] as Dictionary <String, String>
                    self.movieData[givenID]?["title"] = parsedDataDict["Title"] as! String?
                    self.movieData[givenID]?["year"] = parsedDataDict["Year"] as! String?
                    self.movieData[givenID]?["posterUrl"] = parsedDataDict["Poster"] as! String?
                    self.tableView.reloadData()
                    self.getIMG(givenID: givenID)
                }
                
            } catch {
                print("Error")
            }
        }).resume()
    }
    
    func getIMG(givenID: String){
        let posterUrlTemp = self.movieData[givenID]?["posterUrl"]
        let posterUrl = posterUrlTemp?.replacingOccurrences(of: "http://", with: "https://")
        let posterUrlnew = URL(string: posterUrl!)
        
        URLSession.shared.dataTask(with: posterUrlnew! as URL, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Geen error")
                return
            }
            DispatchQueue.main.async {
                self.moviePoster[givenID] = data
                self.tableView.reloadData()
            }
            
        }).resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userDef = UserDefaults.standard
        self.movies = userDef.object(forKey:"savedMovies") as? [String] ?? [String]()
        for movie in self.movies {
            getJSON(givenID: movie)
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMovieFavSegue" {
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

        if let poster = self.moviePoster[imdbID] {
            cell.posterOutlet.image = UIImage(data: poster)
        } else {
            cell.posterOutlet.image = UIImage(named: "default_poster")
        }
        
        if let title = self.movieData[imdbID]?["title"] {
            cell.titleOutlet.text = title
        } else {
            cell.titleOutlet.text = ""
        }
        
        if let subtitle = self.movieData[imdbID]?["year"] {
            cell.subtitleOutlet.text = subtitle
        } else {
            cell.subtitleOutlet.text = ""
        }
        
        return cell
    }

}

