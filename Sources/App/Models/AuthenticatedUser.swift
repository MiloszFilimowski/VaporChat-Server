//
//  AuthenticatedUser.swift
//  VaporChat-Server
//
//  Created by Miłosz Filimowski on 23/07/2017.
//
//

import Foundation

extension User {
	static func authenticatedUser() throws -> User {
		return try UserContextMiddleware.authenticatedUser()
	}
}
