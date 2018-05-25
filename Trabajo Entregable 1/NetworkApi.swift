//
//  NetworkApi.swift
//  Trabajo Entregable 1
//
//  Created by SP20 on 24/5/18.
//  Copyright © 2018 SP20. All rights reserved.
//

import Foundation
import Alamofire

class NetworkApi{
    
    static func getAtms(callback : @escaping ([ATM]?) -> ()){
        Alamofire.request("https://ucu-atm.herokuapp.com/api/atm").responseArray { (response: DataResponse<[ATM]>) in
            let atmArray = response.result.value
            if let atmArray = atmArray {
                callback(atmArray)
            }
            else{
                callback(nil)
            }
        }
    }
    
    static func getAtmImage(callback : @escaping (UIImage?) -> (),imageUrl:String){
        Alamofire.request(imageUrl).responseImage { response in
            if let image = response.result.value {
                callback(image)
            }
        }
    }
}
