//
//  KeychainPropertyWrapper.swift
//  Swell
//
//  Created by Tanner Maasen on 3/15/22.
//

import SwiftUI

// NOT YET IMPLEMENTED
@propertyWrapper
struct KeyChain: DynamicProperty {
    
    @State var data: Data?
    
    var wrappedValue: Data?{
        get{KeychainHelper.standard.read(key: key, account: account)}
        nonmutating set{
            guard let newData = newValue else {
                data = nil
                KeychainHelper.standard.delete(key: key, account: account)
                return
            }
            KeychainHelper.standard.save(data: newData, key: key, account: account)
            data = newValue
        }
    }
    
    var key: String
    var account: String
    
    init(key: String, account: String) {
        self.key = key
        self.account = account
        
        _data = State(wrappedValue: KeychainHelper.standard.read(key: key, account: account))
    }
}
