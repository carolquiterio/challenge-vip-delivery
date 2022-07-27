//
//  CACreateAccountViewModel.swift
//  DeliveryAppChallenge
//
//  Created by Carolina Quiterio on 27/07/22.
//

import Foundation
import UIKit

class CACreateAccountViewModel {
    var controller: UIViewController?
    
    internal func isFormNameValid(_ name: String?) -> Bool {
        let fullNameArr = name?.components(separatedBy: " ")
        return fullNameArr!.count <= 1 || ((name?.isEmpty) != nil)
    }
    
    internal func isFormPhoneValid(_ phone: String?) -> Bool {
        let text = replacePhoneString(phone ?? "")
        return text.count == 11
    }
    
    internal func isEmailValid(_  email: String?) -> Bool {
        return email!.isEmpty ||
            !email!.contains(".") ||
            !email!.contains("@") ||
            email!.count <= 5
    }
    
    internal func areEmailsTheSame(_ email: String?, _ emailConfirmation: String?) -> Bool {
        return email?.trimmingCharacters(in: .whitespaces) != emailConfirmation?.trimmingCharacters(in: .whitespaces)
    }
    
    private func replacePhoneString(_ phone: String) -> String {
        return phone.replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
    
}
