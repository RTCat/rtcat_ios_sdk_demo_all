//
//  VideoPlayerLayoutViewController.swift
//  6.Video-Player-Layout
//
//  Created by spacetime on 3/17/17.
//  Copyright © 2017 spacetime. All rights reserved.
//

import UIKit

class VideoPlayerLayoutViewController: UIViewController {

    
    var cat:RTCat!
    var session:RTCatSession!
    var tokenId:String!
    var localStream:RTCatLocalStream!
    var sides = Array<Side?>(repeating:nil, count:4)
    
    var realHeight:CGFloat!;
    var realWidth:CGFloat!;
    var isInitVideoPlaySize:Bool!;
    var localVideoPlayer:RTCatVideoPlayer!;
    var localVideoContainer:UIView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cat = RTCat.shareInstance()
        localStream = cat.createStream(withVideo: true, audio: true)
        isInitVideoPlaySize = false;
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
    
    override func viewDidDisappear(_ animated: Bool) {
        if((session) != nil){
            session.disconnect();
            session = nil;
        }
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
            self.playStream("self", localStream)
            
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
            
            
            if(token == "self"){
                var rect = CGRect.init(x: 0, y: 0, width: 150, height: 150);
                rect.origin.y = rect.origin.y + 100;
                self.localVideoContainer = UIView.init(frame: rect);
                self.localVideoContainer.clipsToBounds = true;
                self.localVideoContainer.backgroundColor = UIColor.blue;
                self.view.addSubview(self.localVideoContainer);
                self.localVideoPlayer = RTCatVideoPlayer.init(frame: CGRect.zero, type: RTCatVideoPlayerType.RTCAT_REMOTE_VIDEO_PLAYER);
                self.localVideoContainer.addSubview(self.localVideoPlayer.view);
                self.localVideoPlayer.delegate = self;
                self.sides[ix] = Side(token:token,videoPlayer:self.localVideoPlayer);
                stream.play(with: self.localVideoPlayer);
                
            }else{
                print("play stream in \(ix)")
                let width = size.width/2;
                let height = size.height/2;
                
                var rect = CGRect.init(x: (width*CGFloat(ix%2)), y: (height*CGFloat(ix/2)), width: width, height:height)
                rect.origin.y = rect.origin.y + 100;
                
                print("size : \(rect)")
            
                let player = RTCatVideoPlayer.init(frame: rect, type: RTCatVideoPlayerType.RTCAT_REMOTE_VIDEO_PLAYER)
                player?.delegate = self
                self.sides[ix] = Side(token:token,videoPlayer:player!)
                stream.play(with: player)
                self.view.addSubview(player!.view)
            }
        }
    }
    
    func changeLocalPlayerVideoSize(_ width:CGFloat!,_ height:CGFloat!){
        var bounds = self.localVideoContainer.bounds;
        
        let A_W = bounds.size.width
        let A_H = bounds.size.height
        
        let B_W = width!
        let B_H = height!
        
        var W:CGFloat,H:CGFloat
        
        if(A_W/A_H > B_W/B_H){ //定宽
            W = A_W
            H = W * B_H/B_W
        }else{ //定高
            H = A_H
            W = H * B_W/B_H
        }
        
        bounds.size.width = W
        bounds.size.height = H
        
        self.localVideoPlayer.view.frame = bounds
//        self.localVideoPlayer.view.center = CGPoint.init(x:self.localVideoContainer.bounds.midX, y: self.localVideoContainer.bounds.midY)
    
        print("change to bounds \(localVideoPlayer.view.bounds)")
        print("video container \( self.localVideoContainer.center)" )
        print("video player \(self.localVideoPlayer.view.center)")
        
        self.view.setNeedsLayout()
    }

    
}


extension VideoPlayerLayoutViewController: RTCatSessionDelegate{
    
    
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

extension VideoPlayerLayoutViewController: RTCatSenderDelegate{
    func sender(_ sender: RTCatSender!, error: Error!) {
        //todo error
    }
}



extension VideoPlayerLayoutViewController :RTCatReceiverDelegate{
    func receiver(_ receiver: RTCatReceiver!, stream: RTCatRemoteStream!) {
        self.playStream(receiver.getSenderToken(), stream)
    }
}

extension VideoPlayerLayoutViewController: RTCatVideoPlayerDelegate{
    func didChangeVideoSize(_ videoPlayer: RTCatVideoPlayer!, size: CGSize) {
        
        if(videoPlayer == self.localVideoPlayer){
            print("did change localstream size \(size))");
            if(!isInitVideoPlaySize){
                isInitVideoPlaySize = true;
                realWidth = size.width;
                realHeight = size.height;
                
                self.localStream.adaptFormat(toWidth: 400, height: 400, fps: 15);
                self.changeLocalPlayerVideoSize(realWidth,realHeight)
            }
        }else{
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
}

struct Side {
    var token:String
    var videoPlayer:RTCatVideoPlayer
}

