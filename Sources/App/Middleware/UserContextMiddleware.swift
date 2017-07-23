//
//  UserContextMiddleware.swift
//  VaporChat-Server
//
//  Created by Miłosz Filimowski on 22/07/2017.
//
//

import AuthProvider
import HTTP

final class UserContextMiddleware: Middleware {

	fileprivate static var authUser: User? = nil

	func respond(to request: Request, chainingTo next: Responder) throws -> Response {
		if let user = try? request.auth.assertAuthenticated() as User {
			UserContextMiddleware.authUser = user
		}
		return try next.respond(to: request)
	}
}

extension UserContextMiddleware {

	static func authenticatedUser() throws -> User {
		if let user = UserContextMiddleware.authUser {
			return user
		} else {
			throw AuthenticationError.notAuthenticated
		}
	}

}
