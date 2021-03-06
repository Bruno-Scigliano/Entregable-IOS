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

class ViewController: UIViewController{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        requestATMData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ATMViewController, let annotationView = sender as? MKAnnotationView {
            let annotation = annotationView.annotation as? ATMMarker
            destination.atm = annotation?.atm
        }
    }
    func requestATMData(){
        Alamofire.request("https://ucu-atm.herokuapp.com/api/atm").responseArray { (response: DataResponse<[ATM]>) in
            let atmArray = response.result.value
            if let atmArray = atmArray {
                for atm in atmArray {
                    self.addAnotation(atm: atm)
                }
            }
            //self.activityIndicator.stopAnimating()
        }
    }
    func addAnotation(atm : ATM){
        guard let lat = atm.location?.latitude, let lon = atm.location?.longitde else { return }
        let atmMarker = ATMMarker(atm: atm, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        mapView.addAnnotation(atmMarker)
    }
}
extension ViewController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ATMMarker else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            let btn = UIButton(type: .custom)
            let networkImage = annotation.atm.getImage()
            btn.setImage(networkImage, for: .normal)
            btn.sizeToFit()
            view.rightCalloutAccessoryView = btn
        }
        return view
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "atmDetails", sender: view)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        activityIndicator.stopAnimating()
    }
    
}
