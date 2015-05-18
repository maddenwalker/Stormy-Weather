//
//  ViewController.swift
//  Stormy
//
//  Created by Ryan Walker on 5/7/15.
//  Copyright (c) 2015 Witt Labs, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let apiKey = valueForKey("FORECAST_API_KEY")
    
    var coreLocationController:CoreLocationController?
    
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var precipitationLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var refreshButton: UIButton!
    @IBOutlet var refreshActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.coreLocationController = CoreLocationController()
        refreshActivityIndicator.hidden = true
    }
    
    
    @IBAction func refreshButtonPressed() {
        
        getCurrentWeatherData()
        
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
        
    }
    
    func getCurrentWeatherData() {
        
        let automaticCoordinates = getCoordinatesForURLCall()
        
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: automaticCoordinates, relativeToURL: baseURL)
        
        let sharedSession = NSURLSession.sharedSession()
        
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL!, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            
            if (error == nil) {
                let dataObject = NSData(contentsOfURL: location)
                let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as! NSDictionary
                
                let currentWeather = Current(weatherDictionary: weatherDictionary)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.temperatureLabel.text = "\(currentWeather.temperature)"
                    self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
                    self.humidityLabel.text = "\(currentWeather.humidity)"
                    self.precipitationLabel.text = "\(currentWeather.precipProbability)"
                    self.summaryLabel.text = "\(currentWeather.summary)"
                    self.iconView.image = currentWeather.icon!
                    
                    self.showRefreshButtonAfterAction()
                })
            } else {
                
                let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data. Connectivity error!", preferredStyle: .Alert)
                
                let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                networkIssueController.addAction(okButton)
                
                let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                networkIssueController.addAction(cancelButton)
                
                self.presentViewController(networkIssueController, animated: true, completion: nil)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.showRefreshButtonAfterAction()
                })
                
            }
            
        })
        downloadTask.resume()
        
    }
    
    func showRefreshButtonAfterAction() {
        self.refreshActivityIndicator.stopAnimating()
        self.refreshActivityIndicator.hidden = true
        self.refreshButton.hidden = false
    }
    
    func getCoordinatesForURLCall() -> String {
        let currentLocation = coreLocationController?.returnLocation()
        let currentLocationFormatted = parseCoordinatesForURL(currentLocation!)
        return currentLocationFormatted
    }
    
    func parseCoordinatesForURL(coordinates: String) -> String {
        var coordinateArray = coordinates.componentsSeparatedByString(" ")
        var coordinatesWithoutSpaces = coordinateArray[0] + coordinateArray[1]
        return coordinatesWithoutSpaces
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

