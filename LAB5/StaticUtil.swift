//
//  StaticUtil.swift
//  LAB5
//
//  Created by Hackintosh on 1/16/18.
//  Copyright © 2018 Hackintosh. All rights reserved.
//

import UIKit
import Alamofire

class StaticUtil {
    
    static let baseURL: String = "http://81.180.72.17"
    static var token: String!
    private static let tokenCacheFileName = "token.json"
    static let userProfileURL: String = baseURL + "/api/Profile/GetProfile"
    static let doctorListURL: String = baseURL + "/api/Doctor/GetDoctorList"
    enum AttributedStringIcons: String {
        case locationIcon, starIcon
    }
    
    static func encodeBase64(image: UIImage) -> String {
        let imageData:Data = UIImagePNGRepresentation(image)!
        let strBase64 = imageData.base64EncodedString(options: .lineLength76Characters)
        return strBase64.components(separatedBy: .whitespacesAndNewlines).joined()
    }
    
    static func decodeImage(base64 strBase64: String) -> UIImage {
        let dataDecoded : Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
        return UIImage(data: dataDecoded)!
    }
    
    static func getFileUrl(_ name: String,
                           in directory: FileManager.SearchPathDirectory,
                           with domainMask: FileManager.SearchPathDomainMask) -> URL {
        
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(directory, domainMask, true).first!
        let documentsDirectoryPath = URL(fileURLWithPath: documentsDirectoryPathString)
        let filePath = documentsDirectoryPath.appendingPathComponent(name)
        
        return filePath
    }
    
    static func cacheToken(_ token: String) {
        let fileUrl = getFileUrl(tokenCacheFileName, in: .documentDirectory, with: .userDomainMask)
        print("File to save path: ",fileUrl)
        
        let tokenData = ["token": token]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: tokenData, options: .prettyPrinted)
            try data.write(to: fileUrl, options: [])
        }
        catch {
            print(error)
        }
    }
    
    static func unCacheToken() -> String! {
        let fileUrl = getFileUrl(tokenCacheFileName, in: .documentDirectory, with: .userDomainMask)
        
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            do {
                let data = try Data(contentsOf: fileUrl, options: .alwaysMapped)
                let tokenData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : String]
                self.token = tokenData["token"]!
                return tokenData["token"]!
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    static func checkCachedToken(completion: @escaping (String!)->Void) {
        if let token = unCacheToken() {
            let headers: HTTPHeaders = [
                "Content-Type": "application/x-www-form-urlencoded",
                "token": token
            ]

            Alamofire.request(doctorListURL, headers: headers).responseJSON { response in
                //print("Result: \(response.result)")                         // response serialization result
                //print("Value: \(response.result.value!)")                         // response serialization result
                var verifiedToken: String! = nil
                if let _ = response.result.value as? [[String : Any]]  {
                    verifiedToken = token
                }
                completion(verifiedToken)
            }
        }
        else {
            completion(nil)
        }
    }
    
    static func getAtributedString(string: String, icon: AttributedStringIcons) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: icon.rawValue + ".png")
        let attachmentString = NSAttributedString(attachment: attachment)
        let textWithIcon = NSMutableAttributedString(attributedString: attachmentString)
        let text = NSAttributedString(string: " " + string)
        textWithIcon.append(text)
        
        return textWithIcon
    }
}
