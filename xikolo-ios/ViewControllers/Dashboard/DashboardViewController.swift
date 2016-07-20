//
//  DashboardViewController.swift
//  xikolo-ios
//
//  Created by Bjarne Sievers on 04.05.16.
//  Copyright © 2016 HPI. All rights reserved.
//

import UIKit

class DashboardViewController : AbstractTabContentViewController {

    @IBOutlet weak var deadlineWebView: UIWebView!
    @IBOutlet weak var notificationWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadDeadlineWebView()
        loadNotificationWebView()
    }

    func loadDeadlineWebView() {
        let url = Routes.NEWS_URL  // TODO: change url to deadlines
        deadlineWebView.loadRequest(NetworkHelper.getRequestForURL(url))
    }

    func loadNotificationWebView() {
        let url = Routes.NEWS_URL  // TODO: change url to notifications
        notificationWebView.loadRequest(NetworkHelper.getRequestForURL(url))
    }

}

extension DashboardViewController : UIWebViewDelegate {

    func webViewDidStartLoad(webView: UIWebView) {
        NetworkIndicator.start()
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        NetworkIndicator.end()
    }

}
