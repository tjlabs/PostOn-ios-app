
import Foundation

enum PostOnViewState {
    case expanded, closed, normal
}

struct SectorCellItem: Codable {
    var title: String
    var available: Bool
    var message: String
    var distance: Int
    var address: String
}
