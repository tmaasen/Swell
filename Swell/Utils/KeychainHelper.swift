//
//  KeychainHelper.swift
//  Swell
//
//  Created by Tanner Maasen on 3/15/22.
//

import Foundation

// NOT YET IMPLEMENTED
class KeychainHelper {
    
    static let standard = KeychainHelper()
    
    func save(data: Data, key: String, account: String) {
        let query = [
            kSecValueData: data,
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        // Add data to keychain
        let status = SecItemAdd(query, nil)
        
        switch status {
        case errSecSuccess: print("Keychain Success")
        case errSecDuplicateItem:
            let updateQuery = [
                kSecAttrAccount: account,
                kSecAttrService: key,
                kSecClass: kSecClassGenericPassword
            ] as CFDictionary
            
            // Update field
            let updateAttr = [kSecValueData: data] as CFDictionary
            
            SecItemUpdate(updateQuery, updateAttr)
        default: print("Keychain Error \(status)")
        }
    }
    
    func read(key: String, account: String) -> Data? {
        let query = [
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        // to copy the data
        var resultData: AnyObject?
        SecItemCopyMatching(query, &resultData)
        
        return (resultData as? Data)
    }
    
    func delete(key: String, account: String) {
        let query = [
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        SecItemDelete(query)
    }
}
