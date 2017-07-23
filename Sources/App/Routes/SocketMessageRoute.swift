//
//  SocketMessageRoute.swift
//  VaporChat-Server
//
//  Created by Miłosz Filimowski on 23/07/2017.
//
//

import Foundation

final class SocketMessageRoute: RouteCollection {

	func build(_ builder: RouteBuilder) throws {
		builder.socket("message", handler: MessageController().handleMessages)
	}
}

extension SocketMessageRoute: EmptyInitializable {}
