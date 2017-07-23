//
//  MessageRoute.swift
//  VaporChat-Server
//
//  Created by Miłosz Filimowski on 22/07/2017.
//
//

import Vapor

final class MessageRoute: RouteCollection {

	func build(_ builder: RouteBuilder) throws {
		try builder.resource("message", MessageController.self)
	}
}

extension MessageRoute: EmptyInitializable {}
