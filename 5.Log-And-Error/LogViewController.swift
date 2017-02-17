//
//  LogViewController.swift
//  5.Log-And-Error
//
//  Created by spacetime on 2/14/17.
//  Copyright © 2017 spacetime. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {

    
    let sessionId = "073df4a9-e9ef-4f45-a2b0-e14c778bcd86"
    let apiKey = "91af9be9-7bac-40df-962d-f141eebe9d43"
    let apiSecret: String = "ce8df259-1f7a-4aa4-9e4e-862af9f6c24d"
    
    var cat:RTCat!
    var session:RTCatSession!
    var tokenId:String!
    var localStream:RTCatLocalStream!
    var localVideoPlayer:RTCatVideoPlayer!
    var remoteVideoPlayer:RTCatVideoPlayer!

    
    @IBOutlet weak var localVideoLayout: UIView!
    @IBOutlet weak var remoteVideoLayout: UIView!
    @IBOutlet weak var SenderLogs: UITextView!
    @IBOutlet weak var ReceiverLogs: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cat = RTCat.shareInstance()
        
        SenderLogs.isEditable = false;
        SenderLogs.isSelectable = false;
        ReceiverLogs.isEditable = false;
        ReceiverLogs.isSelectable = false;
        
        localStream = cat.createStream(withVideo: true, audio: true)
        
        localVideoPlayer = RTCatVideoPlayer.init(frame: CGRect.zero, type: RTCatVideoPlayerType.RTCAT_REMOTE_VIDEO_PLAYER)
        
        
        localVideoPlayer.delegate = self
        
        localVideoLayout.addSubview(localVideoPlayer.view)
        
        localStream.play(with: localVideoPlayer)
        
        getToken()
        // Do any additional setup after loading the view.
    }
    
    func getToken() {
        let url = "https://api.realtimecat.com/v0.3/sessions/\(sessionId)/tokens"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString = "session_id=\(sessionId)&type=\("pub")"
        request.httpBody = postString.data(using: .utf8)
        request.addValue(_:apiKey, forHTTPHeaderField: "X-RTCAT-APIKEY")
        request.addValue(_:apiSecret, forHTTPHeaderField: "X-RTCAT-SECRET")
        
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
    
    func showLogs(_ textView:UITextView,log logs:[AnyHashable : Any]!){
        var string = ""
        let video = logs["video"] as! [String:Any]
        let audio = logs["audio"] as! [String:Any]
        
        string = string + "Total: \n"

        for(key,value) in logs{
            string = self.createString(string, (key as! String), value)
        }
        
        string =  string + "Video: \n"
        
        for(key,value) in video{
            string = self.createString(string, key, value)
        }
        
        string =  string  + "Audio: \n"
        
        for(key,value) in audio{
            string = self.createString(string, key, value)
        }
        
        textView.text = string
    }
    
    
    func createString(_ string:String,_ key:String,_ value:Any) -> String{
        var rv:String
        
        if value is [String:Any]  {
            return string
        }
        
        rv = "\(string)\(key) : \(value) \n"
        
        return rv
    }

}


extension LogViewController: RTCatVideoPlayerDelegate{
    func didChangeVideoSize(_ videoPlayer: RTCatVideoPlayer!, size: CGSize) {
        print("change size to \(size)")
        var bounds:CGRect
        
        if(videoPlayer == localVideoPlayer){
            bounds = localVideoLayout.bounds
        }else{
            bounds = remoteVideoLayout.bounds
        }
        
        let A_W = bounds.size.width
        let A_H = bounds.size.height
        
        let B_W = size.width
        let B_H = size.height
        
        var W:CGFloat,H:CGFloat
        
        if(A_W/A_H < B_W/B_H){ //定宽
            W = A_W
            H = W * B_H/B_W
        }else{ //定高
            H = A_H
            W = H * B_W/B_H
        }
        
        bounds.size.width = W
        bounds.size.height = H
        
        videoPlayer.view.frame = bounds
        videoPlayer.view.center = CGPoint.init(x: bounds.midX, y: bounds.midY)
        
        print("change to bounds \(videoPlayer.view.bounds)")
        
        self.view.setNeedsLayout()
    }
}

extension LogViewController: RTCatSessionDelegate{
    
    
    func session(_ session: RTCatSession!, connected tokens: [Any]!) {
        print("connected")
        session.send(localStream, data: false, attr: nil)
    }
    
    func session(_ session: RTCatSession!, in token: String!) {
        print("\(token) is in")
        session.send(localStream, to: token, data:false, attr: nil)
    }
    
    func session(_ session: RTCatSession!, out token: String!) {
        DispatchQueue.main.async {
            self.remoteVideoPlayer.view.removeFromSuperview()
            self.remoteVideoPlayer = nil
        }
        
        print("\(token) is out")
        
    }
    
    func session(_ session: RTCatSession!, local sender: RTCatSender!) {
        sender.delegate = self
    }
    
    
    func session(_ session: RTCatSession!, remote receiver: RTCatReceiver!) {
        receiver.delegate = self
        receiver.response()
    }

}

extension LogViewController :RTCatSenderDelegate{
    func sender(_ sender: RTCatSender!, log: [AnyHashable : Any]!) {
        DispatchQueue.main.async {
            self.showLogs(self.SenderLogs, log: log)
        }
    }
}

extension LogViewController: RTCatReceiverDelegate{
    func receiver(_ receiver: RTCatReceiver!, stream: RTCatRemoteStream!) {
        DispatchQueue.main.async {
            self.remoteVideoPlayer = RTCatVideoPlayer.init(frame: CGRect.zero)
            self.remoteVideoPlayer.delegate = self
            self.remoteVideoLayout.addSubview(self.remoteVideoPlayer.view)
            stream.play(with: self.remoteVideoPlayer)
        }
    }
    
    func receiver(_ receiver: RTCatReceiver!, log: [AnyHashable : Any]!) {
       DispatchQueue.main.async {
           self.showLogs(self.ReceiverLogs, log: log)
       }
    }
}


