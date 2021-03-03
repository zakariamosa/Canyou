//
//  Task.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-04.
//

import Foundation
import FirebaseFirestoreSwift

struct Task : Codable, Identifiable, Equatable{
    @DocumentID var id : String?
    var taskname : String
    var taskdetails : String
    var done : Bool = false
    var taskowneruid : String = ""
    var taskPlace : Place
    var taskzoneinmiles : Double = 10.0 //search tasks close with taskzone im miles
}
