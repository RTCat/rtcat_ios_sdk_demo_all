//
//  ViewController.swift
//  2.White-Board
//
//  Created by spacetime on 2/9/17.
//  Copyright © 2017 spacetime. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,WhiteBoardDelegate{
    
    @IBOutlet weak var whiteBoard: WhiteBoardView!
    
    var cat:RTCat!
    var session:RTCatSession!
    var tokenId:String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.whiteBoard.addDelegate(self)
        cat = RTCat.shareInstance()
        getToken()
        
    
    }
    
    func getToken() {
        let url = "https://api.realtimecat.com/v0.3/sessions/\(RTCatConfig.sessionId)/tokens"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString = "session_id=\(RTCatConfig.sessionId)&type=\("pub")"
        request.httpBody = postString.data(using: .utf8)
        request.addValue(_:RTCatConfig.apiKey, forHTTPHeaderField: "X-RTCAT-APIKEY")
        request.addValue(_:RTCatConfig.apiSecret, forHTTPHeaderField: "X-RTCAT-SECRET")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: responseHandler);
        task.resume()
    }
    
    
    func responseHandler(_ data:Data? ,_ response:URLResponse?, _ error:Error?){
        
        guard let data = data, error == nil else {                                                 // check for fundamental networking error
            print("error=\(error)")
            return
        }
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print("response = \(response)")
        }
        
        let responseString = String(data: data, encoding: .utf8)
        print("responseString = \(responseString)")
        
        let object: Any? = try? JSONSerialization.jsonObject(with: data, options: [])
        if (object is [AnyHashable: Any]) {
            var results: [AnyHashable: Any]? = object as! [AnyHashable : Any]?
            tokenId = (results?["uuid"] as? String)
            print("my token is \(tokenId)")
            session = cat.createSession(withToken: tokenId)
            session.add(_:self);
            session.connect()
        }
    }
    
    
    func messageHandler(_ type: String, x: Float, y: Float) {
        let dict = ["point": type, "x": x, "y": y, "pointNum": 0, "lineNum": 0] as [String : Any]
        do{
            let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let message = String.init(data: data, encoding: String.Encoding.utf8);
            print(message!);
            session.broadcastMessage(message)
        }catch{
            print(error.localizedDescription)
        }
    }

}

extension ViewController: RTCatSessionDelegate{
    
    func session(_ session: RTCatSession!, connected tokens: [Any]!) {
        print("session is connected")
    }
    
    func session(_ session: RTCatSession!, in token: String!) {
        print("\(token) is in")
    }
    
    func session(_ session: RTCatSession!, out token: String!) {
        print("\(token) is out")
    }
    
    
    func session(_ session: RTCatSession!, message: String!, from token: String!) {
        let data = message.data(using: String.Encoding.utf8)
        let object: Any? = try? JSONSerialization.jsonObject(with: data!, options: [])
        if (object is [AnyHashable: Any]) {
            var results = object as! [AnyHashable : Any]?
            let type = (results?["point"] as? String)
            let x = (results?["x"]) as? Float
            let y = (results?["y"]) as? Float
            self.whiteBoard.drawOtherHandle(type, x: x!, y: y!)
        }
    }

    
    
    
}


