import Foundation

struct RewardCatalogItemDTO: Codable {
    let id: String
    let title: String
    let description: String
    let pointsCost: Int
    let hostName: String
    let hostType: String
    let category: String

    func toDomain() -> RewardCatalogItem {
        RewardCatalogItem(
            id: id,
            title: title,
            description: description,
            pointsCost: pointsCost,
            hostName: hostName,
            hostType: RewardCatalogHostType(rawValue: hostType) ?? .venue,
            category: category
        )
    }
}
