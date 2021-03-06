//
//  Created for xikolo-ios under MIT license.
//  Copyright © HPI. All rights reserved.
//

import BrightFutures
import UIKit

class PDFWebViewController: UIViewController {

    @IBOutlet private weak var webView: UIWebView!
    @IBOutlet private var shareButton: UIBarButtonItem!

    var url: URL!
    private var tempPdfFile: TemporaryFile? = try? TemporaryFile(creatingTempDirectoryForFilename: "certificate.pdf")

    @IBAction func sharePDF(_ sender: UIBarButtonItem) {
        guard let fileURL = self.tempPdfFile?.fileURL else { return }
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = sender
        self.present(activityViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = nil

        guard let temporaryFile = self.tempPdfFile else {
            log.warning("temporary file location doesnt exist")
            return
        }

        self.loadPDF(to: temporaryFile)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        try? tempPdfFile?.deleteDirectory()
    }

    func loadPDF(to file: TemporaryFile) {
        var request = URLRequest(url: self.url)
        request.setValue(Routes.Header.acceptPDF, forHTTPHeaderField: Routes.Header.acceptKey)
        for (key, value) in NetworkHelper.requestHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            do {
                try data?.write(to: file.fileURL)
            } catch {
                log.error(error)
            }

            let request = URLRequest(url: file.fileURL)
            DispatchQueue.main.async {
                self.webView.loadRequest(request)
                self.navigationItem.rightBarButtonItem = self.shareButton
            }
        }

        task.resume()
    }

}
