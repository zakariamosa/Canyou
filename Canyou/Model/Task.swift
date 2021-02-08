//
//  Task.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-04.
//

import Foundation
import FirebaseFirestoreSwift

struct Task : Codable, Identifiable{
    @DocumentID var id : String?
    var taskname : String
    var taskdetails : String
    var done : Bool = false
}
