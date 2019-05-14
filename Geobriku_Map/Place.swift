//
//  Place.swift
//  Geobriku_Map
//
//  Created by Kristine Legzdina on 16/04/2019.
//  Copyright © 2019 Kristine Legzdina. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class Place: NSObject, MKAnnotation{
    
    let title: String?
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title:String, discipline:String, coordinate:CLLocationCoordinate2D) {
       
        self.title = title
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
        
    }
}

