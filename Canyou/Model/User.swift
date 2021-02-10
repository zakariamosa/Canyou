//
//  User.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-10.
//

import Foundation
import FirebaseFirestoreSwift

struct User : Codable, Identifiable, Equatable{
    @DocumentID var id : String?
    var firstname : String
    var lastname : String
    var userid : String = ""
}
