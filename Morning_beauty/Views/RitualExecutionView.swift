import SwiftUI

struct RitualExecutionView: View {
    @StateObject private var viewModel: RitualExecutionViewModel
    let onDismiss: () -> Void

    @State private var showInventory = false

    private let stepGreen = Color(red: 0.22, green: 0.68, blue: 0.52)
    private let textDark  = Color(red: 0.22, green: 0.2, blue: 0.4)

    init(template: RitualTemplate, session: RitualSession? = nil, onDismiss: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: RitualExecutionViewModel(template: template, session: session))
        self.onDismiss = onDismiss
    }

    var body: some View {
        ZStack {
            Image("ritualBG")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(spacing: screenHeight * 0.022) {
                        timerOrTotalView

                        stepsCard

                        if viewModel.isStarted {
                            actionButtons
                        } else {
                            startButton
                        }
                    }
                    .padding(.horizontal, screenHeight * 0.022)
                    .padding(.top, screenHeight * 0.022)
                    .padding(.bottom, screenHeight * 0.16)
                }
            }

            if showInventory {
                InventoryOverlayView {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showInventory = false
                    }
                    viewModel.resume()
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showInventory)
    }

    private var header: some View {
        ZStack {
            Text("Step-by-step ritual")
                .font(.app(screenHeight * 0.024, weight: .semiBold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)

            HStack {
                Button {
                    viewModel.saveSession()
                    onDismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: screenHeight * 0.022, weight: .semibold))
                        .foregroundStyle(.white)
                }
                Spacer()
            }
            .padding(.horizontal, screenHeight * 0.022)
        }
        .frame(height: screenHeight * 0.06)
        .background(
            Color(red: 0.72, green: 0.65, blue: 0.82)
                .opacity(0.88)
                .ignoresSafeArea(edges: .top)
        )
        .shadow(color: .black.opacity(0.12), radius: screenHeight * 0.01, x: 0, y: screenHeight * 0.004)
    }

    private var timerOrTotalView: some View {
        let label = (viewModel.isStarted || viewModel.hasProgress)
            ? viewModel.countdownFormatted
            : viewModel.totalTimeFormatted
        return Text(label)
            .font(.app(screenHeight * 0.042, weight: .semiBold))
            .foregroundStyle(textDark)
            .padding(.horizontal, screenHeight * 0.045)
            .padding(.vertical, screenHeight * 0.012)
            .background(
                Capsule()
                    .fill(.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.1), radius: screenHeight * 0.01, x: 0, y: screenHeight * 0.003)
            )
    }

    private var stepsCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.template.steps.enumerated()), id: \.element.id) { index, step in
                stepRow(index: index, step: step)
                if index < viewModel.template.steps.count - 1 {
                    Divider()
                        .padding(.horizontal, screenHeight * 0.022)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.022, style: .continuous)
                .fill(.white.opacity(0.88))
        )
        .shadow(color: .black.opacity(0.1), radius: screenHeight * 0.012, x: 0, y: screenHeight * 0.004)
    }

    private func stepRow(index: Int, step: RitualStep) -> some View {
        let isCompleted = viewModel.completedSteps.contains(index)
        let isCurrent   = viewModel.isStarted && viewModel.currentStepIndex == index

        return HStack(spacing: screenHeight * 0.016) {
            Text("\(index + 1). \(step.title)")
                .font(.app(screenHeight * 0.02, weight: isCurrent ? .semiBold : .regular))
                .foregroundStyle(textDark)
                .frame(maxWidth: .infinity, alignment: .leading)

            ZStack {
                Circle()
                    .strokeBorder(stepGreen, lineWidth: screenHeight * 0.003)
                    .frame(width: screenHeight * 0.038, height: screenHeight * 0.038)

                if isCompleted {
                    Circle()
                        .fill(stepGreen)
                        .frame(width: screenHeight * 0.028, height: screenHeight * 0.028)
                }
            }
        }
        .padding(.horizontal, screenHeight * 0.022)
        .padding(.vertical, screenHeight * 0.018)
        .animation(.easeInOut(duration: 0.2), value: isCompleted)
    }

    private func frameButton(
        label: String,
        isOn: Bool,
        icon: String? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: screenHeight * 0.01) {
                Text(label)
                    .font(.app(screenHeight * 0.02, weight: .semiBold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: screenHeight * 0.022))
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, screenHeight * 0.042)
            .padding(.vertical, screenHeight * 0.014)
            .frame(minWidth: screenHeight * 0.26, maxWidth: screenHeight * 0.338)
            .frame(minHeight: screenHeight * 0.062)
            .background(
                Image(isOn ? "filterFrameOn" : "filterFrameOff")
                    .resizable()
            )
            .shadow(color: .black.opacity(0.12), radius: screenHeight * 0.01, x: 0, y: screenHeight * 0.003)
        }
        .fixedSize(horizontal: true, vertical: false)
    }

    private var startButton: some View {
        frameButton(label: viewModel.hasProgress ? "Continue" : "Start ritual", isOn: true) {
            viewModel.start()
        }
    }

    private var actionButtons: some View {
        VStack(spacing: screenHeight * 0.016) {
            frameButton(
                label: "Check inventory",
                isOn: false,
                icon: "person.crop.circle.badge.checkmark"
            ) {
                viewModel.pause()
                withAnimation(.easeInOut(duration: 0.25)) {
                    showInventory = true
                }
            }

            if !viewModel.isAllStepsCompleted,
               let step = viewModel.currentStep,
               let idx  = viewModel.currentStepIndex {
                frameButton(label: "Finish \(idx + 1). \(step.title)", isOn: true) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.completeCurrentStep()
                    }
                }
            }

            frameButton(label: "Finish ritual", isOn: false) {
                viewModel.finishRitual { _ in onDismiss() }
            }
        }
    }
}

#Preview {
    let template = RitualTemplate(
        id: UUID(), name: "Morning Care", emoji: "🌅", timeOfDay: .morning,
        steps: [
            RitualStep(id: UUID(), order: 1, title: "Cleansing", timing: 60, productCategory: ""),
            RitualStep(id: UUID(), order: 2, title: "Toner",     timing: 30, productCategory: ""),
            RitualStep(id: UUID(), order: 3, title: "Serum",     timing: 60, productCategory: ""),
            RitualStep(id: UUID(), order: 4, title: "Cream",     timing: 60, productCategory: ""),
            RitualStep(id: UUID(), order: 5, title: "SPF",       timing: 60, productCategory: "")
        ],
        isDefault: true)
    ZStack {
        Image("ritualBG").resizable().ignoresSafeArea()
        RitualExecutionView(template: template, onDismiss: {})
    }
}
