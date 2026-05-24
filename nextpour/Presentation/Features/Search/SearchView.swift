import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel
    @State private var searchText = ""
    @State private var selectedEvent: Event?

    init() {
        _viewModel = State(initialValue: SearchViewModel(
            searchUseCase: DIContainer.shared.makeSearchContentUseCase()
        ))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBarView(text: $searchText, placeholder: "Search beverages, events, venues…")
                    .padding(.horizontal, UNPSpacing.md)
                    .padding(.vertical, UNPSpacing.sm)
                    .background(UNPColor.background)

                Group {
                    if searchText.isEmpty {
                        searchPrompt
                    } else if viewModel.isSearching {
                        ScrollView {
                            VStack(spacing: UNPSpacing.sm) {
                                ForEach(0..<4, id: \.self) { _ in SkeletonRowView() }
                            }
                            .padding(UNPSpacing.md)
                        }
                    } else if let results = viewModel.results, !isEmpty(results) {
                        searchResults(results)
                    } else if searchText.count >= 2 {
                        ContentUnavailableView {
                            Label("No Results", systemImage: "magnifyingglass")
                        } description: {
                            Text("Nothing matched \"\(searchText)\". Try a different term.")
                        }
                    } else {
                        searchPrompt
                    }
                }
            }
            .background(UNPColor.background)
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ThemeToggleButton()
                }
            }
        }
        .onChange(of: searchText) { _, new in
            Task { await viewModel.search(query: new) }
        }
    }

    private var searchPrompt: some View {
        VStack(spacing: UNPSpacing.lg) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(UNPColor.textMuted)
            Text("Search across UNP")
                .font(UNPFontStyle.heading())
                .foregroundStyle(UNPColor.textPrimary)
            VStack(spacing: UNPSpacing.sm) {
                searchHint(icon: "wineglass.fill", label: "Beverages & cocktails", color: UNPColor.copper)
                searchHint(icon: "calendar", label: "Events near you", color: UNPColor.success)
                searchHint(icon: "map.fill", label: "Venues in Detroit", color: UNPColor.violet)
                searchHint(icon: "person.fill", label: "Bartenders & pour pros", color: UNPColor.gold)
            }
            .padding(.horizontal, UNPSpacing.xl)
            Spacer()
        }
    }

    private func searchHint(icon: String, label: String, color: Color) -> some View {
        HStack(spacing: UNPSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(color)
                .frame(width: 24)
            Text(label)
                .font(UNPFontStyle.body())
                .foregroundStyle(UNPColor.textSecondary)
            Spacer()
        }
    }

    private func searchResults(_ results: SearchResults) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: UNPSpacing.lg) {
                if !results.beverages.isEmpty {
                    resultsSection(title: "Beverages", count: results.beverages.count) {
                        ForEach(results.beverages) { beverage in
                            BeverageCard(beverage: beverage)
                        }
                    }
                }
                if !results.events.isEmpty {
                    resultsSection(title: "Events", count: results.events.count) {
                        ForEach(results.events) { event in
                            EventCard(event: event) {}
                        }
                    }
                }
                if !results.venues.isEmpty {
                    resultsSection(title: "Venues", count: results.venues.count) {
                        ForEach(results.venues) { venue in
                            VenueCard(venue: venue)
                        }
                    }
                }
                if !results.bartenders.isEmpty {
                    resultsSection(title: "Bartenders", count: results.bartenders.count) {
                        ForEach(results.bartenders) { bartender in
                            BartenderCard(bartender: bartender)
                        }
                    }
                }
            }
            .padding(UNPSpacing.md)
        }
    }

    @ViewBuilder
    private func resultsSection<Content: View>(title: String, count: Int, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            HStack {
                Text(title)
                    .font(UNPFontStyle.label())
                    .foregroundStyle(UNPColor.textMuted)
                    .textCase(.uppercase)
                    .tracking(0.5)
                Spacer()
                Text("\(count)")
                    .font(UNPFontStyle.label())
                    .foregroundStyle(UNPColor.copper)
            }
            content()
        }
    }

    private func isEmpty(_ results: SearchResults) -> Bool {
        results.beverages.isEmpty && results.events.isEmpty && results.venues.isEmpty && results.bartenders.isEmpty
    }
}
