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
    
    enum UIUserInterfaceIdiom : Int {
        case Unspecified
        
        case Phone // iPhone and iPod touch style UI
        case Pad // iPad style UI
    }
    
    var speechUtterance:AVSpeechUtterance?
    
    var memeOn:Bool = false
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var video: UIWebView!
    
    @IBOutlet weak var shake: UILabel!
    
    @IBOutlet var eightball: UIView!
    var chosenAnswer = 0
    var chosenVideo = 0
    var chosenAnswer2 = 0
    
    var AnswerArray = ["Yes", "No", "Maybe.", "You should try again.", "Not now, not at this time", "Most likely.", "Highly unlikely."]
    
    var MemeAnswerArray = ["I think that was a yes.", "That was a no.", "Eh, I dunno maybe.", "You should try again, that wasn't a good answer.", "Not now, not at this time", "Most likely."]
    
    var MemeUrls = ["58mah_0Y8TU", "Ap4nvdEotqw", "-7jRWvdR5XQ", "wIr1fjjjFQQ", "DrYXGwMZrV4", "_rBe4bm1WFY", "4EoAHdwGBvU", "RFZrzg62Zj0", "umDr0mPuyQc", "YaG5SAw1n0c", "SiMHTK15Pik", "n4B6BFIR1Ow", "jlMQVcWI7HA", "LEUGPEVRDmU", "vacsdSf0RcE", "TGTYgRh-PI8", "M3QpVS8WZ_w", "YOn4vg0JIAo", "EDidqSOB4jQ", "RAkH-zRhK8I", "FxsaxigFxy8"]
    
    var didload: Bool!
    
    @IBOutlet weak var memeSwitch: UISwitch!
    
    @IBOutlet weak var answerButton: UIButton!
    
    @IBOutlet weak var magicTitle: UILabel!
    
    @IBOutlet weak var ipadVideo: UIWebView!
    
    @IBOutlet weak var trollFace: UIImageView!
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        self.view.bringSubviewToFront(shake);
        self.view.bringSubviewToFront(ipadVideo);
        super.viewDidLoad()
        self.video.alpha = 0
        self.ipadVideo.alpha = 0
        self.trollFace.alpha = 0
        video.mediaPlaybackRequiresUserAction = false
        video.allowsInlineMediaPlayback = true
        didload = false
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            break
            // It's an iPhone
        case .Pad:
            shake.font = shake.font.fontWithSize(25)
            break
            // It's an iPad
        case .Unspecified:
            break
            // Uh, oh! What could it be?
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        shakeLabel()
        animation()
        randomAnswer()
        if(memeOn) {
            if (Reachability.isConnectedToNetwork()) {
                UIView.animateWithDuration(1.0, animations:{
                    self.shake.alpha = 0
                })
                loadMeme()
                if(didload!) {
                    didload = false
                }
                switch UIDevice.currentDevice().userInterfaceIdiom {
                case .Phone:
                    UIView.animateWithDuration(1.0, animations:{
                        self.video.alpha = 1.0
                    })
                    break
                case .Pad:
                    UIView.animateWithDuration(1.0, animations:{
                        self.ipadVideo.alpha = 1.0
                    })
                    break
                case .Unspecified:
                    break
                default:
                    break
                }
            } else {
                speechUtterance = AVSpeechUtterance(string: "No Internet Connection Available")
                self.shake.text = "No Internet Connection"
                UIView.animateWithDuration(1.0, animations:{
                    self.shake.alpha = 1.0
                })
                speechUtterance!.rate = 0.4
                speechUtterance!.pitchMultiplier = 1.0
                speechUtterance!.volume = 0.75
                
                speechSynthesizer.speakUtterance(speechUtterance!)
            }
        } else {
            UIView.animateWithDuration(1.0, animations:{
                self.shake.alpha = 1.0
            })
            speak()
        }
    }

    
    func loadMeme() {
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            let embeddedHTML = "<html><head><style>body{margin:0px 0px 0px 0px;}</style></head> <body> <div id=\"player\"></div> <script> var tag = document.createElement('script'); tag.src = 'https://www.youtube.com/player_api'; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:'0', height:'0', videoId:'\(MemeUrls[chosenVideo])', events: { 'onReady': onPlayerReady } }); } function onPlayerReady(event) { event.target.playVideo(); } </script> </body> </html>"
            
            video.loadHTMLString(embeddedHTML, baseURL: NSBundle.mainBundle().bundleURL)
            break
            // It's an iPhone
        case .Pad:
            let embeddedHTML = "<html><head><style>body{margin:0px 0px 0px 0px;}</style></head> <body> <div id=\"player\"></div> <script> var tag = document.createElement('script'); tag.src = 'https://www.youtube.com/player_api'; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:'\(ipadVideo.frame.width)', height:'\(ipadVideo.frame.height)', videoId:'\(MemeUrls[chosenVideo])', events: { 'onReady': onPlayerReady } }); } function onPlayerReady(event) { event.target.playVideo(); } </script> </body> </html>"
            
            ipadVideo.loadHTMLString(embeddedHTML, baseURL: NSBundle.mainBundle().bundleURL)
            
            break
            // It's an iPad
        case .Unspecified:
            break
            // Uh, oh! What could it be?
        default:
            break
        }
    }
    
    func randomAnswer() {
        chosenAnswer = Int(arc4random_uniform(UInt32(AnswerArray.count)))
        chosenAnswer2 = Int(arc4random_uniform(UInt32(MemeAnswerArray.count)))
        chosenVideo = Int(arc4random_uniform(UInt32(MemeUrls.count)))
    }
    
    func animation() {
        self.video.alpha = 0
        self.shake.alpha = 0
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        didload = true
    }
    
    func shakeLabel() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.08
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(shake.center.x - 10, shake.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(shake.center.x + 10, shake.center.y))
        shake.layer.addAnimation(animation, forKey: "position")
        let animation2 = CABasicAnimation(keyPath: "position")
        animation2.duration = 0.08
        animation2.repeatCount = 5
        animation2.autoreverses = true
        animation2.fromValue = NSValue(CGPoint: CGPointMake(eightball.center.x - 10, eightball.center.y))
        animation2.toValue = NSValue(CGPoint: CGPointMake(eightball.center.x + 10, eightball.center.y))
        eightball.layer.addAnimation(animation, forKey: "position")
    }
    
    func speak() {
        if(memeOn) {
            speechUtterance = AVSpeechUtterance(string: MemeAnswerArray[chosenAnswer2])
            shake.text = MemeAnswerArray[chosenAnswer2]
        } else {
            speechUtterance = AVSpeechUtterance(string: AnswerArray[chosenAnswer])
            shake.text = AnswerArray[chosenAnswer]
        }
        speechUtterance!.rate = 0.4
        speechUtterance!.pitchMultiplier = 1.0
        speechUtterance!.volume = 0.75
        
        speechSynthesizer.speakUtterance(speechUtterance!)
    }
    
    @IBAction func buttonTouched(sender: AnyObject) {
        let title = "Invalid Answer"
        let noAnswerMessage = "Answer can't be empty"
        let charactersMessage = "Answer can only hold 25 characters"
        let okText = "OK"
        
        let noAnswerAlert = UIAlertController(title: title, message: noAnswerMessage, preferredStyle:  UIAlertControllerStyle.Alert)
        
        let characterAlert = UIAlertController(title: title, message: charactersMessage, preferredStyle:  UIAlertControllerStyle.Alert)
        
        let okayButton = UIAlertAction(title: okText, style:UIAlertActionStyle.Cancel, handler:nil)
        
        noAnswerAlert.addAction(okayButton)
        characterAlert.addAction(okayButton)
        
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Add an Answer",
            message: "Add your own answer!",
            preferredStyle: .Alert)
        
        alertController!.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                textField.placeholder = "Enter here"
        })
        
        let action = UIAlertAction(title: "Submit",
            style: UIAlertActionStyle.Default,
            handler: {[weak self]
                (paramAction:UIAlertAction!) in
                if let textFields = alertController?.textFields{
                    let theTextFields = textFields as [UITextField]
                    let enteredText = theTextFields[0].text
                    if(enteredText!.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet()
                        ) != "") {
                            if (enteredText?.characters.count <= 25) {
                                 self!.AnswerArray.append(enteredText!)
                            } else {
                                self!.presentViewController(characterAlert, animated: true, completion: nil)
                            }
                    } else {
                        self!.presentViewController(noAnswerAlert, animated: true, completion: nil)
                    }
                    
                }
            })
    

        
        alertController?.addAction(action)
        
        alertController?.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        
        self.presentViewController(alertController!,
            animated: true,
            completion: nil)
    }
    
    @IBAction func buttonClicked(sender: AnyObject)
    {
        if memeSwitch.on {
            magicTitle.text = "Magic Meme Ball"
            answerButton.alpha = 0
            ipadVideo.alpha = 0
            shake.alpha = 0
            trollFace.alpha = 1
            memeOn = true
            
        } else {
            magicTitle.text = "Magic 8 Ball"
            answerButton.alpha = 1
            ipadVideo.alpha = 0
            shake.alpha = 1
            trollFace.alpha = 0
            memeOn = false
            
        }
    }

    
}

