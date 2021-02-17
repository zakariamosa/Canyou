//
//  TaskOffer.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-16.
//

import Foundation
import FirebaseFirestoreSwift

struct TaskOffer : Codable, Identifiable, Equatable{
    @DocumentID var id : String?
    var taskid : String
    var taskofferdetails : String
    var taskofferaccepted : Bool = false
    var taskofferowneruid : String = ""
}
