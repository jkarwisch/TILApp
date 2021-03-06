import Vapor
import FluentPostgreSQL

final class Acronym: Codable {
    var id: Int?
    var short: String
    var long: String
    var userID: User.ID

  init(short: String, long: String, userID: User.ID) {
    self.short = short
    self.long = long
    self.userID = userID
  }
}

/*
# Long format
extension Acronym: Model {
  // 1
  typealias Database = SQLiteDatabase
  // 2
  typealias ID = Int
  // 3
  public static var idKey: IDKey = \Acronym.id
}
*/

// Short format
extension Acronym: PostgreSQLModel {}

extension Acronym: Content {}
extension Acronym {
    // 1
    var user: Parent<Acronym, User> {
        // 2
        return parent(\.userID)
    }
}
// 1
extension Acronym: Migration {
    // 2
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        // 3
        return Database.create(self, on: connection) { builder in
            // 4
            try addProperties(to: builder)
            // 5
            builder.reference(from: \.userID, to: \User.id)
        }
    }
}
