//
//  ViewController.swift
//  Kentro
//
//  Created by Nguyen, Le on 6/2/16.
//  Copyright © 2016 Nguyen, Le. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet var AddButton: UIButton!
    @IBOutlet var SubmitButton: UIButton!
    @IBOutlet var InputField: UITextField!
    @IBOutlet var CoordinateField: UITextView!
    @IBOutlet var CenterLabel: UILabel!
    @IBOutlet var MapView: MKMapView!
    
    let geocoder = CLGeocoder();
    var geoLocations = [CLLocationCoordinate2D]();
    
    @IBAction func AddAddress(sender: UIButton, forEvent event: UIEvent) {
        CoordinateField.text.appendContentsOf("\n" + InputField.text!);
        
        geocoder.geocodeAddressString(InputField.text!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil) {
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates = placemark.location!.coordinate;
                self.CoordinateField.text.appendContentsOf("\nlatitude " + coordinates.latitude.description + " longitude " + coordinates.longitude.description)
                self.geoLocations.append(coordinates);
            }
        });
    }
    
    
    @IBAction func CalculateCenter(sender: UIButton) {
        if geoLocations.count == 0 {
            return;
        }
        
        var lowLong = geoLocations[0].longitude;
        var highLong = geoLocations[0].longitude;
        var lowLat = geoLocations[0].latitude;
        var highLat = geoLocations[0].latitude;
        
        for location in geoLocations {
            if location.latitude < lowLat {
                lowLat = location.latitude;
            }
            if location.latitude > highLat {
                highLat = location.latitude;
            }
            if location.longitude < lowLong {
                lowLong = location.longitude
            }
            if location.longitude > highLong {
                highLong = location.longitude
            }
        }

        let centerLat = lowLat + ((highLat - lowLat) / 2);
        let centerLong = lowLong + ((highLong - lowLong) / 2);
        CenterLabel.text = "Long " + centerLong.description + " Lat " + centerLat.description;
        
        let span = MKCoordinateSpanMake((highLat - lowLat), (highLong - lowLong));
        let center = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLong);
        let annotation = MKPointAnnotation();
        annotation.coordinate = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLong)
        
        MapView.region = MKCoordinateRegionMake(center, span);
        MapView.addAnnotation(annotation);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

