//
//  ViewController.swift
//  Trabajo Entregable 1
//
//  Created by SP20 on 17/5/18.
//  Copyright © 2018 SP20. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import AlamofireObjectMapper

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        requestATMData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? ATMMarker else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            let btn = UIButton(type: .custom)
            btn.setImage(UIImage(named : "redBrouLogo"), for: .normal)
            btn.sizeToFit()
            view.sizeToFit()
            view.rightCalloutAccessoryView = btn
            
        }
        return view
    }
    func requestATMData(){
        Alamofire.request("https://ucu-atm.herokuapp.com/api/atm").responseArray { (response: DataResponse<[ATM]>) in
            let atmArray = response.result.value
            if let atmArray = atmArray {
                for atm in atmArray {
                    self.addAnotation(atm: atm)
                }
            }
        }
    }
    func addAnotation(atm : ATM){
        guard let lat = atm.location?.latitude, let lon = atm.location?.longitde else { return }
        let atmMarker = ATMMarker(atm: atm, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        mapView.addAnnotation(atmMarker)
    }
}
