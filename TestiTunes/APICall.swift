//
//  APICall.swift
//  Farm2Home
//
//  Created by Vani on 5/8/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
let SERVERURL = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json"
//https://rss.itunes.apple.com/en-us
enum Methods: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}
class APICall: NSObject {
    static let instance = APICall()
    public var successAPI: ((APIResult?) -> ())?
    public var failureAPI: ((APIResult?) -> ())?
    
    func performAPIcallWith(urlStr: String,
                            methodName method: Methods,
                            json: [AnyHashable: Any]?)
    {
        DispatchQueue.main.async {
            print("loading......")
        }
        var urlString = ""
        let  methodHTTP = method.rawValue
        urlString = SERVERURL + urlStr
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = methodHTTP
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let json = json {
            let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            request.httpBody = data
        }
        
        //Create Session.
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config)
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                print("remove loading ...")
            }
            // check error and data.
            guard error == nil && data != nil else {
                print("error loading .... sent error")
                if let action = self.failureAPI
                {
                    let result = APIResult()
                    result.data = data
                    result.response = response
                    result.error = error
                    action(result)
                }
                return
            }
            // check for response.
            let res = response as? HTTPURLResponse
            if res?.statusCode == 201 || res?.statusCode == 200{
                //success(data, response)
                print("success .... sent success")
                if let action = self.successAPI
                {
                    let result = APIResult()
                    result.data = data
                    result.response = response
                    result.error = error
                    action(result)
                }
            }else{
                //  failure(data, response, error)
                print("error loading .... sent error")
                if let action = self.failureAPI
                {
                    let result = APIResult()
                    result.data = data
                    result.response = response
                    result.error = error
                    action(result)
                }
            }
        }
        // Perform API Call.
        task.resume()
    }
}

class APIResult: NSObject
{
    var data: Data?
    var response: URLResponse?
    var error: Error?
}
