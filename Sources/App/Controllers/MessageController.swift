//
//  MessageController.swift
//  VaporChat-Server
//
//  Created by Miłosz Filimowski on 22/07/2017.
//
//

import Vapor

final class MessageController: ResourceRepresentable, CRUDController, EmptyInitializable {
	typealias ConcreteModel = Message

	fileprivate static var onNewMessage: ((Message) throws -> Void)? = nil

	func create(request: Request) throws -> ResponseRepresentable {
		guard let json = request.json else { throw Abort.badRequest }
		let model = try Message(json: json)
		try model.save()

		try MessageController.onNewMessage?(model)

		return model
	}

	func handleMessages(request: Request, socket: WebSocket) throws {

		MessageController.onNewMessage = { message in
			let string = message.body
			try socket.send(string)
		}

	}
}
