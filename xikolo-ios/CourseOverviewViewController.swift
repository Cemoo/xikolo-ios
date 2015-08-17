//
//  CourseOverviewViewController.swift
//  xikolo-ios
//
//  Created by Arne Boockmeyer on 08/07/15.
//  Copyright © 2015 HPI. All rights reserved.
//

import UIKit

class CourseOverviewViewController: UICollectionViewController {
    
    private var courses : CourseList = DataManager.getAllCourses()
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    private let reuseIdentifier = "CourseCell"
    
    private var flowLayout : UICollectionViewFlowLayout?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.collectionView!.registerNib(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        self.navigationItem.hidesBackButton = true
        
        flowLayout = UICollectionViewFlowLayout()
        self.collectionView?.setCollectionViewLayout(flowLayout!, animated: false)
    }
    
}
extension CourseOverviewViewController {
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> CourseCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CourseCell
        
        cell.nameLabel.text = "Name"
        cell.teacherLabel.text = "Teacher"
        cell.dateLabel.text = "Date"
        
        cell.layer.cornerRadius = 3
        
        return cell
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.collectionView?.performBatchUpdates(nil, completion: nil)
    }
    
}
extension CourseOverviewViewController : UICollectionViewDelegateFlowLayout {
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