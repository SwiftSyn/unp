import Foundation

enum AuraFilter: String, CaseIterable {
    case all = "All"
    case venues = "Venues"
    case eventHosts = "Event Hosts"
}

@Observable
final class AuraPortalViewModel {
    private(set) var catalogItems: [RewardCatalogItem] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    var selectedFilter: AuraFilter = .all

    var reward: Reward?

    private let fetchCatalogUseCase: FetchRewardCatalogUseCase

    init(fetchCatalogUseCase: FetchRewardCatalogUseCase, reward: Reward?) {
        self.fetchCatalogUseCase = fetchCatalogUseCase
        self.reward = reward
    }

    var filteredItems: [RewardCatalogItem] {
        switch selectedFilter {
        case .all:
            return catalogItems
        case .venues:
            return catalogItems.filter { $0.hostType == .venue }
        case .eventHosts:
            return catalogItems.filter { $0.hostType == .eventHost }
        }
    }

    var userPoints: Int { reward?.points ?? 0 }
    var userTier: RewardTier { reward?.tier ?? .bronze }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            catalogItems = try await fetchCatalogUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func canAfford(_ item: RewardCatalogItem) -> Bool {
        userPoints >= item.pointsCost
    }
}
