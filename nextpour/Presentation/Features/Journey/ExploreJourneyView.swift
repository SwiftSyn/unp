import SwiftUI

struct ExploreJourneyView: View {
    let initialEvent: Event?
    @Environment(\.dismiss) private var dismiss
    @State private var showMapListView = false
    @State private var showUploadEvent = false
    @State private var selectedEvent: Event?
    @State private var isRSVPd = false

    init(initialEvent: Event? = nil) {
        self.initialEvent = initialEvent
        _selectedEvent = State(initialValue: initialEvent)
    }

    private var displayEvent: Event? { selectedEvent ?? initialEvent }

    var body: some View {
        ZStack(alignment: .bottom) {
            UNPColor.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: UNPSpacing.lg) {
                    if let event = displayEvent {
                        eventHero(event)
                        eventActions(event)
                        eventDetails(event)
                        attendeesSection
                        relatedSection
                    } else {
                        emptyState
                    }
                    Spacer().frame(height: 80)
                }
            }

            if let event = displayEvent {
                rsvpBar(event)
                    .padding(.horizontal, UNPSpacing.md)
                    .padding(.bottom, UNPSpacing.md)
            }
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
                Text("The Explore")
                    .font(UNPFontStyle.heading(16))
                    .foregroundStyle(UNPColor.textPrimary)
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: UNPSpacing.xs) {
                    toolbarChip(label: "Events", icon: "calendar", accent: false, action: { showMapListView = true })
                    toolbarChip(label: "Upload Event", icon: "plus", accent: true, action: { showUploadEvent = true })
                }
            }
        }
        .navigationDestination(isPresented: $showMapListView) {
            EventMapListView(onSelectEvent: { event in selectedEvent = event })
        }
        .sheet(isPresented: $showUploadEvent) {
            UploadEventSheet()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationBackground(UNPColor.background)
                .presentationCornerRadius(UNPRadius.extraLarge)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isRSVPd)
    }

    private func toolbarChip(label: String, icon: String, accent: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon).font(.system(size: 11, weight: .semibold))
                Text(label).font(UNPFontStyle.caption())
            }
            .foregroundStyle(accent ? .black : UNPColor.azure)
            .padding(.horizontal, UNPSpacing.sm)
            .padding(.vertical, 6)
            .background(accent ? UNPColor.emberGradient : LinearGradient(colors: [UNPColor.azure.opacity(0.15), UNPColor.azure.opacity(0.08)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(Capsule())
        }
    }

    private func eventHero(_ event: Event) -> some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: UNPRadius.extraLarge)
                .fill(UNPColor.surface)
                .frame(height: 220)

            ZStack {
                RoundedRectangle(cornerRadius: UNPRadius.extraLarge)
                    .fill(
                        LinearGradient(
                            colors: [UNPColor.azure.opacity(0.15), UNPColor.neon.opacity(0.08), UNPColor.surface],
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                        )
                    )
                Image(systemName: "map.fill")
                    .font(.system(size: 90))
                    .foregroundStyle(UNPColor.azure.opacity(0.1))
                    .offset(x: 70, y: -15)
            }
            .frame(height: 220)
            .clipShape(RoundedRectangle(cornerRadius: UNPRadius.extraLarge))

            LinearGradient(
                colors: [UNPColor.surface.opacity(0.98), .clear],
                startPoint: .bottom,
                endPoint: UnitPoint(x: 0.5, y: 0.4)
            )
            .frame(height: 220)
            .clipShape(RoundedRectangle(cornerRadius: UNPRadius.extraLarge))

            VStack(alignment: .leading, spacing: 5) {
                LabelChip(text: event.category.displayName.uppercased(), icon: "location.fill", color: UNPColor.azure)
                Text(event.title)
                    .font(UNPFontStyle.display(24))
                    .foregroundStyle(UNPColor.textPrimary)
                HStack(spacing: UNPSpacing.xs) {
                    Text(event.venueName)
                        .font(UNPFontStyle.heading(14))
                        .foregroundStyle(UNPColor.ember)
                    Text("·")
                        .foregroundStyle(UNPColor.textMuted)
                    Text(event.date.formatted(date: .omitted, time: .shortened))
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.textSecondary)
                }
            }
            .padding(UNPSpacing.lg)
        }
        .padding(.horizontal, UNPSpacing.md)
    }

    private func eventActions(_ event: Event) -> some View {
        HStack(spacing: UNPSpacing.sm) {
            actionChip("Save", icon: "bookmark")
            actionChip("Share", icon: "square.and.arrow.up")
            Spacer()
            Button {} label: {
                HStack(spacing: 5) {
                    Image(systemName: "person.3.fill").font(.system(size: 12))
                    Text("Community").font(UNPFontStyle.caption())
                }
                .foregroundStyle(UNPColor.textPrimary)
                .padding(.horizontal, UNPSpacing.md)
                .padding(.vertical, UNPSpacing.sm)
                .background(UNPColor.surface)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(UNPColor.neon.opacity(0.3), lineWidth: 1))
            }
        }
        .padding(.horizontal, UNPSpacing.md)
    }

    private func actionChip(_ label: String, icon: String) -> some View {
        Button {} label: {
            HStack(spacing: 4) {
                Image(systemName: icon).font(.system(size: 12))
                Text(label).font(UNPFontStyle.caption())
            }
            .foregroundStyle(UNPColor.textSecondary)
            .padding(.horizontal, UNPSpacing.md)
            .padding(.vertical, UNPSpacing.sm)
            .background(UNPColor.surface)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private func eventDetails(_ event: Event) -> some View {
        VStack(spacing: UNPSpacing.sm) {
            detailRow(icon: "calendar", label: event.date.formatted(date: .complete, time: .omitted), color: UNPColor.ember)
            Divider().background(UNPColor.surfaceElevated)
            detailRow(icon: "clock", label: event.date.formatted(date: .omitted, time: .shortened), color: UNPColor.ember)
            Divider().background(UNPColor.surfaceElevated)
            detailRow(icon: "location.fill", label: event.venueName + " · " + event.venueAddress, color: UNPColor.azure)
            if !event.description.isEmpty {
                Divider().background(UNPColor.surfaceElevated)
                VStack(alignment: .leading, spacing: UNPSpacing.sm) {
                    Text("About this event")
                        .font(UNPFontStyle.label())
                        .foregroundStyle(UNPColor.textMuted)
                        .textCase(.uppercase)
                        .tracking(0.5)
                    Text(event.description)
                        .font(UNPFontStyle.body(14))
                        .foregroundStyle(UNPColor.textSecondary)
                }
                .padding(.horizontal, UNPSpacing.md)
                .padding(.vertical, UNPSpacing.sm)
            }
        }
        .padding(.vertical, UNPSpacing.sm)
        .unpCard()
        .padding(.horizontal, UNPSpacing.md)
    }

    private func detailRow(icon: String, label: String, color: Color) -> some View {
        HStack(spacing: UNPSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundStyle(color)
                .frame(width: 24)
            Text(label)
                .font(UNPFontStyle.body(14))
                .foregroundStyle(UNPColor.textSecondary)
                .lineLimit(1)
        }
        .padding(.horizontal, UNPSpacing.md)
        .padding(.vertical, UNPSpacing.sm)
    }

    private let mockAttendees: [User] = [
        User(id: "a1", name: "Miranda L.", email: "", role: .consumer, avatarURL: nil, bio: "", isAmbassador: true, rewardPoints: 820, rewardTier: .gold),
        User(id: "a2", name: "Chef Andre", email: "", role: .bartender, avatarURL: nil, bio: "", isAmbassador: false, rewardPoints: 430, rewardTier: .bronze)
    ]

    private var attendeesSection: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            HStack {
                Text("Attending")
                    .font(UNPFontStyle.heading())
                    .foregroundStyle(UNPColor.textPrimary)
                Spacer()
                Text("23 going")
                    .font(UNPFontStyle.caption())
                    .foregroundStyle(UNPColor.textMuted)
            }
            HStack(spacing: -12) {
                ForEach(["M", "J", "A", "S", "K"], id: \.self) { initial in
                    AvatarView(name: initial, imageURL: nil, size: 36)
                        .overlay(Circle().stroke(UNPColor.background, lineWidth: 2))
                }
                ZStack {
                    Circle()
                        .fill(UNPColor.surfaceElevated)
                        .frame(width: 36, height: 36)
                        .overlay(Circle().stroke(UNPColor.background, lineWidth: 2))
                    Text("+18")
                        .font(UNPFontStyle.label())
                        .foregroundStyle(UNPColor.textSecondary)
                }
            }
            Divider().background(UNPColor.surfaceElevated)
            ForEach(mockAttendees) { user in
                UserRow(user: user)
            }
        }
        .padding(UNPSpacing.md)
        .unpCard()
        .padding(.horizontal, UNPSpacing.md)
    }

    private var relatedSection: some View {
        VStack(alignment: .leading, spacing: UNPSpacing.sm) {
            SectionHeader(title: "Related")
                .padding(.horizontal, UNPSpacing.md)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: UNPSpacing.sm) {
                    relatedChip(icon: "wineglass.fill", label: "Pour · Midnight Old Fashioned", color: UNPColor.ember)
                    relatedChip(icon: "wineglass.fill", label: "Pour · Riverfront Spritz", color: UNPColor.ember)
                    relatedChip(icon: "moon.fill", label: "Tonight's Move", color: UNPColor.neon)
                }
                .padding(.horizontal, UNPSpacing.md)
            }
        }
    }

    private func relatedChip(icon: String, label: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 11)).foregroundStyle(color)
            Text(label).font(UNPFontStyle.caption(12)).foregroundStyle(UNPColor.textSecondary)
        }
        .padding(.horizontal, UNPSpacing.sm)
        .padding(.vertical, UNPSpacing.xs)
        .background(UNPColor.surface)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(color.opacity(0.2), lineWidth: 1))
    }

    private func rsvpBar(_ event: Event) -> some View {
        HStack(spacing: UNPSpacing.md) {
            VStack(alignment: .leading, spacing: 2) {
                Text("How to attend")
                    .font(UNPFontStyle.label())
                    .foregroundStyle(UNPColor.textMuted)
                Text("RSVP in app, arrive 15 min early")
                    .font(UNPFontStyle.caption(12))
                    .foregroundStyle(UNPColor.textSecondary)
            }
            Spacer()
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isRSVPd.toggle()
                }
            } label: {
                HStack(spacing: UNPSpacing.xs) {
                    Image(systemName: isRSVPd ? "checkmark.circle.fill" : "plus.circle.fill")
                        .font(.system(size: 16))
                    Text(isRSVPd ? "RSVP'd" : "RSVP")
                        .font(UNPFontStyle.heading(15))
                }
                .foregroundStyle(isRSVPd ? UNPColor.azure : .black)
                .padding(.horizontal, UNPSpacing.lg)
                .padding(.vertical, 13)
                .background(isRSVPd ? LinearGradient(colors: [UNPColor.azure.opacity(0.15), UNPColor.azure.opacity(0.15)], startPoint: .top, endPoint: .bottom) : UNPColor.emberGradient)
                .clipShape(RoundedRectangle(cornerRadius: UNPRadius.medium))
            }
        }
        .padding(.horizontal, UNPSpacing.md)
        .padding(.vertical, UNPSpacing.sm)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: UNPRadius.extraLarge))
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Event Selected", systemImage: "map")
        } description: {
            Text("Tap \"Events\" above to browse what's happening near you.")
        } actions: {
            Button("Browse Events") { showMapListView = true }
                .font(UNPFontStyle.heading(14))
                .foregroundStyle(.black)
                .padding(.horizontal, UNPSpacing.xl)
                .padding(.vertical, UNPSpacing.sm)
                .background(UNPColor.emberGradient)
                .clipShape(Capsule())
        }
        .padding(.top, UNPSpacing.xxl)
    }
}

private struct UploadEventSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var venue = ""
    @State private var description = ""
    @State private var isLoading = false
    @State private var showSuccess = false

    var body: some View {
        NavigationStack {
            if showSuccess {
                SuccessStateView(title: "Event Uploaded", message: "Your event is now live on UNP.", onDone: { dismiss() })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(UNPColor.background)
            } else {
                Form {
                    Section("Event Details") {
                        TextField("Event title", text: $title)
                            .listRowBackground(UNPColor.surface)
                            .foregroundStyle(UNPColor.textPrimary)
                        TextField("Venue name", text: $venue)
                            .listRowBackground(UNPColor.surface)
                            .foregroundStyle(UNPColor.textPrimary)
                        TextField("Description", text: $description, axis: .vertical)
                            .lineLimit(3, reservesSpace: true)
                            .listRowBackground(UNPColor.surface)
                            .foregroundStyle(UNPColor.textPrimary)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(UNPColor.background)
                .navigationTitle("Upload Event")
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
                                    .fontWeight(.semibold)
                            }
                        }
                        .disabled(title.isEmpty || isLoading)
                    }
                }
            }
        }
    }
}
