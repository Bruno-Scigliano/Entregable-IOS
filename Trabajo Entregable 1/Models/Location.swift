//
//  Location.swift
//  Trabajo Entregable 1
//
//  Created by SP20 on 17/5/18.
//  Copyright © 2018 SP20. All rights reserved.
//

import Foundation
import ObjectMapper

struct Location : Mappable{
    
    var latitude : Double?
    var longitde : Double?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        latitude <- map["lat"]
        longitde <- map["lon"]
    }
}
