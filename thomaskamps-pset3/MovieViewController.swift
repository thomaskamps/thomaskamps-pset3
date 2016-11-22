//
//  MovieViewController.swift
//  thomaskamps-pset3
//
//  Created by Thomas Kamps on 18-11-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var textOutlet: UITextView!
    @IBOutlet weak var subtitleOutlet: UILabel!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var imgOutlet: UIImageView!
    @IBOutlet weak var button: UIButton!

    var imdbID: String = ""
    var movies: [String] = []
    
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
                    self.titleOutlet.text = parsedDataDict["Title"] as! String?
                    self.subtitleOutlet.text = parsedDataDict["Year"] as! String?
                    self.textOutlet.text = parsedDataDict["Plot"] as! String?
                }
                self.getIMG(givenURL: parsedDataDict["Poster"] as! String)
            } catch {
                print("Error")
            }
        }).resume()
    }
    
    func getIMG(givenURL: String){
        let posterUrl = givenURL.replacingOccurrences(of: "http://", with: "https://")
        let posterUrlnew = URL(string: posterUrl)
        
        URLSession.shared.dataTask(with: posterUrlnew! as URL, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Geen error")
                return
            }
            DispatchQueue.main.async {
                self.imgOutlet.image = UIImage(data:data)
            }
            
        }).resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getJSON(givenID: imdbID)
        let userDef = UserDefaults.standard
        self.movies = userDef.object(forKey:"savedMovies") as? [String] ?? [String]()
        if movies.contains(imdbID) {
            button.setTitle("Remove from watchlist", for: .normal)
            button.setTitleColor(UIColor.red, for: .normal)
        } else {
            button.setTitle("Add to watchlist", for: .normal)
            button.setTitleColor(UIColor.blue, for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonFix(_ sender: Any) {
        let userDef = UserDefaults.standard
        if movies.contains(imdbID) {
            button.setTitle("Add to watchlist", for: .normal)
            button.setTitleColor(UIColor.blue, for: .normal)
            if let index = self.movies.index(of: imdbID) {
                self.movies.remove(at: index)
                userDef.set(self.movies, forKey: "savedMovies")
            }
        } else {
            button.setTitle("Remove from watchlist", for: .normal)
            button.setTitleColor(UIColor.red, for: .normal)
            self.movies.append(imdbID)
            userDef.set(self.movies, forKey: "savedMovies")
        }
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
