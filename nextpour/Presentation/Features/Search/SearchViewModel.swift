import Foundation

@Observable
final class SearchViewModel {
    private(set) var results: SearchResults? = nil
    private(set) var isSearching = false

    private let searchUseCase: SearchContentUseCase

    init(searchUseCase: SearchContentUseCase) {
        self.searchUseCase = searchUseCase
    }

    func search(query: String) async {
        guard query.count >= 2 else { results = nil; return }
        isSearching = true
        defer { isSearching = false }
        do { results = try await searchUseCase.execute(query: query) } catch { results = nil }
    }
}
