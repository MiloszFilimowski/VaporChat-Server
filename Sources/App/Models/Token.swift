//The MIT License (MIT)
//
//Copyright (c) 2016 Tanner Nelson
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.
//
// https://github.com/MiloszFilimowski/auth-template/blob/master/Sources/App/Models/Token.swift
//

import Vapor
import FluentProvider
import Crypto

final class Token: Model {
	let storage = Storage()

	/// The actual token
	let token: String

	/// The identifier of the user to which the token belongs
	let userId: Identifier

	// MARK: Database keys



	/// Initialiazes a token
	///
	/// - Parameters:
	///   - tokenString: A base64 encoded string representing token.
	///   - user: The user of the token.
	/// - Throws: An error if the user does not exist.
	init(tokenString: String, user: User) throws {
		token = tokenString
		userId = try user.assertExists()
	}

	init(row: Row) throws {
		token = try row.get("token")
		userId = try row.get(User.foreignIdKey)
	}

	func makeRow() throws -> Row {
		var row = Row()
		try row.set("token", token)
		try row.set(User.foreignIdKey, userId)
		return row
	}

}

// MARK: Convenience

extension Token {
	static func generate(for user: User) throws -> Token {
		let random = try Crypto.Random.bytes(count: 16)

		return try Token(tokenString: random.base64Encoded.makeString(), user: user)
	}

}

extension Token {
	/// Fluent relation for accessing the user.
	var user: Parent<Token, User> {
		return parent(id: userId)
	}

}

extension Token: Preparation {
	static func prepare(_ database: Database) throws {
		try database.create(Token.self) { builder in
			builder.id()
			builder.string("token")
			builder.foreignId(for: User.self)
		}
	}

	static func revert(_ database: Database) throws {
		try database.delete(Token.self)
	}

}

extension Token: JSONRepresentable {
	func makeJSON() throws -> JSON {
		var json = JSON()
		try json.set("token", token)
		return json
	}

}

extension Token: ResponseRepresentable { }
