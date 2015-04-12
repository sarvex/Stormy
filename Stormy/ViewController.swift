//
//  ViewController.swift
//  Stormy
//
//  Created by Sarvex Jatasra on 12/04/2015.
//  Copyright (c) 2015 Sarvex Jatasra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let apiKey = "67956a9ceb424f3351b13961904768a4"

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshActivityIndicator.hidden = true
        downloadTemperature()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func refreshClicked(sender: UIButton) {
        refreshButton.hidden = true;
        refreshActivityIndicator.hidden = false;
        refreshActivityIndicator.startAnimating();
        downloadTemperature()
    }

    private func downloadTemperature () {
        let baseUrl = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let coordinateUrl = NSURL(string: "28.4700,77.0300", relativeToURL: baseUrl)
        let forecastUrl = NSURL(string: "?units=ca", relativeToURL: coordinateUrl)

        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastUrl!,
            completionHandler:{ (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in

                if (error == nil) {
                    let dataObject = NSData(contentsOfURL: location)
                    let weatherDictionary:NSDictionary =
                    NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as! NSDictionary

                    let currentWeather = Current(weatherDictionary: weatherDictionary)

                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.iconView.image = currentWeather.icon!
                        self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
                        self.temperatureLabel.text = "\(currentWeather.temperature)"
                        self.humidityLabel.text = "\(currentWeather.humidity)"
                        self.precipitationLabel.text = "\(currentWeather.precipitationProbability)"
                        self.summaryLabel.text = "\(currentWeather.summary)"

                        self.refreshActivityIndicator.stopAnimating()
                        self.refreshActivityIndicator.hidden = true
                        self.refreshButton.hidden = false
                    })
                } else {
                    let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data. Connectivity Error", preferredStyle: .Alert)

                    let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    networkIssueController.addAction(okButton)
                    let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                    networkIssueController.addAction(cancelButton)

                    self.presentViewController(networkIssueController, animated: true, completion: nil)

                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.refreshActivityIndicator.stopAnimating()
                        self.refreshActivityIndicator.hidden = true
                        self.refreshButton.hidden = false
                    })
                }
        })
        downloadTask.resume()
    }
}

