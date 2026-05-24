import SwiftUI

enum SpiritCategory: String, CaseIterable, Identifiable {
    case vodka = "Vodka"
    case whiskey = "Whiskey"
    case tequila = "Tequila"
    case rum = "Rum"
    case bourbon = "Bourbon"
    case cognac = "Cognac"
    case nonAlcohol = "Non-Alcohol"
    case beer = "Beer"
    case wine = "Wine"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .vodka: return "drop.fill"
        case .whiskey: return "flame.fill"
        case .tequila: return "sun.max.fill"
        case .rum: return "leaf.fill"
        case .bourbon: return "cylinder.fill"
        case .cognac: return "star.fill"
        case .nonAlcohol: return "sparkles"
        case .beer: return "mug.fill"
        case .wine: return "wineglass.fill"
        }
    }

    var popularBrands: [String] {
        switch self {
        case .vodka: return ["Tito's", "Grey Goose", "Cîroc"]
        case .whiskey: return ["Jack Daniel's", "Crown Royal", "Jameson"]
        case .tequila: return ["Patrón", "Jose Cuervo", "Casamigos"]
        case .rum: return ["Bacardi", "Captain Morgan", "Malibu"]
        case .bourbon: return ["Woodford Reserve", "Knob Creek", "Basil Hayden"]
        case .cognac: return ["Hennessy", "Rémy Martin", "Courvoisier"]
        case .nonAlcohol: return ["Seedlip", "Lyre's", "Athletic Brewing"]
        case .beer: return ["Heineken", "Sierra Nevada", "Modelo"]
        case .wine: return ["Meiomi", "La Marca", "Whispering Angel"]
        }
    }
}

enum BeverageTypeFilter: String, CaseIterable {
    case all = "All"
    case alcohol = "Alcohol"
    case nonAlcohol = "Non-Alcohol"
    case beer = "Beer"
    case wine = "Wine"
}

struct BeverageSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedSpirit: SpiritCategory? = nil
    @State private var typeFilter: BeverageTypeFilter = .all
    @State private var showUploadRecipe = false
    @State private var showOriginals = false
    @State private var venues: [Venue] = []
    @State private var bartenders: [Bartender] = []

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: UNPSpacing.lg) {
                SearchBarView(text: $searchText, placeholder: "Search popular spirit brands…")
                if !searchText.isEmpty {
                    searchResultsSection
                } else {
                    typeFilterRow
                    spiritCategoryScroll
                    if let spirit = selectedSpirit {
                        brandsSection(spirit)
                        recipesForSpirit(spirit)
                    } else {
                        popularPourSection
                        popularVenuesSection
                        bartendersSection
                    }
                }
            }
            .padding(UNPSpacing.md)
        }
        .background(UNPColor.background)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Label("Back", systemImage: "chevron.left")
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.ember)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: UNPSpacing.sm) {
                    Button { showUploadRecipe = true } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundStyle(UNPColor.ember)
                    }
                    Button { showOriginals = true } label: {
                        Text("UNP Originals")
                            .font(UNPFontStyle.caption())
                            .foregroundStyle(UNPColor.neonLight)
                            .padding(.horizontal, UNPSpacing.sm)
                            .padding(.vertical, 6)
                            .background(UNPColor.neon.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .navigationDestination(isPresented: $showOriginals) {
            OriginalsView()
        }
        .task {
            let di = DIContainer.shared
            if let v = try? await di.makeFetchVenuesUseCase().execute() { venues = v }
            if let b = try? await di.makeFetchBartendersUseCase().execute() { bartenders = b }
        }
        .sheet(isPresented: $showUploadRecipe) {
            UploadRecipeSheet()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationBackground(UNPColor.background)
                .presentationCornerRadius(UNPRadius.extraLarge)
        }
    }

    private var typeFilterRow: some View {
        HStack(spacing: UNPSpacing.xs) {
            Menu {
                ForEach(BeverageTypeFilter.allCases, id: \.self) { filter in
                    Button(filter.rawValue) { typeFilter = filter }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(typeFilter.rawValue)
                    Image(systemName: "chevron.down")
                }
                .font(UNPFontStyle.caption())
                .foregroundStyle(typeFilter == .all ? UNPColor.textSecondary : .black)
                .padding(.horizontal, UNPSpacing.md)
                .padding(.vertical, UNPSpacing.sm)
                .background(typeFilter == .all ? LinearGradient(colors: [UNPColor.surface, UNPColor.surface], startPoint: .top, endPoint: .bottom) : UNPColor.emberGradient)
                .clipShape(Capsule())
            }
            Spacer()
        }
    }

    private var spiritCategoryScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: UNPSpacing.sm) {
                ForEach(SpiritCategory.allCases) { spirit in
                    SpiritChip(
                        spirit: spirit,
                        isSelected: selectedSpirit == spirit,
                        action: {
                            withAnimation(.spring(response: 0.25)) {
                                selectedSpirit = selectedSpirit == spirit ? nil : spirit
                            }
                        }
                    )
                }
            }
        }
    }

    private func brandsSection(_ spirit: SpiritCategory) -> some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            SectionHeader(title: "Select Popular Spirit Brand")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: UNPSpacing.sm) {
                    ForEach(spirit.popularBrands, id: \.self) { brand in
                        BrandChip(brand: brand)
                    }
                }
            }
        }
    }

    private func recipesForSpirit(_ spirit: SpiritCategory) -> some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            HStack {
                SectionHeader(title: "Popular Pour")
                Spacer()
                Button { showUploadRecipe = true } label: {
                    HStack(spacing: 3) {
                        Image(systemName: "arrow.up.circle").font(.system(size: 11))
                        Text("Upload").font(UNPFontStyle.label())
                    }
                    .foregroundStyle(UNPColor.ember)
                    .padding(.horizontal, UNPSpacing.sm)
                    .padding(.vertical, 5)
                    .background(UNPColor.ember.opacity(0.12))
                    .clipShape(Capsule())
                }
            }
            ForEach(sampleRecipes(for: spirit), id: \.0) { recipe in
                RecipeRow(name: recipe.0, description: recipe.1, icon: spirit.icon, rating: recipe.2)
            }
        }
    }

    private func sampleRecipes(for spirit: SpiritCategory) -> [(String, String, Double)] {
        switch spirit {
        case .vodka: return [
            ("Moscow Mule", "Ginger beer, lime, copper cup.", 4.7),
            ("Vodka Soda", "Clean, crisp, refreshing.", 4.3),
            ("Cosmopolitan", "Cranberry, triple sec, lime.", 4.6)
        ]
        case .whiskey: return [
            ("Whiskey Sour", "Lemon, sugar, egg white.", 4.8),
            ("Manhattan", "Sweet vermouth, bitters.", 4.7),
            ("Old Fashioned", "Demerara, bitters, peel.", 4.9)
        ]
        case .tequila: return [
            ("Margarita", "Lime, triple sec, salt rim.", 4.8),
            ("Paloma", "Grapefruit soda, salt.", 4.6),
            ("Tequila Sunrise", "OJ, grenadine.", 4.4)
        ]
        case .rum: return [
            ("Mojito", "Mint, lime, soda.", 4.7),
            ("Daiquiri", "Lime, sugar, shaken.", 4.6),
            ("Dark & Stormy", "Ginger beer, lime.", 4.5)
        ]
        case .bourbon: return [
            ("Mint Julep", "Fresh mint, sugar, crushed ice.", 4.8),
            ("Boulevardier", "Campari, sweet vermouth.", 4.7),
            ("Smash", "Lemon, mint, simple syrup.", 4.5)
        ]
        case .cognac: return [
            ("Sidecar", "Triple sec, lemon.", 4.7),
            ("Hennessy Lemonade", "Lemon, honey.", 4.5),
            ("French Connection", "Amaretto, cognac.", 4.6)
        ]
        case .nonAlcohol: return [
            ("Virgin Mojito", "Mint, lime, soda.", 4.6),
            ("Lavender Fizz", "Lavender syrup, tonic.", 4.5),
            ("Citrus Cooler", "OJ, grapefruit, soda.", 4.4)
        ]
        case .beer: return [
            ("Beer Cocktail", "Citrus, ginger beer.", 4.3),
            ("Shandy", "Lemonade, light beer.", 4.4),
            ("Michelada", "Lime, hot sauce, salt.", 4.6)
        ]
        case .wine: return [
            ("Sangria", "Fruits, OJ, brandy.", 4.7),
            ("Wine Spritzer", "Sparkling water, white wine.", 4.5),
            ("Kir Royale", "Champagne, crème de cassis.", 4.8)
        ]
        }
    }

    private var popularPourSection: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            SectionHeader(title: "Popular Pour")
            RecipeRow(name: "Midnight Old Fashioned", description: "Smoked bourbon, demerara, aromatic bitters — Detroit slow pour.", icon: "wineglass.fill", rating: 4.8)
            RecipeRow(name: "Copper Sour", description: "Citrus lift with amaro depth and a frothy cap.", icon: "cup.and.saucer.fill", rating: 4.6)
            RecipeRow(name: "Riverfront Spritz", description: "Aperitivo sparkle with local sparkling and bitter citrus.", icon: "sparkles", rating: 4.5)
            RecipeRow(name: "Ambassador's Negroni", description: "Barrel-rested gin, vermouth, Campari — stirred, never rushed.", icon: "cylinder.fill", rating: 4.7)
            RecipeRow(name: "Late Night Espresso Martini", description: "Velvet coffee kick for the after-hours.", icon: "moon.fill", rating: 4.4)
        }
    }

    private var popularVenuesSection: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            SectionHeader(title: "Popular Venues")
            if venues.isEmpty {
                ForEach(0..<2, id: \.self) { _ in SkeletonRowView() }
            } else {
                ForEach(venues.prefix(3)) { venue in VenueCard(venue: venue) }
            }
        }
    }

    private var bartendersSection: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            SectionHeader(title: "Pour Pros")
            if bartenders.isEmpty {
                ForEach(0..<2, id: \.self) { _ in SkeletonRowView() }
            } else {
                ForEach(bartenders.prefix(2)) { bartender in BartenderCard(bartender: bartender) }
            }
        }
    }

    private var matchingSpirits: [SpiritCategory] {
        SpiritCategory.allCases.filter {
            $0.rawValue.localizedCaseInsensitiveContains(searchText) ||
            $0.popularBrands.contains { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    private var matchingRecipes: [(String, String, Double)] {
        SpiritCategory.allCases
            .flatMap { sampleRecipes(for: $0) }
            .filter { $0.0.localizedCaseInsensitiveContains(searchText) }
    }

    private var matchingVenues: [Venue] {
        venues.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    @ViewBuilder
    private var searchResultsSection: some View {
        let spirits = matchingSpirits
        let recipes = matchingRecipes
        let venueResults = matchingVenues
        if spirits.isEmpty && recipes.isEmpty && venueResults.isEmpty {
            ContentUnavailableView {
                Label("No Results", systemImage: "magnifyingglass")
            } description: {
                Text("No spirits, recipes, or venues matched \"\(searchText)\".")
            }
            .padding(.top, UNPSpacing.xxl)
        } else {
            VStack(alignment: .leading, spacing: UNPSpacing.lg) {
                if !spirits.isEmpty {
                    VStack(alignment: .leading, spacing: UNPSpacing.sm) {
                        SectionHeader(title: "Spirits")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: UNPSpacing.sm) {
                                ForEach(spirits) { spirit in
                                    SpiritChip(spirit: spirit, isSelected: selectedSpirit == spirit) {
                                        withAnimation(.spring(response: 0.25)) {
                                            selectedSpirit = spirit
                                            searchText = ""
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if !recipes.isEmpty {
                    VStack(alignment: .leading, spacing: UNPSpacing.sm) {
                        SectionHeader(title: "Recipes")
                        ForEach(recipes, id: \.0) { recipe in
                            RecipeRow(name: recipe.0, description: recipe.1, icon: "wineglass.fill", rating: recipe.2)
                        }
                    }
                }
                if !venueResults.isEmpty {
                    VStack(alignment: .leading, spacing: UNPSpacing.sm) {
                        SectionHeader(title: "Venues")
                        ForEach(venueResults) { venue in
                            VenueCard(venue: venue)
                        }
                    }
                }
            }
        }
    }
}

private struct SpiritChip: View {
    let spirit: SpiritCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: spirit.icon)
                    .font(.system(size: 12))
                Text(spirit.rawValue)
                    .font(UNPFontStyle.caption())
            }
            .foregroundStyle(isSelected ? .black : UNPColor.textSecondary)
            .padding(.horizontal, UNPSpacing.md)
            .padding(.vertical, UNPSpacing.sm)
            .background(isSelected ? UNPColor.emberGradient : LinearGradient(colors: [UNPColor.surface, UNPColor.surface], startPoint: .top, endPoint: .bottom))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

private struct BrandChip: View {
    let brand: String

    var body: some View {
        Text(brand)
            .font(UNPFontStyle.caption())
            .foregroundStyle(UNPColor.textPrimary)
            .padding(.horizontal, UNPSpacing.md)
            .padding(.vertical, UNPSpacing.sm)
            .background(UNPColor.surfaceElevated)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(UNPColor.ember.opacity(0.4), lineWidth: 1))
    }
}

struct RecipeRow: View {
    let name: String
    let description: String
    let icon: String
    var rating: Double? = nil

    var body: some View {
        HStack(spacing: UNPSpacing.md) {
            ZStack {
                Circle()
                    .fill(UNPColor.surfaceElevated)
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(UNPColor.ember)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(name)
                    .font(UNPFontStyle.heading(14))
                    .foregroundStyle(UNPColor.textPrimary)
                Text(description)
                    .font(UNPFontStyle.caption(12))
                    .foregroundStyle(UNPColor.textSecondary)
                    .lineLimit(2)
                if let rating {
                    StarRating(rating: rating, starCount: 1, size: 11)
                }
            }
            Spacer()
            ChevronRight()
        }
        .padding(UNPSpacing.md)
        .unpCard()
    }
}

private struct UploadRecipeSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var category: SpiritCategory = .vodka
    @State private var description = ""
    @State private var isLoading = false
    @State private var showSuccess = false

    var body: some View {
        NavigationStack {
            if showSuccess {
                SuccessStateView(title: "Recipe Uploaded", message: "Your recipe is now live on UNP.", onDone: { dismiss() })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(UNPColor.background)
            } else {
                Form {
                    Section("Recipe Info") {
                        TextField("Recipe name", text: $name)
                            .listRowBackground(UNPColor.surface)
                            .foregroundStyle(UNPColor.textPrimary)
                        Picker("Category", selection: $category) {
                            ForEach(SpiritCategory.allCases) { cat in
                                Text(cat.rawValue).tag(cat)
                            }
                        }
                        .listRowBackground(UNPColor.surface)
                        TextField("Description", text: $description, axis: .vertical)
                            .lineLimit(3, reservesSpace: true)
                            .listRowBackground(UNPColor.surface)
                            .foregroundStyle(UNPColor.textPrimary)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(UNPColor.background)
                .navigationTitle("Upload Recipe")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") { dismiss() }.foregroundStyle(UNPColor.textSecondary)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isLoading = true
                            Task {
                                try? await Task.sleep(for: .seconds(0.8))
                                isLoading = false
                                showSuccess = true
                            }
                        } label: {
                            if isLoading {
                                LoadingSpinner(color: UNPColor.ember, size: 16)
                            } else {
                                Text("Upload")
                                    .foregroundStyle(UNPColor.ember)
                            }
                        }
                        .disabled(name.isEmpty || isLoading)
                    }
                }
            }
        }
    }
}
