//
//  User.swift
//  VaporChat-Server
//
//  Created by Miłosz Filimowski on 22/07/2017.
//
//

import Vapor
import FluentProvider
import AuthProvider
import HTTP

final class User: Model {

	let storage = Storage()

	// MARK: Properties

	var userName: String

	/// The user's password.
	var password: String?

	// MARK: Database keys

	static var usernameKey = "user_name" 


	/// Initializes a user.
	///
	/// - Parameter userName: The user name of the user (xd).
	init(userName: String, password: String? = nil) {
		self.userName = userName
	}

	init(row: Row) throws {
		userName = try row.get(User.usernameKey)
		password = try row.get(User.passwordKey)
	}

	func makeRow() throws -> Row {
		var row = Row()
		try row.set(User.usernameKey, userName)
		try row.set(User.passwordKey, password)
		return row
	}

}

extension User: Updateable {

	static var updateableKeys: [UpdateableKey<User>] {
		return [
			UpdateableKey(User.usernameKey, String.self) { user, userName in
				user.userName = userName
			},
			UpdateableKey(User.passwordKey, String.self) { user, password in
				user.password = password
			}
		]
	}
}

extension User: Preparation {

	static func prepare(_ database: Database) throws {
		try database.create(self) { builder in
			builder.id()
			builder.string(User.usernameKey)
			builder.string(User.passwordKey)
		}
	}

	static func revert(_ database: Database) throws {
		try database.delete(self)
	}

}

extension User: ResponseRepresentable, JSONConvertible {

	convenience init(json: JSON) throws {
		try self.init(
			userName: json.get(User.usernameKey)
		)
		id = try json.get(User.idKey)
	}

	func makeJSON() throws -> JSON {
		var json = JSON()
		try json.set(User.idKey, id)
		try json.set(User.usernameKey, userName)
		return json
	}

}

// store private variable since storage in extensions
// is not yet allowed in Swift
private var _userPasswordVerifier: PasswordVerifier? = nil

extension User: PasswordAuthenticatable {
	var hashedPassword: String? {
		return password
	}

	public static var passwordVerifier: PasswordVerifier? {
		get { return _userPasswordVerifier }
		set { _userPasswordVerifier = newValue }
	}

	
}

extension User: TokenAuthenticatable {
	typealias TokenType = Token
}
