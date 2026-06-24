import Foundation
import CoreData

final class DIContainer {
    static let shared = DIContainer()

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    lazy var beverageRepository: BeverageRepositoryProtocol = BeverageRepositoryImpl(localDataSource: BeverageLocalDataSource(context: context))
    lazy var eventRepository: EventRepositoryProtocol = EventRepositoryImpl(localDataSource: EventLocalDataSource(context: context))
    lazy var postRepository: PostRepositoryProtocol = PostRepositoryImpl(localDataSource: PostLocalDataSource(context: context))
    lazy var venueRepository: VenueRepositoryProtocol = VenueRepositoryImpl(localDataSource: VenueLocalDataSource(context: context))
    lazy var bartenderRepository: BartenderRepositoryProtocol = BartenderRepositoryImpl(localDataSource: BartenderLocalDataSource(context: context))
    lazy var circleRepository: PourCircleRepositoryProtocol = PourCircleRepositoryImpl(localDataSource: CircleLocalDataSource(context: context))
    lazy var nudgeRepository: NudgeRepositoryProtocol = NudgeRepositoryImpl(localDataSource: NudgeLocalDataSource(context: context))
    lazy var bartenderClassRepository: BartenderClassRepositoryProtocol = BartenderClassRepositoryImpl(localDataSource: BartenderClassLocalDataSource(context: context))
    lazy var communityRepository: CommunityRepositoryProtocol = CommunityRepositoryImpl(localDataSource: CommunityLocalDataSource(context: context))
    lazy var userRepository: UserRepositoryProtocol = UserRepositoryImpl(localDataSource: UserLocalDataSource(context: context))
    lazy var rewardRepository: RewardRepositoryProtocol = RewardRepositoryImpl(localDataSource: RewardLocalDataSource(context: context))
    lazy var rewardCatalogRepository: RewardCatalogRepositoryProtocol = RewardCatalogRepositoryImpl(localDataSource: RewardCatalogLocalDataSource())
    lazy var cartRepository: CartRepositoryProtocol = CartRepositoryImpl()
    lazy var orderRepository: OrderRepositoryProtocol = OrderRepositoryImpl()

    lazy var searchRepository: SearchRepositoryProtocol = SearchRepositoryImpl(
        beverageRepository: beverageRepository,
        eventRepository: eventRepository,
        venueRepository: venueRepository,
        bartenderRepository: bartenderRepository
    )

    func makeFetchBeveragesUseCase() -> FetchBeveragesUseCase { FetchBeveragesUseCase(repository: beverageRepository) }
    func makeFetchEventsUseCase() -> FetchEventsUseCase { FetchEventsUseCase(repository: eventRepository) }
    func makeFetchPostsUseCase() -> FetchPostsUseCase { FetchPostsUseCase(repository: postRepository) }
    func makeTogglePostLikeUseCase() -> TogglePostLikeUseCase { TogglePostLikeUseCase(repository: postRepository) }
    func makeFetchVenuesUseCase() -> FetchVenuesUseCase { FetchVenuesUseCase(repository: venueRepository) }
    func makeFetchBartendersUseCase() -> FetchBartendersUseCase { FetchBartendersUseCase(repository: bartenderRepository) }
    func makeFetchBartenderClassesUseCase() -> FetchBartenderClassesUseCase { FetchBartenderClassesUseCase(repository: bartenderClassRepository) }
    func makeFetchCirclesUseCase() -> FetchCirclesUseCase { FetchCirclesUseCase(repository: circleRepository) }
    func makeFetchCartUseCase() -> FetchCartUseCase { FetchCartUseCase(repository: cartRepository) }
    func makeAddToCartUseCase() -> AddToCartUseCase { AddToCartUseCase(repository: cartRepository) }
    func makePlaceOrderUseCase() -> PlaceOrderUseCase { PlaceOrderUseCase(orderRepository: orderRepository, cartRepository: cartRepository) }
    func makeFetchCurrentUserUseCase() -> FetchCurrentUserUseCase { FetchCurrentUserUseCase(repository: userRepository) }
    func makeFetchNudgesUseCase() -> FetchNudgesUseCase { FetchNudgesUseCase(repository: nudgeRepository) }
    func makeVoteNudgeUseCase() -> VoteNudgeUseCase { VoteNudgeUseCase(repository: nudgeRepository) }
    func makeFetchCommunityMessagesUseCase() -> FetchCommunityMessagesUseCase { FetchCommunityMessagesUseCase(repository: communityRepository) }
    func makeFetchRewardUseCase() -> FetchRewardUseCase { FetchRewardUseCase(repository: rewardRepository) }
    func makeFetchRewardCatalogUseCase() -> FetchRewardCatalogUseCase { FetchRewardCatalogUseCase(repository: rewardCatalogRepository) }
    func makeSearchContentUseCase() -> SearchContentUseCase { SearchContentUseCase(repository: searchRepository) }
}
