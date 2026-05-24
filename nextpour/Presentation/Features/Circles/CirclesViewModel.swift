import Foundation

@Observable
final class CirclesViewModel {
    private(set) var circles: [PourCircle] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let fetchCirclesUseCase: FetchCirclesUseCase

    init(fetchCirclesUseCase: FetchCirclesUseCase) {
        self.fetchCirclesUseCase = fetchCirclesUseCase
    }

    func loadCircles() async {
        isLoading = true
        defer { isLoading = false }
        do { circles = try await fetchCirclesUseCase.execute() } catch { errorMessage = error.localizedDescription }
    }
}
