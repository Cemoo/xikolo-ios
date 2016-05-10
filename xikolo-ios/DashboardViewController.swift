//
//  DashboardViewController.swift
//  xikolo-ios
//
//  Created by Bjarne Sievers on 04.05.16.
//  Copyright © 2016 HPI. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var deadlinesWebView: UIWebView!
    //@IBOutlet weak var notificationsWebView: UIWebView!
    @IBOutlet weak var deadlinesActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var notificationsActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidAppear(animated: Bool) {
        self.tabBarController!.title = NSLocalizedString("tab_dashboard", comment: "Dashboard")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.deadlinesWebView.delegate = self
        let url = NSURL(string: Routes.NEWS) // TODO: change to Deadlines
        let request = NSMutableURLRequest(URL: url!)
        request.addValue(Routes.HEADER_USER_PLATFORM_VALUE, forHTTPHeaderField: Routes.HEADER_USER_PLATFORM)
        self.deadlinesWebView.loadRequest(request)
        loadDeadlinesWebView()
        //loadNotificationsWebView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDeadlinesWebView() {
        
    }
    
    func loadNotificationsWebView() {
        //self.notificationsWebView.delegate = self
        /*let url = NSURL(string: Routes.NEWS) // TODO: change to Notifications
        let request = NSMutableURLRequest(URL: url!)
        request.addValue(Routes.HEADER_USER_PLATFORM_VALUE, forHTTPHeaderField: Routes.HEADER_USER_PLATFORM)
        self.notificationsWebView.loadRequest(request)*/
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        switch webView.tag {
        case 10:
            deadlinesActivityIndicator.hidden = false
            deadlinesActivityIndicator.startAnimating()
        case 20:
            notificationsActivityIndicator.hidden = false
            notificationsActivityIndicator.startAnimating()
        default:
            break
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        switch webView.tag {
        case 10:
            deadlinesActivityIndicator.hidden = true
            deadlinesActivityIndicator.stopAnimating()
        case 20:
            notificationsActivityIndicator.hidden = true
            notificationsActivityIndicator.stopAnimating()
        default:
            break
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
