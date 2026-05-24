import SwiftUI

extension View {
    func bottomDrawer<Content: View>(
        isPresented: Binding<Bool>,
        detents: Set<PresentationDetent> = [.medium, .large],
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.sheet(isPresented: isPresented) {
            content()
                .presentationDetents(detents)
                .presentationDragIndicator(.visible)
                .presentationBackground(UNPColor.background)
                .presentationCornerRadius(UNPRadius.extraLarge)
        }
    }
}

struct DrawerHandle: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(UNPColor.textMuted.opacity(0.5))
            .frame(width: 36, height: 5)
            .padding(.top, UNPSpacing.sm)
    }
}
