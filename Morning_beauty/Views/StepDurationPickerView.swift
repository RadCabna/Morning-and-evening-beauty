import SwiftUI

struct StepDurationPickerView: View {
    @Binding var minutes: Int
    let onDismiss: () -> Void

    private let options: [Int] = Array(1...59) + [60, 75, 90, 105, 120]

    var body: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            VStack(spacing: 0) {
                Text("DURATION")
                    .font(.app(screenHeight * 0.016, weight: .semiBold))
                    .foregroundStyle(Color(red: 0.5, green: 0.48, blue: 0.58))
                    .padding(.top, screenHeight * 0.022)
                    .padding(.horizontal, screenHeight * 0.025)
                    .padding(.bottom, screenHeight * 0.008)

                HStack(spacing: 0) {
                    Picker("", selection: $minutes) {
                        ForEach(options, id: \.self) { min in
                            Text(formatOption(min))
                                .font(.app(screenHeight * 0.022, weight: .semiBold))
                                .tag(min)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)
                    .frame(height: screenHeight * 0.16)
                    .clipped()
                }
                .padding(.horizontal, screenHeight * 0.02)

                Divider()

                HStack {
                    Spacer()

                    Button(action: onDismiss) {
                        Text("CANCEL")
                            .font(.app(screenHeight * 0.018, weight: .semiBold))
                            .foregroundStyle(Color(red: 0.55, green: 0.52, blue: 0.62))
                    }

                    Button {
                        onDismiss()
                    } label: {
                        Text("OK")
                            .font(.app(screenHeight * 0.018, weight: .semiBold))
                            .foregroundStyle(Color(red: 0.4, green: 0.35, blue: 0.75))
                    }
                    .padding(.leading, screenHeight * 0.018)
                }
                .padding(.horizontal, screenHeight * 0.025)
                .frame(height: screenHeight * 0.065)
            }
            .background(
                RoundedRectangle(cornerRadius: screenHeight * 0.022, style: .continuous)
                    .fill(.white)
            )
            .padding(.horizontal, screenHeight * 0.08)
            .shadow(color: .black.opacity(0.18), radius: screenHeight * 0.02, x: 0, y: screenHeight * 0.008)
        }
        .ignoresSafeArea(.keyboard)
    }

    private func formatOption(_ min: Int) -> String {
        if min >= 60 {
            let h = min / 60
            let m = min % 60
            return m > 0 ? "\(h) h \(m) min" : "\(h) h"
        }
        return "\(min) min"
    }
}

#Preview {
    ZStack {
        Image("mainBG_1").resizable().ignoresSafeArea()
        StepDurationPickerView(minutes: .constant(5), onDismiss: {})
    }
}
