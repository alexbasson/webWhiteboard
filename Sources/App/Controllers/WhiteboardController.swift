import Vapor
import HTTP
import Whiteboard

final class WhiteboardController: ResourceRepresentable {
  func index(request: Request) throws -> ResponseRepresentable {
    return try Whiteboard.all().makeNode().converted(to: JSON.self)
  }

  func create(request: Request) throws -> ResponseRepresentable {
    var whiteboard = try request.post()
    try whiteboard.save()
    return whiteboard
  }

  func show(request: Request, whiteboard: Whiteboard) throws -> ResponseRepresentable {
    return whiteboard
  }

  func delete(request: Request, whiteboard: Whiteboard) throws -> ResponseRepresentable {
    try whiteboard.delete()
    return JSON([:])
  }

  func clear(request: Request) throws -> ResponseRepresentable {
    try Whiteboard.query().delete()
    return JSON([])
  }

  func update(request: Request, whiteboard: Whiteboard) throws -> ResponseRepresentable {
    let new = try request.post()
    var whiteboard = whiteboard
    whiteboard.content = new.content
    try whiteboard.save()
    return whiteboard
  }

  func replace(request: Request, whiteboard: Whiteboard) throws -> ResponseRepresentable {
    try whiteboard.delete()
    return try create(request: request)
  }

  func makeResource() -> Resource<Post> {
    return Resource(
      index: index,
      store: create,
      show: show,
      replace: replace,
      modify: update,
      destroy: delete,
      clear: clear
    )
  }
}

extension Request {
  func post() throws -> Whiteboard {
    guard let json = json else { throw Abort.badRequest }
    return try Whiteboard(node: json)
  }
}
