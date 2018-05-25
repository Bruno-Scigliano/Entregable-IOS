//
//  ATMViewController.swift
//  Trabajo Entregable 1
//
//  Created by SP20 on 23/5/18.
//  Copyright © 2018 SP20. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class ATMViewController: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var hasMoneyLabel: UILabel!
    @IBOutlet weak var hasDepositLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var networkImage: UIImageView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var gradientView: UIView!
    var atm : ATM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsView.layer.cornerRadius = 8.0
        closeButton.layer.cornerRadius = 14
        addressLabel.text    = atm.addresss
        timeLabel.text       = atm.openHours
        hasMoneyLabel.text   = atm.getMoneyString()
        hasDepositLabel.text = atm.getDepositString()
        networkImage.image   = atm.getImage()
        requestImage()
    }
    
    func displayDetails(image: UIImage?){
        if let image = image{
            backgroundImage.image      = image
            let gradientLayer          = CAGradientLayer()
            gradientLayer.frame        = backgroundImage.frame
            let colors                 = [UIColor.clear.cgColor, UIColor.white.cgColor]
            gradientLayer.locations    = [0,0.999]
            gradientLayer.colors       = colors
            backgroundImage.layer.addSublayer(gradientLayer)
        }else{
            let uiAlert = UIAlertController(title: "Error", message: "Failed to image", preferredStyle: UIAlertControllerStyle.alert)
            self.present(uiAlert, animated: true, completion: nil)
            uiAlert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                self.requestImage()
            }))
            uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                uiAlert.dismiss(animated: true, completion: nil)
            }))
        }
        activityIndicator.stopAnimating()
    }
    
    func requestImage(){
        NetworkApi.getAtmImage(callback : displayDetails, imageUrl: atm.imageUrl!)
    }
    @IBAction func closeViewControler(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
