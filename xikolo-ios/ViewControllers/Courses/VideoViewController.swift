//
//  VideoViewController.swift
//  xikolo-ios
//
//  Created by Bjarne Sievers on 23.05.16.
//  Copyright © 2016 HPI. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoViewController: UIViewController {

    @IBOutlet weak var containerVideoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var openSlidesButton: UIButton!
    @IBOutlet weak var previousItemButton: UIButton!
    @IBOutlet weak var nextItemButton: UIButton!
    @IBOutlet weak var containerHeighConstraint: NSLayoutConstraint!
    
    var courseItem: CourseItem!
    var video: Video?

    override func viewDidLoad() {
        super.viewDidLoad()
        containerHeighConstraint.constant = self.view.frame.size.width * (9/16)
        titleLabel.text = courseItem.title
        let videoIncomplete = courseItem.content as! Video
        VideoHelper.syncVideo(videoIncomplete).onSuccess { videoComplete in
            self.video = videoComplete
            self.performSegueWithIdentifier("EmbedAVPlayer", sender: self.video)
        }
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as!
        AVPlayerViewController
        let myVideo = sender as! Video
        if let urlString = myVideo.single_stream_hls_url {
            let url = NSURL(string: urlString)
            destination.player = AVPlayer(URL: url!)
        }
    }

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        switch identifier {
        case "EmbedAVPlayer":
            if video != nil {
                return true
            } else {
                return false
            }
        default:
            return true
        }
    }

}
