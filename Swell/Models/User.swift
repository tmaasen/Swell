//
//  User.swift
//  Swell
//
//  Created by Tanner Maasen on 1/18/22.
//

import Foundation

struct User: Identifiable, Decodable {
    var id: Int
    var name: String
    var username: String
    var email: String
    var address: Address
    var phone: String
    var website: String

    struct Address: Decodable {
        var street: String
        var suite: String
        var city: String
        var zipcode: String
    }
}
