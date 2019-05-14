//
//  FirebaseController.swift
//  Geobriku_Map
//
//  Created by Kristine Legzdina on 14/05/2019.
//  Copyright © 2019 Kristine Legzdina. All rights reserved.
//

import Foundation
import MapKit
import Firebase

class FirebaseController {
    
    func sendData(_ name : String!, _ info : String!, _ lat: Double!,_ long: Double! ) -> Void{
        Database.database().reference().child("Place").child(name).setValue(["name": name,"info": info, "latitude": lat,"longitude": long])
        
    }
    
    func retrieveData(_ type: String, success: @escaping ([Place]) -> ()) {
        Database.database().reference().child(type).observe(.value) { snapshot in
            var addedLocations = [Place]()
            for loc in snapshot.children.allObjects as! [DataSnapshot]{
                if let myLocations = loc.value as? [String:AnyObject] {
                    let location = Place(title: myLocations["name"] as! String,
                                            discipline: myLocations["info"] as! String,
                                            coordinate: CLLocationCoordinate2D(latitude: myLocations["latitude"] as! Double , longitude: myLocations["longitude"] as! Double))
                    
                    addedLocations.append(location)
                }
            }
            
            success(addedLocations)
        }
        
    }
}
