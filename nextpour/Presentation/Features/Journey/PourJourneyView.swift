import SwiftUI

struct PourJourneyView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showBeverageSearch = false
    @State private var showOriginals = false
    @State private var isSaved = false
    @State private var relatedBeverages: [Beverage] = []
    @State private var showMoodSelector = false
    @State private var selectedMood: UserMood? = nil

    var body: some View {
        ZStack(alignment: .bottom) {
            UNPColor.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: UNPSpacing.lg) {
                    heroCard
                    if selectedMood != nil {
                        moodSuggestionBanner
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    recipeCard
                    ingredientsCard
                    methodCard
                    pairingCard
                    relatedCard
                    Spacer().frame(height: 80)
                }
                .padding(UNPSpacing.md)
            }

            saveBar
                .padding(.horizontal, UNPSpacing.md)
                .padding(.bottom, UNPSpacing.md)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Label("Home", systemImage: "chevron.left")
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.ember)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("The Pour")
                    .font(UNPFontStyle.heading(16))
                    .foregroundStyle(UNPColor.textPrimary)
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: UNPSpacing.xs) {
                    Button { showMoodSelector = true } label: {
                        HStack(spacing: 4) {
                            Image(systemName: selectedMood == nil ? "face.smiling" : "face.smiling.fill")
                                .font(.system(size: 13))
                            Text(selectedMood == nil ? "My Mood" : selectedMood!.label)
                                .font(UNPFontStyle.caption())
                        }
                        .foregroundStyle(selectedMood == nil ? UNPColor.neonLight : .black)
                        .padding(.horizontal, UNPSpacing.sm)
                        .padding(.vertical, 6)
                        .background(selectedMood == nil ? LinearGradient(colors: [UNPColor.neon.opacity(0.15), UNPColor.neon.opacity(0.15)], startPoint: .top, endPoint: .bottom) : UNPColor.emberGradient)
                        .clipShape(Capsule())
                    }
                    toolbarChip("Beverage", icon: "wineglass.fill", accent: false) {
                        showBeverageSearch = true
                    }
                }
            }
        }
        .sheet(isPresented: $showMoodSelector) {
            MoodSelectorView(selectedMood: $selectedMood) { mood in selectedMood = mood }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(UNPColor.background)
                .presentationCornerRadius(UNPRadius.extraLarge)
        }
        .navigationDestination(isPresented: $showBeverageSearch) {
            BeverageSearchView()
        }
        .navigationDestination(isPresented: $showOriginals) {
            OriginalsView()
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSaved)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: selectedMood)
        .task {
            if let beverages = try? await DIContainer.shared.makeFetchBeveragesUseCase().execute() {
                relatedBeverages = Array(beverages.prefix(4))
            }
        }
    }

    private var moodSuggestionBanner: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            HStack {
                HStack(spacing: UNPSpacing.xs) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 11))
                        .foregroundStyle(UNPColor.ember)
                    Text("POURED FOR YOUR MOOD")
                        .font(UNPFontStyle.label())
                        .foregroundStyle(UNPColor.ember)
                        .tracking(0.5)
                }
                Spacer()
                Button { selectedMood = nil } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 11))
                        .foregroundStyle(UNPColor.textMuted)
                }
            }

            if let mood = selectedMood {
                HStack(spacing: 4) {
                    Image(systemName: mood.icon).font(.system(size: 10))
                    Text(mood.label).font(UNPFontStyle.label())
                }
                .foregroundStyle(UNPColor.neonLight)
                .padding(.horizontal, UNPSpacing.sm)
                .padding(.vertical, UNPSpacing.xs)
                .background(UNPColor.neon.opacity(0.12))
                .clipShape(Capsule())
            }

            Text("This pour was selected to match your current vibe. Tap \"My Mood\" to refine.")
                .font(UNPFontStyle.caption(12))
                .foregroundStyle(UNPColor.textMuted)
        }
        .padding(UNPSpacing.md)
        .unpCard()
    }

    private func toolbarChip(_ label: String, icon: String, accent: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 3) {
                Image(systemName: icon).font(.system(size: 11, weight: .semibold))
                Text(label).font(UNPFontStyle.caption())
            }
            .foregroundStyle(accent ? .black : UNPColor.neonLight)
            .padding(.horizontal, UNPSpacing.sm)
            .padding(.vertical, 6)
            .background(accent ? UNPColor.emberGradient : LinearGradient(colors: [UNPColor.neon.opacity(0.18), UNPColor.neon.opacity(0.12)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(Capsule())
        }
    }

    private var heroCard: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: UNPRadius.extraLarge)
                .fill(UNPColor.surface)
                .frame(height: 220)

            ZStack {
                RoundedRectangle(cornerRadius: UNPRadius.extraLarge)
                    .fill(
                        LinearGradient(
                            colors: [UNPColor.ember.opacity(0.18), UNPColor.neon.opacity(0.1), UNPColor.surface],
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                        )
                    )
                Image(systemName: "wineglass.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(UNPColor.ember.opacity(0.12))
                    .offset(x: 80, y: -10)
            }
            .frame(height: 220)
            .clipShape(RoundedRectangle(cornerRadius: UNPRadius.extraLarge))

            LinearGradient(
                colors: [UNPColor.surface.opacity(0.98), .clear],
                startPoint: .bottom,
                endPoint: UnitPoint(x: 0.5, y: 0.35)
            )
            .frame(height: 220)
            .clipShape(RoundedRectangle(cornerRadius: UNPRadius.extraLarge))

            VStack(alignment: .leading, spacing: 6) {
                LabelChip(text: "BEVERAGE OF THE DAY", icon: "sparkles", color: UNPColor.ember)
                Text("Midnight Old Fashioned")
                    .font(UNPFontStyle.display(24))
                    .foregroundStyle(UNPColor.textPrimary)
                Text("Smoked bourbon, demerara, aromatic bitters — Detroit slow pour.")
                    .font(UNPFontStyle.body(13))
                    .foregroundStyle(UNPColor.textSecondary)
                    .lineLimit(2)
                HStack(spacing: UNPSpacing.sm) {
                    LabelChip(text: "Bourbon", color: UNPColor.ember)
                    LabelChip(text: "Stirred", color: UNPColor.textSecondary)
                    StarRating(rating: 4.8, starCount: 1, size: 11)
                }
            }
            .padding(UNPSpacing.lg)
        }
        .unpShadow(UNPShadow.card)
    }

    private var recipeCard: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            Text("Full Recipe")
                .font(UNPFontStyle.label())
                .foregroundStyle(UNPColor.textMuted)
                .textCase(.uppercase)
                .tracking(0.5)
            Text("Stir over ice for 30 seconds. Strain over a single large cube. Express orange oils from peel and garnish.")
                .font(UNPFontStyle.body())
                .foregroundStyle(UNPColor.textSecondary)
        }
        .padding(UNPSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .unpCard()
    }

    private var ingredientsCard: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.md) {
            SectionHeader(title: "Ingredients")
            VStack(spacing: UNPSpacing.sm) {
                ingredientRow("2 oz", "Bourbon")
                ingredientRow("0.25 oz", "Demerara syrup")
                ingredientRow("2 dashes", "Aromatic bitters")
                ingredientRow("1", "Orange peel")
            }
        }
        .padding(UNPSpacing.md)
        .unpCard()
    }

    private func ingredientRow(_ measure: String, _ ingredient: String) -> some View {
        HStack(spacing: UNPSpacing.md) {
            Text(measure)
                .font(UNPFontStyle.caption())
                .foregroundStyle(UNPColor.ember)
                .frame(width: 60, alignment: .leading)
            Text(ingredient)
                .font(UNPFontStyle.body())
                .foregroundStyle(UNPColor.textPrimary)
            Spacer()
        }
    }

    private var methodCard: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.md) {
            SectionHeader(title: "Method")
            ForEach(Array(methodSteps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: UNPSpacing.md) {
                    Text("\(index + 1)")
                        .font(UNPFontStyle.label())
                        .foregroundStyle(.black)
                        .frame(width: 24, height: 24)
                        .background(UNPColor.emberGradient)
                        .clipShape(Circle())
                    Text(step)
                        .font(UNPFontStyle.body())
                        .foregroundStyle(UNPColor.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(UNPSpacing.md)
        .unpCard()
    }

    private var methodSteps: [String] {
        [
            "Combine bourbon, demerara syrup, and bitters in a mixing glass.",
            "Add ice and stir for 30 seconds until well-chilled.",
            "Strain over a single large cube in a rocks glass.",
            "Express orange peel oils over the glass and use as garnish."
        ]
    }

    private var pairingCard: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            SectionHeader(title: "Pairing")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: UNPSpacing.sm) {
                    pairingChip(icon: "fork.knife", label: "Sharp cheddar")
                    pairingChip(icon: "square.fill", label: "Dark chocolate")
                    pairingChip(icon: "music.note", label: "Live jazz")
                }
            }
        }
        .padding(UNPSpacing.md)
        .unpCard()
    }

    private func pairingChip(icon: String, label: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 11)).foregroundStyle(UNPColor.ember)
            Text(label).font(UNPFontStyle.caption()).foregroundStyle(UNPColor.textSecondary)
        }
        .padding(.horizontal, UNPSpacing.sm)
        .padding(.vertical, UNPSpacing.xs)
        .background(UNPColor.surfaceElevated)
        .clipShape(Capsule())
    }

    private var relatedCard: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            SectionHeader(title: "Related beverages")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: UNPSpacing.sm) {
                    ForEach(relatedBeverages) { beverage in
                        BeverageCard(beverage: beverage)
                            .frame(width: 160)
                    }
                }
            }
        }
    }

    private var saveBar: some View {
        HStack(spacing: UNPSpacing.md) {
            VStack(alignment: .leading, spacing: 1) {
                Text("Midnight Old Fashioned")
                    .font(UNPFontStyle.heading(14))
                    .foregroundStyle(UNPColor.textPrimary)
                Text("Stir · 5 min · 4 ingredients")
                    .font(UNPFontStyle.caption(12))
                    .foregroundStyle(UNPColor.textMuted)
            }
            Spacer()
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { isSaved.toggle() }
            } label: {
                HStack(spacing: UNPSpacing.xs) {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 14))
                    Text(isSaved ? "Saved" : "Save Recipe")
                        .font(UNPFontStyle.heading(14))
                }
                .foregroundStyle(.black)
                .padding(.horizontal, UNPSpacing.md)
                .padding(.vertical, 12)
                .background(isSaved ? LinearGradient(colors: [UNPColor.azure, UNPColor.azure], startPoint: .top, endPoint: .bottom) : UNPColor.emberGradient)
                .clipShape(RoundedRectangle(cornerRadius: UNPRadius.medium))
            }
        }
        .padding(.horizontal, UNPSpacing.md)
        .padding(.vertical, UNPSpacing.sm)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: UNPRadius.extraLarge))
    }
}
