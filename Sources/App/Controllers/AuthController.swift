//
//  AuthController.swift
//

import AuthProvider
import BCrypt
import Foundation

final class AuthController {

    func login(_ request: Request) throws -> ResponseRepresentable {
        let user = try request.auth.assertAuthenticated() as User
		let token = try Token.generate(for: user)
		try token.save()

		return token

    }

	func register(_ request: Request) throws -> ResponseRepresentable {
		guard let json = request.json else {
			throw Abort(.badRequest)
		}
		let user = try User(json: json)

		guard try User.makeQuery().filter("user_name", user.userName).first() == nil else {
			throw Abort(.badRequest, reason: "A user with that username already exists.")
		}

		// require a plaintext password is supplied
		guard let password = json["password"]?.string else {
			throw Abort(.badRequest)
		}

		// hash the password and set it on the user
		user.password = try BCrypt.Hash.make(message: password.makeBytes()).makeString()

		// save and return the new user
		try user.save()
		return user
	}

}
