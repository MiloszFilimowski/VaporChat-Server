//
//  UserContextMiddleware.swift
//  VaporChat-Server
//
//  Created by Miłosz Filimowski on 22/07/2017.
//
//

import HTTP

final class UserContextMiddleware: Middleware {
	func respond(to request: Request, chainingTo next: Responder) throws -> Response {

		
		return try next.respond(to: request)
	}
}
