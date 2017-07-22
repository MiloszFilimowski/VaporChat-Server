@_exported import Vapor

extension Droplet {
    public func setup() throws {
//        try setupRoutes()
		try collection(MainRouter.self)
        // Do any additional droplet setup
    }
}
