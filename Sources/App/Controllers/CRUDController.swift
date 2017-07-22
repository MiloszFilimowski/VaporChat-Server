//
//  CRUDController.swift
//  VaporChat-Server
//
//  Created by Miłosz Filimowski on 22/07/2017.
//
//

import FluentProvider
import Vapor

protocol CRUDController {

    associatedtype ConcreteModel: Model

    func index(request: Request) throws -> ResponseRepresentable
    func create(request: Request) throws -> ResponseRepresentable
    func show(request: Request, model: ConcreteModel) throws -> ResponseRepresentable
    func delete(request: Request, model: ConcreteModel) throws -> ResponseRepresentable
    func update(request: Request, model: ConcreteModel) throws -> ResponseRepresentable

}

extension CRUDController where Self: ResourceRepresentable {
    func makeResource() -> Resource<ConcreteModel> {
        return Resource(
            index: index,
            store: create,
            show: show,
            update: update,
            destroy: delete
        )
    }

}

extension CRUDController where ConcreteModel: ResponseRepresentable {
	func delete(request: Request, model: ConcreteModel) throws -> ResponseRepresentable {
		try model.delete()

		return Response(status: .ok)
	}
}

extension CRUDController where ConcreteModel: ResponseRepresentable , ConcreteModel: JSONRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {

        return try ConcreteModel.all().makeJSON()
    }

    func show(request: Request, model: ConcreteModel) throws -> ResponseRepresentable {

        return model
    }

}

extension CRUDController where ConcreteModel: ResponseRepresentable, ConcreteModel: JSONInitializable {
    func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let model = try ConcreteModel(json: json)
        try model.save()

        return model
    }
    
}

extension CRUDController where ConcreteModel: ResponseRepresentable, ConcreteModel: Updateable {
	func update(request: Request, model: ConcreteModel) throws -> ResponseRepresentable {
		try model.update(for: request)
		try model.save()

		return model
	}
	
}
