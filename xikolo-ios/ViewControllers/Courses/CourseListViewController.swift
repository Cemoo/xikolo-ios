//
//  Created for xikolo-ios under MIT license.
//  Copyright © HPI. All rights reserved.
//

import CoreData
import UIKit

class CourseListViewController: AbstractCourseListViewController {

    @available(iOS, obsoleted: 11.0)
    private var searchController: UISearchController?

    @available(iOS, obsoleted: 11.0)
    private var statusBarBackground: UIView?

    enum CourseDisplayMode {
        case enrolledOnly
        case all
        case explore
        case bothSectioned
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        self.collectionView?.register(R.nib.courseHeaderView(),
                                      forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                      withReuseIdentifier: R.nib.courseHeaderView.name)

        if let courseListLayout = self.collectionView?.collectionViewLayout as? CourseListLayout {
            courseListLayout.delegate = self
        }

        courseDisplayMode = .all

        super.viewDidLoad()

        // setup search controller
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        self.definesPresentationContext = true

        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
            self.collectionView?.preservesSuperviewLayoutMargins = true
        } else {
            searchController.searchBar.searchBarStyle = .minimal
            searchController.searchBar.isTranslucent = false
            searchController.searchBar.backgroundColor = .white
            searchController.searchBar.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            self.collectionView?.addSubview(searchController.searchBar)
            self.searchController = searchController
        }

        self.addPullToRefresh()
    }

    private func addPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView?.refreshControl = refreshControl
    }

    @objc func refresh() {
        let deadline = UIRefreshControl.minimumSpinningTime.fromNow
        let stopRefreshControl = {
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                self.collectionView?.refreshControl?.endRefreshing()
            }
        }

        CourseHelper.syncAllCourses().onComplete { _ in
            stopRefreshControl()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let course = self.resultsControllerDelegateImplementation.visibleObject(at: indexPath)
        AppNavigator.show(course: course)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if #available(iOS 11.0, *) {
            self.navigationItem.hidesSearchBarWhenScrolling = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let xikoloNavigationController = self.navigationController as? XikoloNavigationController {
            xikoloNavigationController.fixShadowImage()
        }

        if #available(iOS 11.0, *) {
            self.navigationItem.hidesSearchBarWhenScrolling = true
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.collectionView?.performBatchUpdates(nil)
    }

}

extension CourseListViewController: CourseListLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        heightForCellAtIndexPath indexPath: IndexPath,
                        withBoundingWidth boundingWidth: CGFloat) -> CGFloat {
        if self.resultsControllerDelegateImplementation.isSearching && !self.resultsControllerDelegateImplementation.hasSearchResults {
            return 0.0
        }

        let course = self.resultsControllerDelegateImplementation.visibleObject(at: indexPath)
        let imageHeight = boundingWidth / 2

        let boundingSize = CGSize(width: boundingWidth, height: CGFloat.infinity)
        let titleText = course.title ?? ""
        let titleAttributes = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .headline)]
        let titleSize = NSString(string: titleText).boundingRect(with: boundingSize,
                                                                 options: .usesLineFragmentOrigin,
                                                                 attributes: titleAttributes,
                                                                 context: nil)

        let teachersText = course.teachers ?? ""
        let teachersAttributes = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .subheadline)]
        let teachersSize = NSString(string: teachersText).boundingRect(with: boundingSize,
                                                                       options: .usesLineFragmentOrigin,
                                                                       attributes: teachersAttributes,
                                                                       context: nil)

        var height = imageHeight
        if !titleText.isEmpty || !teachersText.isEmpty {
            height += 6
        }

        if !titleText.isEmpty {
            height += titleSize.height
        }

        if !titleText.isEmpty && !teachersText.isEmpty {
            height += 4
        }

        if !teachersText.isEmpty {
            height += teachersSize.height
        }

        return height
    }

    func topInset() -> CGFloat {
        if #available(iOS 11.0, *) {
            return 0
        } else {
            return self.searchController?.searchBar.bounds.height ?? 0
        }
    }

}

extension CourseListViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let scrollOffset: CGPoint
        if #available(iOS 11.0, *) {
            scrollOffset = CGPoint(x: 0, y: (self.collectionView?.safeAreaInsets.top ?? 0) * -1.0)
        } else {
            scrollOffset = CGPoint(x: 0, y: self.topLayoutGuide.length * -1.0)
        }

        self.collectionView?.setContentOffset(scrollOffset, animated: true)

        guard let searchText = searchController.searchBar.text, !searchText.isEmpty, searchController.isActive else {
            self.resultsControllerDelegateImplementation.resetSearch()
            return
        }

        self.resultsControllerDelegateImplementation.search(withText: searchText)
    }

}

extension CourseListViewController: UISearchControllerDelegate {

    func willPresentSearchController(_ searchController: UISearchController) {
        self.collectionView?.refreshControl = nil

        if #available(iOS 11.0, *) {
            // nothing to do here
        } else {
            // on iOS 10 the search bar's backgorund will not overlap with the status bar, so we need the cover the status bar manually
            let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: UIApplication.shared.statusBarFrame.height)
            let statusBarBackground = UIView(frame: frame)
            statusBarBackground.backgroundColor = .white
            self.view.addSubview(statusBarBackground)
            statusBarBackground.autoresizingMask = [.flexibleWidth]
            self.statusBarBackground = statusBarBackground
        }
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        self.addPullToRefresh()

        if #available(iOS 11.0, *) {
            // nothing to do here
        } else {
            self.statusBarBackground?.removeFromSuperview()
        }
    }

}
