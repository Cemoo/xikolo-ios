//
//  ProfileTableViewController.swift
//  xikolo-ios
//
//  Created by Bjarne Sievers on 05.05.16.
//  Copyright © 2016 HPI. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    var user: UserProfile?

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.item {
        case 0:
            if let url = NSURL(string: Brand.IMPRINT_URL) {
                UIApplication.sharedApplication().openURL(url)
            }
        case 1:
            if let url = NSURL(string: Brand.PRIVACY_URL) {
                UIApplication.sharedApplication().openURL(url)
            }
        default:
            break
        }
    }

}
