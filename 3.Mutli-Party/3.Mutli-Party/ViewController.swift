//
//  ViewController.swift
//  3.Mutli-Party
//
//  Created by spacetime on 2/10/17.
//  Copyright © 2017 spacetime. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    let sessionId = "073df4a9-e9ef-4f45-a2b0-e14c778bcd86"
//    let apiKey = "91af9be9-7bac-40df-962d-f141eebe9d43"
//    let apiSecret = "ce8df259-1f7a-4aa4-9e4e-862af9f6c24d"
    
        let sessionId = "314e6da1-7282-44cd-92b2-41cc99e1d6ba"
        let apiKey = "8b8da770-d99c-4617-9f9a-79510505e175"
        let apiSecret = "262abb49-2ffc-46c6-bdc7-cb27579b21c5"
    
    var cat:RTCat!
    var session:RTCatSession!
    var tokenId:String!
    var localStream:RTCatLocalStream!
    var sides = Array<Side?>(repeating:nil, count:4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cat = RTCat.shareInstance()
        localStream = cat.createStream(withVideo: true, audio: true)
        
        getToken()
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
            self.playStream("11231", localStream)
            
        }
    }
    
    func playStream(_ token:String ,_ stream:RTCatAbstractStream){
        DispatchQueue.main.async {
            var ix = -1
            for (index, value) in self.sides.enumerated(){
                if(value == nil){
                    ix = index
                    break
                }
            }
            if(ix < 0){
                return
            }
            
            let size = UIScreen.main.bounds.size
            
            print("play stream in \(ix)")
            
            let width = size.width/2;
            let height = size.height/2;
            
            let rect = CGRect.init(x: (width*CGFloat(ix%2)), y: (height*CGFloat(ix/2)), width: width, height:height)
            
            print("size : \(rect)")
            
            
            let player = RTCatVideoPlayer.init(frame: rect, type: RTCatVideoPlayerType.RTCAT_REMOTE_VIDEO_PLAYER)
            player?.delegate = self
            self.sides[ix] = Side(token:token,videoPlayer:player!)
            stream.play(with: player)
            self.view.addSubview(player!.view)
        }
    }
    
}

extension ViewController: RTCatSessionDelegate{
    
    
    func session(_ session: RTCatSession!, connected tokens: [Any]!) {
        print("connected")
        session.send(localStream, data: false, attr: nil)
    }
    
    func session(_ session: RTCatSession!, in token: String!) {
        print("\(token) is in")
        session.send(localStream, to: token, data:false, attr: nil)
    }
    
    func session(_ session: RTCatSession!, out token: String!) {
        print("\(token) is out")
        for (index,value) in sides.enumerated(){
            if(((value?.token) != nil) && value?.token == token){
                DispatchQueue.main.async {
                    value?.videoPlayer.view.removeFromSuperview()
                }
                sides[index] = nil
                break
            }
        }
    }

    func session(_ session: RTCatSession!, local sender: RTCatSender!) {
        sender.delegate = self
    }
    
    
    func session(_ session: RTCatSession!, remote receiver: RTCatReceiver!) {
        receiver.delegate = self
        receiver.response()
    }

}

extension ViewController: RTCatSenderDelegate{
    func sender(_ sender: RTCatSender!, error: Error!) {
        //todo error
    }
}



extension ViewController :RTCatReceiverDelegate{
    func receiver(_ receiver: RTCatReceiver!, stream: RTCatRemoteStream!) {
        
        self.playStream(receiver.getSenderToken(), stream)
        
    }
}

extension ViewController: RTCatVideoPlayerDelegate{
    func didChangeVideoSize(_ videoPlayer: RTCatVideoPlayer!, size: CGSize) {
        
        print("change size to \(size)")
        
        var bounds = videoPlayer.bounds
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

struct Side {
    var token:String
    var videoPlayer:RTCatVideoPlayer
}

