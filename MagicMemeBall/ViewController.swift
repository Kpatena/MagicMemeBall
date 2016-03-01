//
//  ViewController.swift
//  MagicMemeBall
//
//  Created by IOS_DEV_358922 on 2016-02-19.
//  Copyright © 2016 kpatena. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIWebViewDelegate {
    
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var video: UIWebView!
    
    @IBOutlet weak var shake: UILabel!
    
    @IBOutlet var eightball: UIView!
    var chosenAnswer = 0
    
    var AnswerArray = ["I think that was a yes.", "That was a no.", "Eh, I dunno maybe.", "You should try again, that wasn't a good answer.", "Not now, not at this time", "Hmmmmmm, most likely."]
    
    var MemeUrls = ["58mah_0Y8TU", "Ap4nvdEotqw", "-7jRWvdR5XQ", "wIr1fjjjFQQ", "DrYXGwMZrV4", "_rBe4bm1WFY", "4EoAHdwGBvU", "RFZrzg62Zj0", "umDr0mPuyQc"]
    
    var didload: Bool!
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        //self.view.bringSubviewToFront(shake);
        super.viewDidLoad()
        self.video.alpha = 0
        // Do any additional setup after loading the view, typically from a nib.
        video.mediaPlaybackRequiresUserAction = false
        video.allowsInlineMediaPlayback = true
        didload = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        shakeLabel()
        animation()
        randomAnswer()
        //loadMeme()
        //if(didload!) {
            //showAnswer()
            //didload = false
        
        //}
        speak()
    }

    
    func loadMeme() {
        let embededHTML = "<html><head><style>body{margin:0px 0px 0px 0px;}</style></head> <body> <div id=\"player\"></div> <script> var tag = document.createElement('script'); tag.src = 'https://www.youtube.com/player_api'; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:'0', height:'0', videoId:'\(MemeUrls[chosenAnswer])', events: { 'onReady': onPlayerReady } }); } function onPlayerReady(event) { event.target.playVideo(); } </script> </body> </html>"
        
        video.loadHTMLString(embededHTML, baseURL: NSBundle.mainBundle().bundleURL)
        //self.video.loadRequest(NSURLRequest(URL: NSURL(string: MemeUrls[chosenAnswer])!))
    }
    
    func randomAnswer() {
        chosenAnswer = Int(arc4random_uniform(UInt32(MemeUrls.count)))
    }
    
    func animation() {
        self.video.alpha = 0
    }
    
    func showAnswer() {
        UIView.animateWithDuration(1.0, animations:{
            self.video.alpha = 1.0
        })
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        didload = true
    }
    
    func shakeLabel() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 6
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(shake.center.x - 10, shake.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(shake.center.x + 10, shake.center.y))
        shake.layer.addAnimation(animation, forKey: "position")
        let animation2 = CABasicAnimation(keyPath: "position")
        animation2.duration = 0.07
        animation2.repeatCount = 6
        animation2.autoreverses = true
        animation2.fromValue = NSValue(CGPoint: CGPointMake(eightball.center.x - 10, eightball.center.y))
        animation2.toValue = NSValue(CGPoint: CGPointMake(eightball.center.x + 10, eightball.center.y))
        eightball.layer.addAnimation(animation, forKey: "position")
    }
    
    func speak() {
        let speechUtterance = AVSpeechUtterance(string: AnswerArray[chosenAnswer])
        
        speechUtterance.rate = 0.25
        speechUtterance.pitchMultiplier = 0.25
        speechUtterance.volume = 0.75
        
        speechSynthesizer.speakUtterance(speechUtterance)
    }
    
}

