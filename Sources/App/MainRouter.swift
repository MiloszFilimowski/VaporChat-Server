//
//  MainRouter.swift
//  VaporChat-Server
//
//  Created by Miłosz Filimowski on 16/07/2017.
//
//

import Foundation
import Vapor

final class MainRouter: RouteCollection {

	func build(_ builder: RouteBuilder) throws {
		let versionMiddleware = VersionMiddleware()

		let apiRoute = builder
			.grouped("api")
			.grouped(versionMiddleware)
			.grouped("v1")
		try apiRoute.collection(MessageRoute.self)

	}
}

extension MainRouter: EmptyInitializable { }
