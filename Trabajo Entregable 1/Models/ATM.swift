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
enum ATMNetwork : String{
    case banred  = "Banred"
    case redBrou = "RedBROU"
}
class ATM: Mappable{
    var id       : String?
    var location : Location?
    var addresss : String?
    var network  : ATMNetwork?
    var status   : ATMStatus?
    var hasMoney : Bool?
    var acceptsDeposits : Bool?
    var imageUrl : String?
    var openHours:String?
    
    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        location        <- map["location"]
        addresss        <- map["address"]
        network         <- (map["network"], NetworkTransform())
        status          <- (map["status"], StatusTransform())
        hasMoney        <- map["has_money"]
        acceptsDeposits <- map["accepts_deposits"]
        imageUrl        <- map["image_url"]
        openHours       <- map["open_hours"]
    }
    
}
extension ATM{
    
    func getImageLogo() ->UIImage{
        guard let network = network else {return #imageLiteral(resourceName: "redBrouLogo")}
        switch network {
        case .banred:
            return #imageLiteral(resourceName: "BanredLogo")
        default:
            return #imageLiteral(resourceName: "redBrouLogo")
        }
    }
    
    func getDepositString() -> String {
        guard let acceptsDeposits = acceptsDeposits else {return "No one knows"}
        if(acceptsDeposits){
            return "Accepts Deposits"
        }else{
            return "No Deposits"
        }
    }
    
    func getMoneyString() -> String{
        guard let hasMoney = hasMoney else {return "No one knows"}
        if(hasMoney){
            return "Has Money"
        }else{
            return "No Money"
        }
    }
    
    func getStatusColor() -> UIColor{
        guard let status = status else {return UIColor.black}
        switch status{
            case .normal:
                return UIColor.green
            case .withTint:
                return UIColor.blue
            case .outOfOrder:
                return UIColor.gray
            case .exploded:
                return UIColor.red
        }
    }
    
    func getNetworkFirstLetter() -> String{
        guard let network = network else {return "⛔️"}
        switch network {
        case .banred:
            return "B"
        default:
            return "R"
        }
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

class NetworkTransform : TransformType {
    
    typealias Object = ATMNetwork
    typealias JSON   = String
    
    func transformToJSON(_ value: ATMNetwork?) -> String? {
        return value?.rawValue
    }
    
    func transformFromJSON(_ value: Any?) -> ATMNetwork? {
        return ATMNetwork(rawValue: value as! String)
    }
    
}
