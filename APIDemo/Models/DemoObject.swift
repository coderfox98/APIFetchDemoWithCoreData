//
//  DemoObject.swift
//  DemoAPI
//
//  Created by Rishabh Raj on 06/04/20.
//  Copyright © 2020 Rishabh Raj. All rights reserved.
//

import Foundation
import CoreData


struct DemoObject :Identifiable, Codable {
    var id : Double?
    var name : String?
    var description : String?
    var open_issues_count : Double?
    var license : License?
    var permissions : Permissions?
    
}

struct License :Identifiable, Codable {
    let id = UUID()
    var key : String?
    
}

struct Permissions : Identifiable, Codable {
    let id = UUID()
    var admin : Bool?
}
