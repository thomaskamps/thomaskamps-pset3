//
//  APIconnect.swift
//  Watch List
//
// This class handles an API connection for either JSON data or image files
//
import Foundation

class APIconnect {

    func getJSON(givenURL: URL){
        URLSession.shared.dataTask(with: givenURL as URL, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Geen error")
                return
            }
            
            do {
                let parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                for (key, value) in parsedData {
                    print("\(key) - \(value) ")
                }
            } catch {
                print("Error")
            }
        }).resume()
    }
}
