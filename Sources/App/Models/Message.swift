//
//  Message.swift
//  VaporChat-Server
//
//  Created by Miłosz Filimowski on 22/07/2017.
//
//

import FluentProvider
import Vapor

final class Message: Model {

	let storage = Storage()

	// MARK: Properties

	/// The meesage body.
	var body: String

	/// The ID of the author that created the message.
	var authorID: Identifier

	// MARK: Database keys

	fileprivate static let bodyKey = "body"
	fileprivate static let authorIDKey = "author_id"

	// MARK: Initialization

	/// Intializes a message
	///
	/// - Parameters:
	///   - body: The body of the message.
	///   - authorID: The ID of the message author.
	init(body: String, authorID: Identifier) {
		self.body = body
		self.authorID = authorID
	}

	init(row: Row) throws {
		body = try row.get(Message.bodyKey)
		authorID = try row.get(Message.authorIDKey)
	}

	func makeRow() throws -> Row {
		var row = Row()
		try row.set(Message.bodyKey, body)
		try row.set(Message.authorIDKey, authorID)
		return row
	}
	
}

// MARK: Relations

extension Message {
	/// An instance of User object representing author of the message.
	var author: Parent<Message, User> {
		return parent(id: authorID)
	}
}

extension User {
	/// Represents the messages created by user.
	var messages: Children<User, Message>? {
		return children()
	}
}

extension Message: Updateable {
	static var updateableKeys: [UpdateableKey<Message>] {
		return [
			UpdateableKey(Message.bodyKey, String.self) { message, body in
				message.body = body
			}
		]
	}
}

extension Message: Preparation {

	static func prepare(_ database: Database) throws {
		try database.create(self) { builder in
			builder.id()
			builder.string(Message.bodyKey)
			builder.foreignId(for: User.self, optional: false, unique: false, foreignIdKey: Message.authorIDKey, foreignKeyName: Message.authorIDKey)
		}
	}

	static func revert(_ database: Database) throws {
		try database.delete(self)
	}

}

extension Message: ResponseRepresentable, JSONConvertible {

	convenience init(json: JSON) throws {
		try self.init(
			body: json.get(Message.bodyKey),
			authorID: json.get(Message.authorIDKey)
		)
	}

	func makeJSON() throws -> JSON {
		var json = JSON()
		try json.set(Message.idKey, id)
		try json.set(Message.bodyKey, body)
		try json.set("author", author.get()?.makeJSON())
		return json
	}

}
