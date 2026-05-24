import SwiftUI

struct CartView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: CartViewModel

    init() {
        let di = DIContainer.shared
        _viewModel = State(initialValue: CartViewModel(
            fetchCartUseCase: di.makeFetchCartUseCase(),
            cartRepository: di.cartRepository,
            placeOrderUseCase: di.makePlaceOrderUseCase()
        ))
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.orderPlaced {
                    SuccessStateView(
                        title: "Order Placed",
                        message: "Your order is confirmed. Check Pour Circle for updates.",
                        onDone: { dismiss() }
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(UNPColor.background)
                } else if viewModel.isLoading {
                    ScrollView {
                        VStack(spacing: UNPSpacing.sm) {
                            ForEach(0..<3, id: \.self) { _ in SkeletonRowView() }
                        }
                        .padding(UNPSpacing.md)
                    }
                    .background(UNPColor.background)
                } else if viewModel.items.isEmpty {
                    ContentUnavailableView {
                        Label("Your Cart is Empty", systemImage: "cart")
                    } description: {
                        Text("Browse beverages in The Pour to add drinks to your cart.")
                    }
                    .background(UNPColor.background)
                } else {
                    cartContent
                }
            }
            .background(UNPColor.background)
            .navigationTitle("Your Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(UNPColor.textSecondary)
                            .padding(8)
                            .background(UNPColor.surface)
                            .clipShape(SwiftUI.Circle())
                    }
                }
            }
            .task { await viewModel.loadCart() }
        }
    }

    private var cartContent: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: UNPSpacing.sm) {
                    ForEach(viewModel.items) { item in
                        CartItemRow(
                            item: item,
                            onRemove: { Task { await viewModel.removeItem(item) } },
                            onDecrease: {
                                Task { await viewModel.updateQuantity(id: item.id, quantity: item.quantity - 1) }
                            },
                            onIncrease: {
                                Task { await viewModel.updateQuantity(id: item.id, quantity: item.quantity + 1) }
                            }
                        )
                    }
                }
                .padding(UNPSpacing.md)
                .padding(.bottom, 100)
            }

            checkoutBar
        }
    }

    private var checkoutBar: some View {
        VStack(spacing: UNPSpacing.sm) {
            HStack {
                Text("Total")
                    .font(UNPFontStyle.heading())
                    .foregroundStyle(UNPColor.textPrimary)
                Spacer()
                Text(String(format: "$%.2f", viewModel.total))
                    .font(UNPFontStyle.heading(18))
                    .foregroundStyle(UNPColor.copper)
            }

            Button {
                Task { await viewModel.placeOrder() }
            } label: {
                HStack {
                    if viewModel.isPlacingOrder {
                        LoadingSpinner(color: .black, size: 16)
                    } else {
                        Text("Place Order · \(viewModel.itemCount) item\(viewModel.itemCount == 1 ? "" : "s")")
                            .font(UNPFontStyle.heading())
                            .foregroundStyle(.black)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(UNPColor.copper)
                .clipShape(RoundedRectangle(cornerRadius: UNPRadius.large))
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isPlacingOrder)
        }
        .padding(UNPSpacing.md)
        .background(.ultraThinMaterial)
    }
}

private struct CartItemRow: View {
    let item: CartItem
    let onRemove: () -> Void
    let onDecrease: () -> Void
    let onIncrease: () -> Void

    var body: some View {
        HStack(spacing: UNPSpacing.md) {
            ZStack {
                SwiftUI.Circle()
                    .fill(UNPColor.copper.opacity(0.12))
                    .frame(width: 48, height: 48)
                Image(systemName: "wineglass.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(UNPColor.copper)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(UNPFontStyle.heading(14))
                    .foregroundStyle(UNPColor.textPrimary)
                Text(String(format: "$%.2f each", item.price))
                    .font(UNPFontStyle.caption(12))
                    .foregroundStyle(UNPColor.textMuted)
            }

            Spacer()

            HStack(spacing: UNPSpacing.sm) {
                Button(action: onDecrease) {
                    Image(systemName: "minus")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(UNPColor.textSecondary)
                        .frame(width: 28, height: 28)
                        .background(UNPColor.surface)
                        .clipShape(SwiftUI.Circle())
                }
                .buttonStyle(.plain)

                Text("\(item.quantity)")
                    .font(UNPFontStyle.heading(14))
                    .foregroundStyle(UNPColor.textPrimary)
                    .frame(minWidth: 20, alignment: .center)

                Button(action: onIncrease) {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.black)
                        .frame(width: 28, height: 28)
                        .background(UNPColor.copper)
                        .clipShape(SwiftUI.Circle())
                }
                .buttonStyle(.plain)
            }

            Button(action: onRemove) {
                Image(systemName: "trash")
                    .font(.system(size: 13))
                    .foregroundStyle(UNPColor.error)
            }
            .buttonStyle(.plain)
        }
        .padding(UNPSpacing.md)
        .unpCard()
    }
}
