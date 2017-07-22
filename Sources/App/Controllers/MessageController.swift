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
}
