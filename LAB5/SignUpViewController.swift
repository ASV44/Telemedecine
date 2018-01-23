//
//  SignUpViewController.swift
//  LAB5
//
//  Created by Hackintosh on 1/11/18.
//  Copyright © 2018 Hackintosh. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {
    
    var image: UIImage!
    
    @IBOutlet var registerFields: [UITextField]!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var passwordFIeld: UITextField!
    
    let registerURL: String =  StaticUtil.baseURL + "/api/Register/UserReg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image = UIImage(named: "noPhoto.png")
        
        confingFields()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func confingFields() {
        for field in registerFields {
            field.borderStyle = UITextBorderStyle.roundedRect
            field.layer.cornerRadius = 10
            field.layer.borderWidth = 2
            field.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        print("back Button")
        performSegue(withIdentifier: "backToFirstScreen", sender: self)
    }
    
    @IBAction func nextBtnClick(_ sender: Any) {
        Alamofire.request(registerURL, method: .post, parameters: getParameters()).responseJSON { response in
            print("Result: \(response.result)")                         // response serialization result
            print("Value: \(response.result.value!)")                         // response serialization result
            let result = response.result.value as! String
            if result == "SUCCESS" {
                self.backBtnClick(self)
            }
        }
    }
    
    func getParameters() -> Parameters {
        let index = emailField.text!.index(of: "@")!
        let userName = emailField.text![..<index]
        let str64 = StaticUtil.encodeBase64(image: image)
        return [
            "FullName": nameField.text!,
            "Birthday": birthdayField.text!,
            "Email": emailField.text!,
            "Phone": phoneNumberField.text!,
            "Address": locationField.text!,
            "Username": userName,
            "Password": passwordFIeld.text!,
            "Base64Photo": str64
        ]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToFirstScreen" {
            let initialVC = segue.destination as! ViewController
            initialVC.emailField.text = emailField.text!
            initialVC.passwordField.text = passwordFIeld.text!
        }
    }

}
