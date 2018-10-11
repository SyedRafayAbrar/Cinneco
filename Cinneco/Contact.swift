//
//  Contact.swift
//  Cinneco
//
//  Created by Asher Ahsan on 05/11/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import Foundation

class Contact {
    private var name: String?
    private var number: String?
    
    var getName: String? {
        return self.name
    }
    
    var getNumber: String? {
        return self.number
    }
    
    init(contactName: String?, contactNumber: String?) {
        if contactName != nil {
            self.name = contactName
        } else {
            self.name = "N/A"
        }
        
        if contactNumber != nil {
            self.number = contactNumber
        } else {
            self.number = nil
        }
    }
}
