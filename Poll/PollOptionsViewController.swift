//
//  PollOptionsViewController.swift
//  Poll
//
//  Created by Brian Lee on 5/26/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class PollOptionsViewController: UIViewController, MKMapViewDelegate {
    
    var numOptions: Int?
    var currentLocation: CLLocation?
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton.layer.cornerRadius = 8
        
        mapView.delegate = self
        
        nameTextField.delegate = self
        
        setupLocationServices()
        
        nameTextField.text = ""
        nameTextField.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        createButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onNumOptionsChange(sender: AnyObject) {
        let segControl = sender as! UISegmentedControl
        numOptions = segControl.selectedSegmentIndex + 1
    }
    
    @IBAction func onCreatePoll(sender: AnyObject) {
        createButton.enabled = false
        
        if(numOptions == nil) {
            numOptions = 1
        }
        
        let poll = Poll(optionsCount: numOptions!, location: currentLocation!, author: User.currentUser!, title: nameTextField.text!)
        
        APIClient.createPoll(poll) { (response, error) -> () in
            if error != nil{
                print(error?.localizedDescription)
            } else {
                poll.id = response![0]
                poll.server_id = response![1]
                
                APIClient.getPollStats(poll.id!) { (stats, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                    } else {
                        poll.stats = stats!
                        self.performSegueWithIdentifier("CreatePollWithOptions", sender: poll)
                    }
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CreatePollWithOptions" {
            let vc = segue.destinationViewController as! PollingViewController
            let poll = sender as! Poll
            vc.currentPoll = poll
        }
    }

}

extension PollOptionsViewController: CLLocationManagerDelegate {
    func getCurrentLocation() {
        centerMapOnLocation(currentLocation!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = currentLocation!.coordinate
        mapView.addAnnotation(annotation)
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
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func setupLocationServices() {
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
}

extension PollOptionsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
