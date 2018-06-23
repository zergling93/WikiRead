//
//  RestApiInterface.swift
//  HelloSwift
//
//  Created by Gitesh on 13/02/17.
//  Copyright © 2017 Moxtra. All rights reserved.
//

import Foundation
import SystemConfiguration

class NetworkInterface: NSObject {
    
    static func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    
    // MARK: - Get Api
    static func callGetApi(urlString:String, header:Dictionary<String,String>? = ["Content-Type":"application/json"], success:@escaping (Dictionary<String, Any>?)->Void, failure:@escaping (String)->Void) -> Void {
        let session:URLSession=URLSession.init(configuration: URLSessionConfiguration.default)
        let url = URL.init(string: urlString)!
        var urlRequest = URLRequest.init(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 35.0)
        for  (key, value) in header! {
             urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        urlRequest.httpMethod="GET"
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil{
                do{
                    if let data = data{
                        let json:Dictionary<String, Any>? = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String, Any>
                        print("\n\n\nURL->"+urlString+"\n Response->\(String(describing: json))\n\n\n")
                        let httpResponse:HTTPURLResponse = response as! HTTPURLResponse
                        
                        switch httpResponse.statusCode{
                        case 200..<300:
                            success(json)
                        case 300..<500:  // client error
                            let errors:String? = json?["errors"] as? String
                            let error:String? = json?["error"] as? String
                            let message:String? = json?["message"] as? String
                            failure(errors ?? error ?? message ?? "Client error")
                        case 500..<600:  //server error
                            let errors:String? = json?["errors"] as? String
                            let error:String? = json?["error"] as? String
                            let message:String? = json?["message"] as? String
                            failure(errors ?? error ?? message ?? "Server error")
                        default: break
                        }
                    }
                }
                catch {
                    print("\n\n\nURL->"+urlString+"\n Response->\(String.init(data: data!, encoding: String.Encoding.ascii)!)\n\n\n")
                    failure(error.localizedDescription)
                }
            }
            else{
                print("\n\n\nURL->"+urlString+"\n")
                failure(error!.localizedDescription)
            }
        }
        task.resume()
    }
    
    
    
    
    // MARK: - Post Api
    static func callPostApi(urlString:String, requestBody:Dictionary<String, Any>, header:Dictionary<String,String>? = ["Content-Type":"application/json"] , success:@escaping (Dictionary<String, Any>?)->Void, failure:@escaping (String)->Void) -> Void{
        let session:URLSession=URLSession.init(configuration: URLSessionConfiguration.ephemeral)
        
        var urlRequest = URLRequest.init(url: URL.init(string: urlString)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 35.0)
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod="POST"
        
        for  (key, value) in header! {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        do{
            let data = try JSONSerialization.data(withJSONObject: requestBody, options: JSONSerialization.WritingOptions.prettyPrinted)
            urlRequest.httpBody = data
            session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if error==nil{
                    do{
                        let json:Dictionary<String, Any>? = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? Dictionary<String, Any>
                        print("\n\n\nURL->"+urlString+"\n Response->\(String(describing: json))\n\n\n")
                        let httpResponse:HTTPURLResponse = response as! HTTPURLResponse
                        
                        switch httpResponse.statusCode{
                        case 200..<300:
                            success(json)
                        case 300..<500:  // client error
                            let errors:String? = json?["errors"] as? String
                            let error:String? = json?["error"] as? String
                            let message:String? = json?["message"] as? String
                            failure(errors ?? error ?? message ?? "Client error")
                        case 500..<600:  //server error
                            let errors:String? = json?["errors"] as? String
                            let error:String? = json?["error"] as? String
                            let message:String? = json?["message"] as? String
                            failure(errors ?? error ?? message ?? "Server error")
                        default: break
                        }
                    } catch {
                        failure(error.localizedDescription)
                        print("\n\n\nURL->"+urlString+"\n Response->\(String.init(data: data!, encoding: String.Encoding.ascii)!) \n\n\n")
                    }
                }
                else{
                    failure(error!.localizedDescription)
                    print("\n\n\nURL->"+urlString+"\n")
                }
            }).resume()
        }
        catch {
            failure(error.localizedDescription)
        }
    }
}
