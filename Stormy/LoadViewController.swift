//
//  LoadViewController.swift
//  Stormy
//
//  Created by Ryan Walker on 5/17/15.
//  Copyright (c) 2015 Witt Labs, LLC. All rights reserved.
//

import UIKit

class LoadViewController: UIViewController {
    
    var coreLocationController:CoreLocationController?
    
    @IBOutlet var loadActivityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadActivityIndicator.startAnimating()
        self.coreLocationController = CoreLocationController()
        coreLocationController?.aLocationManager.startUpdatingLocation()
        
        pauseForLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pauseForLocation() {
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "goToWeatherScreen", userInfo: nil, repeats: false)
    }
    
    func goToWeatherScreen() {

        performSegueWithIdentifier("showWeatherViewSegue", sender: coreLocationController)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showWeatherViewSegue" {
            
            let weatherViewController = segue.destinationViewController as! WeatherViewController
            weatherViewController.locationString = coreLocationController?.locationString
            
        }
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
