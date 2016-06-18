//
//  JoinPollViewController.swift
//  Poll
//
//  Created by Brian Lee on 5/27/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class JoinPollViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var takePollMapView: MKMapView!
    
    @IBOutlet weak var joinButton: UIButton!

    var currentLocation: CLLocation?
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        joinButton.layer.cornerRadius = 8
        
        takePollMapView.delegate = self
        
        setupTextField()
        setupLocationServices()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        codeTextField.text = ""
    }
    
    override func viewDidAppear(animated: Bool) {
        codeTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func unableToJoinPollPrompt() {
        let alert = UIAlertController(title: "Uh oh!", message: "Unable to join this poll. Check to make sure you have the right code and that your location services is on.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
            self.codeTextField.text = ""
            self.codeTextField.becomeFirstResponder()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func outOfRangePrompt() {
        let alert = UIAlertController(title: "Uh oh!", message: "You are too far away from this poll to join. Try getting closer to the poll and check to make sure you have the right code.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
            self.codeTextField.text = ""
            self.codeTextField.becomeFirstResponder()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func onJoin(sender: AnyObject) {
        APIClient.joinPoll(codeTextField.text!) { (optionsCount, longitude, latitude, error) in
            if error != nil {
                print(error?.localizedDescription)
                
                self.unableToJoinPollPrompt()
                
            } else {
                let lat = (latitude! as NSString).doubleValue
                let long = (longitude! as NSString).doubleValue
                let pollLocation = CLLocation(latitude: lat, longitude: long)
                
                let distance = self.currentLocation!.distanceFromLocation(pollLocation)
                print(distance)
                
                if distance > 500 {
                    self.outOfRangePrompt()
                } else {
                    self.performSegueWithIdentifier("AnswerPoll", sender: optionsCount!)
                }
            }
        }
    }

    @IBAction func onBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AnswerPoll" {
            let vc = segue.destinationViewController as! AnswerPollViewController
            let str = sender! as! String
            vc.pollOptions = Int(str)
            vc.pollid = codeTextField.text!
        }
    }

}

extension JoinPollViewController: UITextFieldDelegate {
    func setupTextField() {
        codeTextField.delegate = self
        codeTextField.becomeFirstResponder()
        codeTextField.addTarget(self, action: #selector(JoinPollViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        codeTextField.text = ""
    }
    
    func textFieldDidChange(textField: UITextField) {
        if(codeTextField.text!.characters.count == 4) {
            codeTextField.resignFirstResponder()
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 4 // Bool
    }
}

extension JoinPollViewController: CLLocationManagerDelegate {
    func setupLocationServices() {
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func getCurrentLocation() {
        centerMapOnLocation(currentLocation!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = currentLocation!.coordinate
        takePollMapView.addAnnotation(annotation)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue = manager.location!
        
        if currentLocation == nil {
            currentLocation = locValue
            getCurrentLocation()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        takePollMapView.setRegion(coordinateRegion, animated: true)
    }
}
