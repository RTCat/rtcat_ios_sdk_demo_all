//
//  ViewController.swift
//  1.Get-Local-Stream
//
//  Created by spacetime on 2/9/17.
//  Copyright © 2017 spacetime. All rights reserved.
//

import UIKit
class ViewController: UIViewController,RTCatVideoPlayerDelegate{
    var cat:RTCat!
    var localStream:RTCatLocalStream!
    var videoPlayer:RTCatVideoPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cat = RTCat.shareInstance()
        localStream = cat.createStream(withVideo: true, audio: true)
        videoPlayer = RTCatVideoPlayer.init(frame: UIScreen.main.bounds, type: RTCatVideoPlayerType.RTCAT_REMOTE_VIDEO_PLAYER)
        videoPlayer.delegate = self
        localStream.play(with: videoPlayer)
        self.view.addSubview(videoPlayer.view)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func didChangeVideoSize(_ videoPlayer: RTCatVideoPlayer!, size: CGSize) {
        var bounds = self.view.bounds
        let A_W = bounds.size.width
        let A_H = bounds.size.height
        
        let B_W = size.width
        let B_H = size.height
        
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
        
        videoPlayer.view.frame = bounds
        videoPlayer.view.center = CGPoint.init(x: bounds.midX, y: bounds.midY)
        
        self.view.setNeedsLayout()
    }


}

