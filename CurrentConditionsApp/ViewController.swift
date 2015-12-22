//
//  ViewController.swift
//  CurrentConditionsApp
//
//  Created by Mary Grace Lucas on 11/22/15.
//  Copyright © 2015 Mary Grace Lucas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var enterCityTextField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
   
    
    
    @IBAction func findOutButtonPressed(sender: UIButton) {
        
        self.dismissKeyboard()
        
        var wasSuccessful = false
      
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + enterCityTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        if let url = attemptedUrl {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if let urlContent = data {
                    
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    
                    let websiteArray = webContent!.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                    
                    if websiteArray.count > 1 {
                        let weatherArray = websiteArray[1].componentsSeparatedByString("</span>")
                        
                        if weatherArray.count > 1 {
                            
                            wasSuccessful = true
                            
                            let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                self.resultLabel.text = weatherSummary
                                
                                print(weatherSummary)
                                
                                self.resultLabel.hidden = false
                             
                                    
                            
                                
                            })
                            
                        }
                        
                    }
                    
                    if wasSuccessful == false {
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.resultLabel.text = "Could not find weather for this ciy. Please try again."
                            
                            self.resultLabel.hidden = false
                            
                            print(self.resultLabel.text)
                            
                        })
                        
                        
                    }
                    
                }
                
            }
            
            task.resume()
            
            
        }
        else {
            
            self.resultLabel.text = "Could not find weather for this ciy. Please try again."
            
            self.resultLabel.hidden = false
            
        }
        
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
            view.addGestureRecognizer(tap)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
}

