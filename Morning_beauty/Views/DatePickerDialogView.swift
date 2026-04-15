import SwiftUI

struct DatePickerDialogView: View {
    @Binding var selectedDate: Date
    let onCancel: () -> Void
    let onConfirm: () -> Void

    private let purple = Color(red: 0.42, green: 0.3, blue: 0.82)

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onCancel() }

            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: screenHeight * 0.006) {
                    Text("SELECT DATE")
                        .font(.app(screenHeight * 0.015, weight: .semiBold))
                        .foregroundStyle(.white.opacity(0.85))

                    Text(selectedDate.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                        .font(.app(screenHeight * 0.034, weight: .semiBold))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, screenHeight * 0.028)
                .padding(.vertical, screenHeight * 0.022)
                .background(purple)

                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .tint(purple)
                    .padding(.horizontal, screenHeight * 0.01)
                    .padding(.top, screenHeight * 0.008)

                Divider()

                HStack {
                    Spacer()
                    Button(action: onCancel) {
                        Text("CANCEL")
                            .font(.app(screenHeight * 0.018, weight: .semiBold))
                            .foregroundStyle(purple)
                    }
                    Button(action: onConfirm) {
                        Text("OK")
                            .font(.app(screenHeight * 0.018, weight: .semiBold))
                            .foregroundStyle(purple)
                    }
                    .padding(.leading, screenHeight * 0.022)
                }
                .padding(.horizontal, screenHeight * 0.025)
                .frame(height: screenHeight * 0.065)
            }
            .background(
                RoundedRectangle(cornerRadius: screenHeight * 0.022, style: .continuous)
                    .fill(.white)
            )
            .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.022, style: .continuous))
            .padding(.horizontal, screenHeight * 0.04)
            .shadow(color: .black.opacity(0.2), radius: screenHeight * 0.025, x: 0, y: screenHeight * 0.01)
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    ZStack {
        Image("mainBG_1").resizable().ignoresSafeArea()
        DatePickerDialogView(selectedDate: .constant(Date()), onCancel: {}, onConfirm: {})
    }
}
