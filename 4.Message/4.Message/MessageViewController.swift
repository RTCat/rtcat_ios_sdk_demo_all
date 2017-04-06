//
//  MessageViewController.swift
//  4.Message
//
//  Created by spacetime on 2/13/17.
//  Copyright © 2017 spacetime. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    var cat:RTCat!
    var session:RTCatSession!
    var tokenId:String!
    var senders:[RTCatSender] = []
    
    
    @IBOutlet weak var txtInput: UITextField!
    @IBOutlet weak var txtDisplay: UITextView!
    
    @IBAction func onSendClick(_ sender: UIButton) {
        if(senders.count > 0){
            guard let mes = txtInput.text else {
                return
            }
            txtDisplay.text = "self: \(mes)\n\(txtDisplay.text!)"
            txtInput.text = ""
            for sender in senders {
                sender.sendMessage(mes)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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


}



extension MessageViewController: RTCatSessionDelegate{
    
    
    
    func session(_ session: RTCatSession!, in token: String!) {
        print("\(token) is in")
        session.send(nil, to: token, data: true, attr: nil)
    }
    
    func session(_ session: RTCatSession!, connected tokens: [Any]!) {
        print("connected")
        session.send(nil, data: true, attr: nil)
    }
    
    func session(_ session: RTCatSession!, local sender: RTCatSender!) {
        senders.append(sender)
    }
    
    func session(_ session: RTCatSession!, remote receiver: RTCatReceiver!) {
        receiver.delegate = self
        receiver.response()
    }
    
}


extension MessageViewController:RTCatReceiverDelegate{
    func receiver(_ receiver: RTCatReceiver!, message: String!) {
        print("receiver message :\(message!) from :\(receiver.getSenderToken()!)")
        DispatchQueue.main.async {
            self.txtDisplay.text = "self: \(message!)\n\(self.txtDisplay.text!)"
        }
    }

}
