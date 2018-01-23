//
//  HomeViewController.swift
//  LAB5
//
//  Created by Hackintosh on 1/13/18.
//  Copyright © 2018 Hackintosh. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var fields: [UITextField]!
    
    @IBOutlet weak var tabBAr: UITabBar!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    let descriptionPlaceholder = "Describe Here"
    
    var token: String!
    
    let doctorListURL: String = StaticUtil.baseURL + "/api/Doctor/GetDoctorList"
    
    var doctorList: [[String : Any]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confingFields()
        configTextView()
        
        StaticUtil.token = token
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        TabBarHandler.shared.setTabBar(tabBAr)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func confingFields() {
        for field in fields {
            field.borderStyle = UITextBorderStyle.roundedRect
            field.layer.cornerRadius = 10
            field.layer.borderWidth = 2
            field.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    func configTextView() {
        descriptionTextView.delegate = self
        descriptionTextView.text = descriptionPlaceholder
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = descriptionPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func requestBtnClick(_ sender: Any) {
        getDoctorList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DoctorListScreen" {
            let doctorListVC = segue.destination as! DoctorListViewCOntroller
            doctorListVC.doctorList = doctorList
        }

    }
        
    func getDoctorList() {
            let headers: HTTPHeaders = [
                "Content-Type": "application/x-www-form-urlencoded",
                "token": StaticUtil.token
            ]
            
            Alamofire.request(doctorListURL, headers: headers).responseJSON { response in
                //print("Request: \(String(describing: response.request))")   // original url request
                //print("Result: \(response.result)")                         // response serialization result
                //print("Value: \(response.result.value!)")                         // response serialization result
                
                if let JsonResponse = response.result.value as? [[String : Any]]  {
                    self.doctorList = JsonResponse
                    self.performSegue(withIdentifier: "DoctorListScreen", sender: self)
                }
            }
        }
}
