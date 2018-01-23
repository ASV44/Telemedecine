//
//  DoctorListViewController.swift
//  LAB5
//
//  Created by Hackintosh on 1/13/18.
//  Copyright © 2018 Hackintosh. All rights reserved.
//

import UIKit
import Alamofire

class DoctorListViewCOntroller: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    
    var doctorList: [[String : Any]]!
    
    var selectedCell: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        TabBarHandler.shared.setTabBar(tabBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorListCell", for: indexPath) as! DoctorListCell
        
        let index = indexPath.row
        
        let photoBase64 = doctorList[index]["Photo"] as! String
        let photo = StaticUtil.decodeImage(base64: photoBase64)
        cell.photo.image = photo
        cell.nameLabel.text = (doctorList[index]["FullName"] as! String)
        cell.domainLabel.text = (doctorList[index]["Specs"] as! String)
        cell.setAdsress(doctorList[index]["Address"] as! String)
        cell.setRating(doctorList[index]["Stars"] as! Double)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = indexPath.row
        performSegue(withIdentifier: "DoctorContactScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DoctorContactScreen" {
            let doctorContacVC = segue.destination as! DoctorContactViewController
            doctorContacVC.doctorContact = doctorList[selectedCell]
        }
    }

}
