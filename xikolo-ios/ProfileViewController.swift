//
//  ProfileViewController.swift
//  xikolo-ios
//
//  Created by Jonas Müller on 08.07.15.
//  Copyright © 2015 HPI. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coursesLabel: UILabel!
    @IBOutlet weak var coursesCountLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBAction func logoutAction(sender: AnyObject) {
        UserProfileHelper.logout()
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginCheckController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews();
        setViewData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
        self.profileImage.clipsToBounds = true;
        self.profileImage.layer.borderWidth = 3.0;
        self.profileImage.layer.borderColor = UIColor.whiteColor().CGColor;
        
        

    }
    
    func setViewData() {
        self.logoutButton.setTitle(NSLocalizedString("logout", comment: "Logout"), forState: UIControlState.Normal)
        
        let userProfileObservable = ProfileDataProvider.getObservable()
        userProfileObservable.subscribeNext { userProfile in
            self.nameLabel.text = userProfile.firstName + " " + userProfile.lastName
            self.emailLabel.text = userProfile.email
            
            ImageProvider.loadImage(userProfile.visual, imageView: self.profileImage)
        }
        
        let enrolledCoursesObservable = CourseDataProvider.getMyCourses();
        enrolledCoursesObservable.subscribeNext { courseList in
            self.coursesCountLabel.text = String(courseList.courseList.count)
        }
    }
}
