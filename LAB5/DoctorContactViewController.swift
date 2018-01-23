//
//  DoctorContactViewController.swift
//  LAB5
//
//  Created by Hackintosh on 1/16/18.
//  Copyright © 2018 Hackintosh. All rights reserved.
//

import UIKit
import MapKit

class DoctorContactViewController: UIViewController {
    
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var map: MKMapView!
    
    var doctorContact: [String : Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillViewCOntroller()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        TabBarHandler.shared.setTabBar(tabBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillViewCOntroller() {
        nameLabel.text = doctorContact["FullName"] as? String
        domainLabel.text = doctorContact["Specs"] as? String
        let ratingValue = doctorContact["Stars"] as? Double
        ratingLabel.attributedText = StaticUtil.getAtributedString(string: (ratingValue?.description)!,
                                                                   icon: .starIcon)
        let address = doctorContact["Address"] as? String
        locationLabel.attributedText = StaticUtil.getAtributedString(string: address!,
                                                                     icon: .locationIcon)
        let strBase64 = doctorContact["Photo"] as? String
        photo.image = StaticUtil.decodeImage(base64: strBase64!)
        descriptionTextView.text = doctorContact["About"] as? String
    }
}
