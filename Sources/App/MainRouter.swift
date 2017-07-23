//
//  MainRouter.swift
//  VaporChat-Server
//
//  Created by Miłosz Filimowski on 16/07/2017.
//
//

import AuthProvider
import Vapor

final class MainRouter: RouteCollection {

	func build(_ builder: RouteBuilder) throws {

		let apiRoute = builder
			.grouped("api")
			.grouped(VersionMiddleware())
			.grouped("v1")

		let authRoute = apiRoute.grouped("auth")

		authRoute.post("register", handler: AuthController().register)
		authRoute.grouped(PasswordAuthenticationMiddleware(User.self))
			.post("login", handler: AuthController().login)

		let authenticatedRoute = apiRoute
			.grouped("user")
			.grouped(TokenAuthenticationMiddleware(User.self))
			.grouped(UserContextMiddleware())

		try authenticatedRoute.collection(MessageRoute.self)

	}
}

extension MainRouter: EmptyInitializable { }
