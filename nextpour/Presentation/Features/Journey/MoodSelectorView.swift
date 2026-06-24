import SwiftUI

enum UserMood: String, CaseIterable, Identifiable {
    case happy, relaxed, energetic, romantic, celebratory, sophisticated

    var id: String { rawValue }
    var label: String { rawValue.capitalized }
    var icon: String {
        switch self {
        case .happy: return "face.smiling"
        case .relaxed: return "figure.mind.and.body"
        case .energetic: return "bolt.fill"
        case .romantic: return "heart.fill"
        case .celebratory: return "party.popper.fill"
        case .sophisticated: return "crown.fill"
        }
    }
    var subtitle: String {
        switch self {
        case .happy: return "Feeling joyful and upbeat"
        case .relaxed: return "Want to unwind and chat"
        case .energetic: return "Ready to party and have fun"
        case .romantic: return "Looking for something intimate"
        case .celebratory: return "It's a special occasion"
        case .sophisticated: return "Elevated vibes only"
        }
    }
}

struct DrinkSuggestion {
    let name: String
    let description: String
    let tags: [String]
    let icon: String
}

private func suggestDrink(mood: UserMood, alcoholic: Bool) -> DrinkSuggestion {
    if alcoholic {
        switch mood {
        case .energetic, .celebratory:
            return DrinkSuggestion(
                name: "Aperol Spritz",
                description: "Light, fizzy, and festive — perfect for high-energy nights.",
                tags: ["Bubbly", "Low ABV", "Easy sipping"],
                icon: "wineglass"
            )
        case .romantic, .sophisticated:
            return DrinkSuggestion(
                name: "Midnight Old Fashioned",
                description: "Smoked bourbon, demerara, aromatic bitters — slow and intentional.",
                tags: ["Stirred", "Bourbon", "Classic"],
                icon: "wineglass.fill"
            )
        case .relaxed:
            return DrinkSuggestion(
                name: "Negroni Sbagliato",
                description: "Bittersweet and bubbly — a relaxed pour for easy evenings.",
                tags: ["Bitter", "Sparkling", "Aperitivo"],
                icon: "wineglass"
            )
        case .happy:
            return DrinkSuggestion(
                name: "Whiskey Highball",
                description: "Bright and refreshing — lifts the mood with every sip.",
                tags: ["Refreshing", "Whiskey", "Highball"],
                icon: "wineglass.fill"
            )
        }
    } else {
        switch mood {
        case .energetic, .celebratory:
            return DrinkSuggestion(
                name: "Sparkling Yuzu Lemonade",
                description: "Citrus-forward and effervescent — all the celebration, zero ABV.",
                tags: ["Sparkling", "Citrus", "Zero ABV"],
                icon: "drop.fill"
            )
        case .romantic, .sophisticated:
            return DrinkSuggestion(
                name: "Rose & Elderflower Spritz",
                description: "Floral, delicate, and beautiful — a sophisticated zero-proof sip.",
                tags: ["Floral", "Elegant", "Zero ABV"],
                icon: "drop"
            )
        case .relaxed, .happy:
            return DrinkSuggestion(
                name: "Cucumber Mint Cooler",
                description: "Cool, clean, and calming — made for winding down.",
                tags: ["Refreshing", "Herbal", "Zero ABV"],
                icon: "leaf.fill"
            )
        }
    }
}

struct MoodSelectorView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedMood: UserMood?
    let onContinue: (UserMood) -> Void

    @State private var step: Step = .mood
    @State private var isAlcoholic: Bool? = nil

    enum Step { case mood, preference, suggestion }

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 0) {
            DrawerHandle()

            // Step indicator
            HStack(spacing: UNPSpacing.xs) {
                ForEach(0..<3) { i in
                    Capsule()
                        .fill(stepIndex >= i ? UNPColor.ember : UNPColor.surface)
                        .frame(maxWidth: stepIndex == i ? .infinity : 20)
                        .frame(height: 3)
                        .animation(.spring(response: 0.3), value: step)
                }
            }
            .padding(.horizontal, UNPSpacing.lg)
            .padding(.top, UNPSpacing.sm)

            switch step {
            case .mood:
                moodStep
            case .preference:
                preferenceStep
            case .suggestion:
                if let mood = selectedMood, let alcoholic = isAlcoholic {
                    suggestionStep(suggestion: suggestDrink(mood: mood, alcoholic: alcoholic))
                }
            }
        }
        .background(UNPColor.background)
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: step)
    }

    private var stepIndex: Int {
        switch step {
        case .mood: return 0
        case .preference: return 1
        case .suggestion: return 2
        }
    }

    // MARK: - Step 1: Mood

    private var moodStep: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.lg) {
            VStack(alignment: .leading, spacing: UNPSpacing.xs) {
                Text("How are you feeling?")
                    .font(UNPFontStyle.display(22))
                    .foregroundStyle(UNPColor.textPrimary)
                Text("Pick the mood that best describes you right now.")
                    .font(UNPFontStyle.body(14))
                    .foregroundStyle(UNPColor.textSecondary)
            }
            .padding(.top, UNPSpacing.md)

            LazyVGrid(columns: columns, spacing: UNPSpacing.sm) {
                ForEach(UserMood.allCases) { mood in
                    MoodTile(
                        mood: mood,
                        isSelected: selectedMood == mood,
                        onTap: { selectedMood = mood }
                    )
                }
            }

            HStack {
                Spacer()
                Button {
                    withAnimation { step = .preference }
                } label: {
                    Text("Continue")
                        .font(UNPFontStyle.heading(15))
                        .foregroundStyle(.black)
                        .padding(.horizontal, UNPSpacing.xl)
                        .padding(.vertical, UNPSpacing.sm)
                        .background(selectedMood == nil ? UNPColor.textMuted : UNPColor.copper)
                        .clipShape(Capsule())
                }
                .disabled(selectedMood == nil)
            }
        }
        .padding(.horizontal, UNPSpacing.lg)
        .padding(.bottom, UNPSpacing.xl)
    }

    // MARK: - Step 2: Alcoholic preference

    private var preferenceStep: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.lg) {
            VStack(alignment: .leading, spacing: UNPSpacing.xs) {
                Text("What are you drinking?")
                    .font(UNPFontStyle.display(22))
                    .foregroundStyle(UNPColor.textPrimary)
                Text("We'll suggest the perfect pour based on your vibe.")
                    .font(UNPFontStyle.body(14))
                    .foregroundStyle(UNPColor.textSecondary)
            }
            .padding(.top, UNPSpacing.md)

            // Selected mood chip
            if let mood = selectedMood {
                HStack(spacing: 4) {
                    Image(systemName: mood.icon).font(.system(size: 11))
                    Text(mood.label).font(UNPFontStyle.label())
                }
                .foregroundStyle(UNPColor.neonLight)
                .padding(.horizontal, UNPSpacing.sm)
                .padding(.vertical, UNPSpacing.xs)
                .background(UNPColor.neon.opacity(0.12))
                .clipShape(Capsule())
            }

            VStack(spacing: UNPSpacing.sm) {
                preferenceCard(
                    title: "Alcoholic",
                    subtitle: "Cocktails, spirits, wine & beer",
                    icon: "wineglass.fill",
                    color: UNPColor.ember,
                    isSelected: isAlcoholic == true
                ) { isAlcoholic = true }

                preferenceCard(
                    title: "Non-Alcoholic",
                    subtitle: "Mocktails, sodas & zero-proof sips",
                    icon: "drop.fill",
                    color: UNPColor.azure,
                    isSelected: isAlcoholic == false
                ) { isAlcoholic = false }
            }

            HStack {
                Button {
                    withAnimation { step = .mood }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left").font(.system(size: 11))
                        Text("Back")
                    }
                    .font(UNPFontStyle.caption())
                    .foregroundStyle(UNPColor.textMuted)
                }
                Spacer()
                Button {
                    withAnimation { step = .suggestion }
                } label: {
                    Text("Suggest a Drink")
                        .font(UNPFontStyle.heading(15))
                        .foregroundStyle(.black)
                        .padding(.horizontal, UNPSpacing.xl)
                        .padding(.vertical, UNPSpacing.sm)
                        .background(isAlcoholic == nil ? UNPColor.textMuted : UNPColor.copper)
                        .clipShape(Capsule())
                }
                .disabled(isAlcoholic == nil)
            }
        }
        .padding(.horizontal, UNPSpacing.lg)
        .padding(.bottom, UNPSpacing.xl)
    }

    private func preferenceCard(title: String, subtitle: String, icon: String, color: Color, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: UNPSpacing.md) {
                ZStack {
                    Circle()
                        .fill(isSelected ? color.opacity(0.2) : UNPColor.surface)
                        .frame(width: 48, height: 48)
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundStyle(isSelected ? color : UNPColor.textMuted)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(UNPFontStyle.heading(16))
                        .foregroundStyle(UNPColor.textPrimary)
                    Text(subtitle)
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.textSecondary)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(color)
                }
            }
            .padding(UNPSpacing.md)
            .background(isSelected ? color.opacity(0.08) : UNPColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: UNPRadius.large))
            .overlay(
                RoundedRectangle(cornerRadius: UNPRadius.large)
                    .stroke(isSelected ? color.opacity(0.5) : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.25), value: isSelected)
    }

    // MARK: - Step 3: Drink suggestion

    private func suggestionStep(suggestion: DrinkSuggestion) -> some View {
        VStack(alignment: .leading, spacing: UNPSpacing.lg) {
            VStack(alignment: .leading, spacing: UNPSpacing.xs) {
                Text("Your Pour")
                    .font(UNPFontStyle.display(22))
                    .foregroundStyle(UNPColor.textPrimary)
                Text("Based on your mood and preference.")
                    .font(UNPFontStyle.body(14))
                    .foregroundStyle(UNPColor.textSecondary)
            }
            .padding(.top, UNPSpacing.md)

            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: UNPRadius.extraLarge)
                    .fill(
                        LinearGradient(
                            colors: [UNPColor.ember.opacity(0.2), UNPColor.surface],
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                        )
                    )
                    .frame(height: 160)
                    .overlay(
                        Image(systemName: suggestion.icon)
                            .font(.system(size: 80))
                            .foregroundStyle(UNPColor.ember.opacity(0.15))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            .padding(UNPSpacing.lg)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: UNPRadius.extraLarge)
                            .stroke(UNPColor.ember.opacity(0.25), lineWidth: 1)
                    )

                VStack(alignment: .leading, spacing: UNPSpacing.xs) {
                    LabelChip(text: "SUGGESTED FOR YOU", icon: "sparkles", color: UNPColor.ember)
                    Text(suggestion.name)
                        .font(UNPFontStyle.display(20))
                        .foregroundStyle(UNPColor.textPrimary)
                    Text(suggestion.description)
                        .font(UNPFontStyle.body(13))
                        .foregroundStyle(UNPColor.textSecondary)
                        .lineLimit(2)
                }
                .padding(UNPSpacing.lg)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: UNPSpacing.xs) {
                    ForEach(suggestion.tags, id: \.self) { tag in
                        Text(tag)
                            .font(UNPFontStyle.label())
                            .foregroundStyle(UNPColor.textSecondary)
                            .padding(.horizontal, UNPSpacing.sm)
                            .padding(.vertical, UNPSpacing.xs)
                            .background(UNPColor.surfaceElevated)
                            .clipShape(Capsule())
                    }
                }
            }

            HStack {
                Button {
                    withAnimation { step = .preference }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left").font(.system(size: 11))
                        Text("Back")
                    }
                    .font(UNPFontStyle.caption())
                    .foregroundStyle(UNPColor.textMuted)
                }
                Spacer()
                Button {
                    if let mood = selectedMood {
                        onContinue(mood)
                    }
                    dismiss()
                } label: {
                    Text("Let's Pour")
                        .font(UNPFontStyle.heading(15))
                        .foregroundStyle(.black)
                        .padding(.horizontal, UNPSpacing.xl)
                        .padding(.vertical, UNPSpacing.sm)
                        .background(UNPColor.emberGradient)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.horizontal, UNPSpacing.lg)
        .padding(.bottom, UNPSpacing.xl)
    }
}

private struct MoodTile: View {
    let mood: UserMood
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: UNPSpacing.sm) {
                Image(systemName: mood.icon)
                    .font(.system(size: 28))
                    .foregroundStyle(isSelected ? .black : UNPColor.textSecondary)
                VStack(spacing: 2) {
                    Text(mood.label)
                        .font(UNPFontStyle.heading(13))
                        .foregroundStyle(isSelected ? .black : UNPColor.textPrimary)
                    Text(mood.subtitle)
                        .font(UNPFontStyle.label())
                        .foregroundStyle(isSelected ? .black.opacity(0.6) : UNPColor.textMuted)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(UNPSpacing.md)
            .frame(maxWidth: .infinity, minHeight: 110)
            .background(isSelected ? UNPColor.violet : UNPColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: UNPRadius.large))
            .animation(.spring(response: 0.25), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}
