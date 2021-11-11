//
//  LoginViewDelegate.swift
//  TableViewWithREST
//
//  Created by Michael Charland on 2019-08-30.
//  Copyright © 2019 charland. All rights reserved.
//

import Foundation

protocol LoginViewDelegate: AnyObject {
    func didTapLoginButton()
    func didTapAuthenticateButton()
    func didTapPocketAuthenticateButton()
}
