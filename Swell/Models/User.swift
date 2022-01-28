//
//  User.swift
//  Swell
//
//  Created by Tanner Maasen on 1/18/22.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var fname: String = ""
    var lname: String = ""
}
