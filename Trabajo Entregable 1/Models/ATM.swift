//
//  ATM.swift
//  Trabajo Entregable 1
//
//  Created by SP20 on 17/5/18.
//  Copyright © 2018 SP20. All rights reserved.
//

import Foundation
import ObjectMapper

enum ATMStatus : String{
    case normal     = "normal"
    case withTint   = "normal (with tint)"
    case exploded   = "exploded"
    case outOfOrder = "out of order"
    
}

class ATM: Mappable{
    var id       : String?
    var location : Location?
    var addresss : String?
    var network  : String?
    var status   : ATMStatus?
    var hasMoney : Bool?
    var acceptsDeposits : Bool?
    
    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        location        <- map["location"]
        addresss        <- map["address"]
        network         <- map["network"]
        status          <- (map["status"], StatusTransform())
        hasMoney        <- map["has_money"]
        acceptsDeposits <- map["accepts_deposits"]
    }
}
class StatusTransform : TransformType {
    
    typealias Object = ATMStatus
    typealias JSON   = String

    func transformToJSON(_ value: ATMStatus?) -> String? {
        return value?.rawValue
    }
    
    func transformFromJSON(_ value: Any?) -> ATMStatus? {
        return ATMStatus(rawValue: value as! String)
    }
    
}

