import SwiftUI

struct LibraryView: View {
    @StateObject private var viewModel = LibraryViewModel()
    @State private var showCreateRitual = false
    @State private var selectedRitual: RitualTemplate? = nil

    var body: some View {
        ZStack {
            mainContent

            if showCreateRitual {
                CreateRitualView(
                    onDismiss: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showCreateRitual = false
                        }
                    },
                    onCreated: { newRitual in
                        viewModel.rituals.append(newRitual)
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showCreateRitual = false
                        }
                    }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            if let ritual = selectedRitual {
                RitualExecutionView(
                    template: ritual,
                    session: RitualSessionStore.shared.session(for: ritual.id),
                    onDismiss: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            selectedRitual = nil
                        }
                    }
                )
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showCreateRitual)
        .animation(.easeInOut(duration: 0.25), value: selectedRitual?.id)
    }

    private var mainContent: some View {
        VStack(spacing: 0) {
            LibraryTopBarView()

            ZStack(alignment: .bottomTrailing) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(Array(viewModel.rituals.enumerated()), id: \.element.id) { index, ritual in
                            RitualLibraryRowView(
                                ritual: ritual,
                                onTap: {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        selectedRitual = ritual
                                    }
                                }
                            )
                            if index < viewModel.rituals.count - 1 {
                                Divider()
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: screenHeight * 0.025, style: .continuous)
                            .fill(.white.opacity(0.82))
                    )
                    .shadow(color: .black.opacity(0.1), radius: screenHeight * 0.015, x: 0, y: screenHeight * 0.005)
                    .padding(.horizontal, screenHeight * 0.022)
                    .padding(.top, screenHeight * 0.02)
                    .padding(.bottom, screenHeight * 0.16)
                }

                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showCreateRitual = true
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: screenHeight * 0.028, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: screenHeight * 0.072, height: screenHeight * 0.072)
                        .background(Circle().fill(Color.accentColor))
                        .shadow(color: Color.accentColor.opacity(0.45), radius: screenHeight * 0.015, x: 0, y: screenHeight * 0.006)
                }
                .padding(.trailing, screenHeight * 0.028)
                .padding(.bottom, screenHeight * 0.12)
            }
        }
    }
}

#Preview {
    ZStack {
        Image("mainBG_1")
            .resizable()
            .ignoresSafeArea()
        LibraryView()
    }
}
