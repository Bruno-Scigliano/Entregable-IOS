//
//  ATMMarker.swift
//  Trabajo Entregable 1
//
//  Created by SP20 on 17/5/18.
//  Copyright © 2018 SP20. All rights reserved.
//

import MapKit

class ATMMarker: NSObject, MKAnnotation {
    let title: String?
    let atm : ATM
    let coordinate: CLLocationCoordinate2D
    
    init(atm: ATM, coordinate: CLLocationCoordinate2D) {
        self.title        = atm.network
        self.atm          = atm
        self.coordinate   = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return atm.addresss
    }
}
