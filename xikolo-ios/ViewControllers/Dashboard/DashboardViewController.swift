//
//  DashboardViewController.swift
//  xikolo-ios
//
//  Created by Bjarne Sievers on 04.05.16.
//  Copyright © 2016 HPI. All rights reserved.
//

import UIKit

class DashboardViewController : AbstractTabContentViewController {

    @IBOutlet var courseDeadlinesContainerHeight: NSLayoutConstraint!
    @IBOutlet var courseStartsContainerHeight: NSLayoutConstraint!
    @IBOutlet var courseActivityContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var feedbackButton: UIButton!

    @IBAction func giveFeedback(sender: AnyObject) {
        let urlString = "https://beta.itunes.apple.com/v1/app/" + Brand.AppID
        if let url = NSURL(string: urlString) {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackButton.backgroundColor = Brand.TintColor
    }

    override func viewWillAppear(animated: Bool) {
        CourseDateHelper.syncCourseDates()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier {
        case "EmbedCourseDeadlinesSegue"?:
            let vc = segue.destinationViewController as! CourseDeadlinesTableViewController
            vc.delegate = self
        case "EmbedCourseStartsSegue"?:
            let vc = segue.destinationViewController as! CourseStartsTableViewController
            vc.delegate = self
        case "EmbedCourseActivitySegue"?:
            let vc = segue.destinationViewController as! CourseActivityViewController
            vc.delegate = self
        default:
            break
        }
    }

}

extension DashboardViewController : CourseDeadlinesTableViewControllerDelegate {

    func changedCourseDeadlinesTableViewHeight(height: CGFloat) {
        dispatch_async(dispatch_get_main_queue()) {
            self.courseDeadlinesContainerHeight.constant = height
        }
    }

}

extension DashboardViewController : CourseStartsTableViewControllerDelegate {

    func changedCourseStartsTableViewHeight(height: CGFloat) {
        dispatch_async(dispatch_get_main_queue()) {
            self.courseStartsContainerHeight.constant = height
        }
    }

}

extension DashboardViewController : CourseActivityViewControllerDelegate {

    func changedCourseActivityTableViewHeight(height: CGFloat) {
        dispatch_async(dispatch_get_main_queue()) {
            self.courseActivityContainerHeight.constant = height
        }
    }

}
