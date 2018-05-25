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

class MapViewController: UIViewController{

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
        if let destination  = segue.destination as? ATMViewController, let annotationView = sender as? MKAnnotationView {
            let annotation  = annotationView.annotation as? ATMMarker
            destination.atm = annotation?.atm
        }
    }
    
    func requestATMData(){
        NetworkApi.getAtms(callback: addAnnotations)
    }
    
    func addAnotation(atm : ATM){
        guard let lat = atm.location?.latitude, let lon = atm.location?.longitde else { return }
        let atmMarker = ATMMarker(atm: atm, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        mapView.addAnnotation(atmMarker)
    }
    
    func addAnnotations(_ atms :[ATM]?){
        if let atms = atms{
            for atm in atms{
                addAnotation(atm: atm)
            }
            activityIndicator.stopAnimating()
        }else{
            let uiAlert = UIAlertController(title: "Error", message: "Failed to get data", preferredStyle: UIAlertControllerStyle.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                self.requestATMData()
            }))
            
            uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                uiAlert.dismiss(animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
            }))
        }
    }
}
extension MapViewController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ATMMarker else { return nil }
        let identifier       = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view                    = dequeuedView
        } else {
            view                = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset  = CGPoint(x: -5, y: 5)
            let btn             = UIButton(type: .custom)
            let networkImage    = annotation.atm.getImage()
            btn.setImage(networkImage, for: .normal)
            btn.sizeToFit()
            view.rightCalloutAccessoryView = btn
            view.markerTintColor = annotation.atm.getStatusColor()
            view.glyphText       = annotation.atm.getNetworkFirstLetter()
        
        }
        return view
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "atmDetails", sender: view)
    }
    
}
