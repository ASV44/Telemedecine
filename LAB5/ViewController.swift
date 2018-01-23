//
//  ViewController.swift
//  LAB5
//
//  Created by Hackintosh on 1/10/18.
//  Copyright © 2018 Hackintosh. All rights reserved.
//

import UIKit
import Alamofire
import JTMaterialSpinner

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var introduction: UITextView!
    @IBOutlet var fields: [UITextField]!
    
    var icons: [UIImage] = [UIImage(named: "loginIcon.png")!, UIImage(named: "passwordIcon.png")!]
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var preLoginBtn: UIButton!
    @IBOutlet weak var urgentBtn: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var telemedecineLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpAtLoginBtn: UIButton!
    
    var welcomeScreenElements: [UIView]!
    var signUpScreenElements: [UIView]!
    
    let loginURL: String = StaticUtil.baseURL + "/api/Login/UserAuth"
    
    var token:String!
    
    var spinnerView: JTMaterialSpinner!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeScreenElements = [welcomeLabel, introduction, signUpBtn, preLoginBtn, urgentBtn]
        
        signUpScreenElements = [telemedecineLabel, emailField, passwordField, loginBtn, signUpAtLoginBtn]
        
        confingFields()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        let spinnerViewSize =  CGSize(width: 100, height: 100)
        spinnerView = JTMaterialSpinner(frame: CGRect(x: (UIScreen.main.bounds.width - spinnerViewSize.width) / 2,
                                                      y: (UIScreen.main.bounds.height - spinnerViewSize.height) / 2,
                                                      width: spinnerViewSize.width,
                                                      height: spinnerViewSize.height))
        spinnerView.circleLayer.lineWidth = 4.0
        spinnerView.circleLayer.strokeColor = UIColor.white.cgColor
        spinnerView.animationDuration = 2.5
        self.view.addSubview(spinnerView)
        spinnerView.beginRefreshing()
        
        StaticUtil.checkCachedToken() { token in
            self.spinnerView.endRefreshing()
            if token != nil {
                self.dismiss(animated: false, completion: nil)
                self.token = token
                self.logIn()
            } else {
                self.showWelcomeScreenElements()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideElements(_ element: UIView) {
        element.isHidden = true
        if let button = element as? UIButton {
            button.isEnabled = false
        }
    }
    
    func showWelcomeScreenElements() {
        welcomeScreenElements.forEach { element in
            element.isHidden = false
            if let button = element as? UIButton {
                button.isEnabled = true
            }
        }
    }

    @IBAction func SignUpClick(_ sender: Any) {
    }
    
    
    @IBAction func preLogInCLick(_ sender: Any) {
        welcomeScreenElements.forEach { element in
            element.isHidden = true
            if let button = element as? UIButton {
                button.isEnabled = false
            }
        }
        
        signUpScreenElements.forEach { element in
            element.isHidden = false
            if let button = element as? UIButton {
                button.isEnabled = true
            }
        }
    }
    
    @IBAction func urgentClick(_ sender: Any) {
        print("Urgent Call")
    }
    
    @IBAction func logInClick(_ sender: Any) {
        Alamofire.request(loginURL, method: .post, parameters: getParameters()).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            print("Value: \(response.result.value!)")                         // response serialization result
            
            let JsonResponse = response.result.value as! [String : String]
            if JsonResponse["Status"] == "SUCCESS" {
                let token = JsonResponse["Message"]!
                StaticUtil.cacheToken(token)
                self.token = token
                print(self.token)
                self.logIn()
            }
        }
    }
    

    @IBAction func signUpAtLoginClick(_ sender: Any) {
    }
        
    func confingFields() {
        for field in fields {
            field.borderStyle = UITextBorderStyle.roundedRect
            field.layer.cornerRadius = 10
            field.layer.borderWidth = 2
            field.layer.borderColor = UIColor.white.cgColor
            field.backgroundColor = UIColor.clear
            field.leftViewMode = .always
            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: field.frame.height))
            let icon = UIImageView(image: icons[fields.index(of: field)!])
            icon.center = (field.leftView?.center)!
            field.leftView?.addSubview(icon)
        }
    }
    
    @IBAction func unwindToFirstScreen(sender: UIStoryboardSegue) {
        print("Unwind")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.logInClick(self)
        }
    }
        
    func getParameters() -> Parameters {
        return [
            "Email": emailField.text!,
            "Password": passwordField.text!
        ]
    }
    
    func logIn() {
        performSegue(withIdentifier: "logIn", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logIn" {
            let navigationController = segue.destination as! UINavigationController
            let homeVC = navigationController.topViewController as! HomeViewController
            
            homeVC.token = token
        }
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

