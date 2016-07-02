//
//  CenterService.swift
//  Kentro
//
//  Created by Nguyen, Le on 7/2/16.
//  Copyright © 2016 Nguyen, Le. All rights reserved.
//

import Foundation
import MapKit

class GeoService {
    init() {}

    func calculateCenter(geoLocations: [CLLocationCoordinate2D]!) -> CLLocationCoordinate2D?
    {
        if (geoLocations.count == 0)
        {
            return nil;
        }
        
        let boundingBox = calculateBoundingBox(geoLocations)
        
        return calculateCenter(boundingBox);
    }
    
    func calculateCenter(boundingBox: BoundingBox!) -> CLLocationCoordinate2D
    {
        let centerLat = boundingBox.BottomLeft.latitude + ((boundingBox.TopRight.latitude - boundingBox.BottomLeft.latitude) / 2);
        let centerLong = boundingBox.BottomLeft.longitude + ((boundingBox.TopRight.longitude - boundingBox.BottomLeft.longitude) / 2);
        
        return CLLocationCoordinate2D(latitude: centerLat, longitude: centerLong)
    }
    
    func calculateBoundingBox(geoLocations: [CLLocationCoordinate2D]) -> BoundingBox
    {
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
        
        return BoundingBox(bottomLeft: CLLocationCoordinate2D(latitude: lowLat, longitude: lowLong),
            topRight: CLLocationCoordinate2D(latitude: highLat, longitude: highLong));
    }
    
    func getGeoLocation (address: String!, complete: ([CLPlacemark]?, NSError?) -> Void)
    {
        let geocoder = CLGeocoder();
        geocoder.geocodeAddressString(address, completionHandler: complete);
    }
}