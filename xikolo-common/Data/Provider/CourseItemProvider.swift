//
//  CourseItemProvider.swift
//  xikolo-ios
//
//  Created by Sebastian Brückner on 13.05.16.
//  Copyright © 2016 HPI. All rights reserved.
//

import BrightFutures
import Foundation
import Spine

class CourseItemProvider {

    class func getCourseItems(sectionId: String) -> Future<[CourseItemSpine], XikoloError> {
        let spine = Spine(baseURL: NSURL(string: Routes.API_V2_URL)!)
        spine.registerResource(CourseItemSpine)
        spine.registerResource(QuizSpine)
        spine.registerResource(RichTextSpine)
        spine.registerResource(VideoSpine)

        var query = Query(resourceType: CourseItemSpine.self)
        query.filterOn("section", equalTo: sectionId)

        return spine.find(query).map { tuple in
            tuple.resources.map { $0 as! CourseItemSpine }
        }.mapError { error in
            XikoloError.API(error)
        }
    }

}
