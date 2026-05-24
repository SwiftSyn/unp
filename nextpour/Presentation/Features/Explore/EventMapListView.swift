import SwiftUI
import MapKit

struct EventMapListView: View {
    let onSelectEvent: (Event) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ExploreViewModel
    @State private var showMap = true
    @State private var timeFilter: TimeFilter = .night
    @State private var selectedCategory: EventCategory? = nil
    @State private var searchText = ""
    @State private var showAddStory = false
    @State private var showUploadEvent = false
    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 42.3314, longitude: -83.0458),
            span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        )
    )

    enum TimeFilter: String, CaseIterable {
        case day = "Day"
        case night = "Night"
        case lateNight = "Late Night"
    }

    init(onSelectEvent: @escaping (Event) -> Void) {
        self.onSelectEvent = onSelectEvent
        let di = DIContainer.shared
        _viewModel = State(initialValue: ExploreViewModel(
            fetchEventsUseCase: di.makeFetchEventsUseCase(),
            fetchVenuesUseCase: di.makeFetchVenuesUseCase(),
            fetchBartendersUseCase: di.makeFetchBartendersUseCase()
        ))
    }

    var body: some View {
        VStack(spacing: 0) {
            storiesRow
                .padding(.vertical, UNPSpacing.sm)
                .background(UNPColor.background)

            controlsRow
                .padding(.horizontal, UNPSpacing.md)
                .padding(.bottom, UNPSpacing.sm)
                .background(UNPColor.background)

            mapOrListBody
        }
        .background(UNPColor.background)
        .navigationBarBackButtonHidden()
        .navigationTitle("Events")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Label("Back", systemImage: "chevron.left")
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(UNPColor.ember)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button { showUploadEvent = true } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "plus").font(.system(size: 12, weight: .semibold))
                        Text("Upload").font(UNPFontStyle.caption())
                    }
                    .foregroundStyle(.black)
                    .padding(.horizontal, UNPSpacing.sm)
                    .padding(.vertical, 6)
                    .background(UNPColor.emberGradient)
                    .clipShape(Capsule())
                }
            }
        }
        .task { await viewModel.loadData() }
        .sheet(isPresented: $showAddStory) {
            AddStorySheet()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationBackground(UNPColor.background)
                .presentationCornerRadius(UNPRadius.extraLarge)
        }
        .sheet(isPresented: $showUploadEvent) {
            UploadEventFromMapSheet(onSelectEvent: onSelectEvent)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationBackground(UNPColor.background)
                .presentationCornerRadius(UNPRadius.extraLarge)
        }
    }

    private var storiesRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: UNPSpacing.md) {
                StoryBubble(name: "Your Story", isAdd: true) { showAddStory = true }
                ForEach(["miranda.L", "chef_andre", "maddy_mi", "antonia", "j_rivers"], id: \.self) { name in
                    StoryBubble(name: name, isAdd: false) {}
                }
            }
            .padding(.horizontal, UNPSpacing.md)
        }
    }

    private var filteredEvents: [Event] {
        viewModel.events.filter { event in
            let matchesCategory = selectedCategory == nil || event.category == selectedCategory
            let matchesSearch = searchText.isEmpty ||
                event.title.localizedCaseInsensitiveContains(searchText) ||
                event.venueName.localizedCaseInsensitiveContains(searchText)
            return matchesCategory && matchesSearch
        }
    }

    private var controlsRow: some View {
        VStack(spacing: UNPSpacing.sm) {
            HStack(spacing: UNPSpacing.sm) {
                mapListToggle
                ScrollView(.horizontal, showsIndicators: false) {
                    ToggleChipGroup(
                        options: TimeFilter.allCases,
                        selection: $timeFilter,
                        label: { $0.rawValue }
                    )
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: UNPSpacing.sm) {
                    categoryChip(nil, label: "All")
                    ForEach(EventCategory.allCases, id: \.self) { cat in
                        categoryChip(cat, label: cat.displayName)
                    }
                }
            }
        }
    }

    private func categoryChip(_ category: EventCategory?, label: String) -> some View {
        let isSelected = selectedCategory == category
        return Button {
            withAnimation(.spring(response: 0.25)) {
                selectedCategory = isSelected ? nil : category
            }
        } label: {
            Text(label)
                .font(UNPFontStyle.caption())
                .foregroundStyle(isSelected ? .black : UNPColor.textSecondary)
                .padding(.horizontal, UNPSpacing.sm)
                .padding(.vertical, 6)
                .background(isSelected ? UNPColor.emberGradient : LinearGradient(colors: [UNPColor.surface, UNPColor.surface], startPoint: .top, endPoint: .bottom))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private var mapListToggle: some View {
        HStack(spacing: 0) {
            ForEach(["Map", "List"], id: \.self) { mode in
                let isSelected = showMap == (mode == "Map")
                Button {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                        showMap = (mode == "Map")
                    }
                } label: {
                    Text(mode)
                        .font(UNPFontStyle.caption())
                        .foregroundStyle(isSelected ? .black : UNPColor.textSecondary)
                        .padding(.horizontal, UNPSpacing.md)
                        .padding(.vertical, 7)
                        .background(isSelected ? UNPColor.emberGradient : LinearGradient(colors: [.clear, .clear], startPoint: .top, endPoint: .bottom))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(UNPColor.surface)
        .clipShape(Capsule())
    }

    @ViewBuilder
    private var mapOrListBody: some View {
        if showMap {
            mapBody
        } else {
            VStack(spacing: 0) {
                SearchBarView(text: $searchText, placeholder: "Search events or venues…")
                    .padding(.horizontal, UNPSpacing.md)
                    .padding(.bottom, UNPSpacing.sm)
                    .background(UNPColor.background)
                listBody
            }
        }
    }

    private var mapBody: some View {
        Map(position: $cameraPosition) {
            ForEach(filteredEvents) { event in
                Annotation(event.venueName, coordinate: CLLocationCoordinate2D(
                    latitude: 42.3314 + Double.random(in: -0.04...0.04),
                    longitude: -83.0458 + Double.random(in: -0.04...0.04)
                )) {
                    MapEventPin(event: event) {
                        onSelectEvent(event)
                        dismiss()
                    }
                }
            }
        }
        .colorScheme(.dark)
        .ignoresSafeArea(edges: .bottom)
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
    }

    private var listBody: some View {
        Group {
            if viewModel.isLoading {
                ScrollView {
                    VStack(spacing: UNPSpacing.sm) {
                        ForEach(0..<5, id: \.self) { _ in SkeletonRowView() }
                    }
                    .padding(UNPSpacing.md)
                }
            } else if filteredEvents.isEmpty {
                ContentUnavailableView {
                    Label("No Events Found", systemImage: "calendar.badge.exclamationmark")
                } description: {
                    Text("No events match your current filters.")
                }
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: UNPSpacing.sm) {
                        ForEach(filteredEvents) { event in
                            EventCard(event: event) {
                                onSelectEvent(event)
                                dismiss()
                            }
                        }
                    }
                    .padding(UNPSpacing.md)
                }
            }
        }
    }
}

private struct MapEventPin: View {
    let event: Event
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 3) {
                ZStack {
                    Circle()
                        .fill(UNPColor.surface)
                        .frame(width: 40, height: 40)
                        .unpShadow(UNPShadow.card)
                    Image(systemName: "wineglass.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(UNPColor.ember)
                }
                Text(event.venueName)
                    .font(UNPFontStyle.label())
                    .foregroundStyle(UNPColor.textPrimary)
                    .lineLimit(1)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
            }
        }
        .buttonStyle(.plain)
    }
}

private struct StoryBubble: View {
    let name: String
    let isAdd: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: UNPSpacing.xs) {
                ZStack(alignment: .bottomTrailing) {
                    if isAdd {
                        Circle()
                            .fill(UNPColor.surface)
                            .frame(width: 56, height: 56)
                            .overlay(Circle().stroke(UNPColor.surfaceElevated, lineWidth: 1.5))
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(UNPColor.ember)
                    } else {
                        AvatarView(name: name, imageURL: nil, size: 56)
                            .overlay(Circle().stroke(UNPColor.emberGradient, lineWidth: 2))
                    }
                }
                Text(isAdd ? "Add Story" : name)
                    .font(UNPFontStyle.label())
                    .foregroundStyle(UNPColor.textSecondary)
                    .lineLimit(1)
                    .frame(width: 60)
            }
        }
        .buttonStyle(.plain)
    }
}

private struct AddStorySheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            DrawerHandle()
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(UNPColor.textSecondary)
                        .padding(8)
                        .background(UNPColor.surface)
                        .clipShape(Circle())
                }
                Spacer()
                Text("Add Story")
                    .font(UNPFontStyle.heading())
                    .foregroundStyle(UNPColor.textPrimary)
                Spacer()
                Color.clear.frame(width: 36)
            }
            .padding(.horizontal, UNPSpacing.lg)
            .padding(.top, UNPSpacing.md)

            VStack(spacing: UNPSpacing.sm) {
                storyOption(icon: "camera.fill", label: "Take Photo", subtitle: "Use your camera")
                storyOption(icon: "photo.on.rectangle.angled", label: "Choose from Library", subtitle: "Pick from photos")
            }
            .padding(UNPSpacing.lg)
        }
    }

    private func storyOption(icon: String, label: String, subtitle: String) -> some View {
        Button {} label: {
            HStack(spacing: UNPSpacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: UNPRadius.medium)
                        .fill(UNPColor.ember.opacity(0.12))
                        .frame(width: 52, height: 52)
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundStyle(UNPColor.ember)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(UNPFontStyle.heading(15))
                        .foregroundStyle(UNPColor.textPrimary)
                    Text(subtitle)
                        .font(UNPFontStyle.caption(12))
                        .foregroundStyle(UNPColor.textMuted)
                }
                Spacer()
                ChevronRight()
            }
            .padding(UNPSpacing.md)
            .unpCard()
        }
        .buttonStyle(.plain)
    }
}

private struct UploadEventFromMapSheet: View {
    let onSelectEvent: (Event) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var venue = ""
    @State private var eventDate = Date()
    @State private var description = ""
    @State private var isLoading = false
    @State private var showSuccess = false

    var body: some View {
        NavigationStack {
            if showSuccess {
                SuccessStateView(
                    title: "Event Uploaded",
                    message: "Your event is now live on UNP.",
                    onDone: { dismiss() }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(UNPColor.background)
            } else {
                Form {
                    Section("Event Details") {
                        TextField("Title", text: $title)
                            .listRowBackground(UNPColor.surface)
                            .foregroundStyle(UNPColor.textPrimary)
                        TextField("Venue name", text: $venue)
                            .listRowBackground(UNPColor.surface)
                            .foregroundStyle(UNPColor.textPrimary)
                        DatePicker("Date & Time", selection: $eventDate)
                            .listRowBackground(UNPColor.surface)
                            .foregroundStyle(UNPColor.textPrimary)
                            .tint(UNPColor.ember)
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
                        .disabled(title.isEmpty || venue.isEmpty || isLoading)
                    }
                }
            }
        }
    }
}
