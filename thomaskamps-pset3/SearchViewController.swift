//
//  SearchViewController.swift
//  thomaskamps-pset3
//
//  Created by Thomas Kamps on 15-11-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchData: NSMutableDictionary = [:]
    var searchKeys: NSMutableArray = []
    var searchIMG: NSMutableDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMovieSegue" {
            let movieVC = segue.destination as? MovieViewController
            let movieIndex = tableView.indexPathForSelectedRow?.row
            movieVC?.imdbID = searchKeys[movieIndex!] as! String
        }
    }
    
    func getJSON(givenURL: URL){
        URLSession.shared.dataTask(with: givenURL as URL, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Geen error")
                return
            }
            
            do {
                let parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let parsedDataDict = parsedData as NSDictionary
                if let parsedDataSearch = parsedDataDict["Search"] as? [[String: String]]{
                    for movie in parsedDataSearch {
                        let item = movie as? [String: String]
                        self.searchKeys.add(item?["imdbID"])
                        let title = item!["Title"] as? String!
                        let year = item?["Year"] as? String!
                        let posterUrl = item?["Poster"] as? String!
                        self.searchData[item?["imdbID"]] = ["title": title!, "year": year!, "posterUrl": posterUrl!] as [String: String]
                    }
                    for item in self.searchKeys {
                        self.getIMG(givenID: item as! String)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "No results", message: "Try again..", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Go back", style: UIAlertActionStyle.default,handler: nil))
                        
                        self.present(alertController, animated: true, completion: nil)
                        self.searchBar.text = ""
                    }
                }
            } catch {
                print("Error")
            }
        }).resume()
    }
    
    func getIMG(givenID: String){
        let item = self.searchData[givenID]! as! [String: String]
        var posterUrl = item["posterUrl"]!
        posterUrl = posterUrl.replacingOccurrences(of: "http://", with: "https://")
        let posterUrlNew = URL(string: posterUrl)
        
        URLSession.shared.dataTask(with: posterUrlNew! as URL, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Geen error")
                return
            }
            DispatchQueue.main.async {
                self.searchIMG[givenID] = UIImage(data:data)
                self.tableView.reloadData()
            }
            
        }).resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchTableViewCell
        
        let searchKey = self.searchKeys[indexPath.row]
        let searchDat = self.searchData[searchKey] as! [String: String]
        
        cell.title.text = searchDat["title"]
        cell.subtitle.text = searchDat["year"]
        
        if let searchIM = self.searchIMG[searchKey] as? UIImage {
            cell.poster.image = searchIM
        } else {
            cell.poster.image = UIImage(named: "default_poster")
        }
        return cell
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchData = [:]
        searchKeys = []
        searchIMG = [:]
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyWord = searchBar.text!.replacingOccurrences(of: " ", with: "%20")
        let searchURL = URL(string: "https://www.omdbapi.com/?r=json&s="+keyWord)
        getJSON(givenURL: searchURL!)
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
