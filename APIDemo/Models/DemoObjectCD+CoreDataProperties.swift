//
//  DemoObjectCD+CoreDataProperties.swift
//  APIDemo
//
//  Created by Rishabh Raj on 07/04/20.
//  Copyright © 2020 Rishabh Raj. All rights reserved.
//
//

import Foundation
import CoreData


extension DemoObjectCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DemoObjectCD> {
        return NSFetchRequest<DemoObjectCD>(entityName: "DemoObjectCD")
    }

    @NSManaged public var description_a: String?
    @NSManaged public var id: Double
    @NSManaged public var name: String?
    @NSManaged public var open_issues_count: Double
    @NSManaged public var license_key: String
    @NSManaged public var permissions_admin: Bool

}
