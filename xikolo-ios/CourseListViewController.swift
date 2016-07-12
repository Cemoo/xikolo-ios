//
//  CourseListViewController.swift
//  xikolo-ios
//
//  Created by Arne Boockmeyer on 08/07/15.
//  Copyright © 2015 HPI. All rights reserved.
//

import UIKit

class CourseListViewController: AbstractCourseListViewController {

    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

    private var flowLayout : UICollectionViewFlowLayout?

    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        
        flowLayout = UICollectionViewFlowLayout()
        self.collectionView?.setCollectionViewLayout(flowLayout!, animated: false)
        
        super.viewDidLoad()
    }

    internal func showMyCoursesOnly(showMyCourses: Bool) {
        self.courseDisplayMode = showMyCourses ? .EnrolledOnly : .All
    }

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.collectionView?.performBatchUpdates(nil, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier {
        case "ShowCourseDetailSegue"?:
            let vc = segue.destinationViewController as! CourseContentTableViewController
            let cell = sender as! CourseCell
            let indexPath = collectionView!.indexPathForCell(cell)
            let course = resultsController.objectAtIndexPath(indexPath!) as! Course
            vc.course = course
        default:
            break
        }
    }

}

extension CourseListViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let width = self.collectionView!.frame.size.width - 20
            
            return CGSize(width: width, height: width * 0.6)
    }

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }

}