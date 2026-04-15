import SwiftUI

struct TimePickerDialogView: View {
    @Binding var hour: Int
    @Binding var minute: Int
    @Binding var isAM: Bool
    let onCancel: () -> Void
    let onConfirm: () -> Void

    @State private var hourText: String = ""
    @State private var minuteText: String = ""
    @State private var useNativePicker = false
    @State private var selectedDate: Date = Date()
    @FocusState private var focusedField: TimeField?

    enum TimeField { case hour, minute }

    var body: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .onTapGesture { onCancel() }

            VStack(alignment: .leading, spacing: 0) {
                Text(useNativePicker ? "SELECT TIME" : "ENTER TIME")
                    .font(.app(screenHeight * 0.016, weight: .semiBold))
                    .foregroundStyle(Color(red: 0.5, green: 0.48, blue: 0.58))
                    .padding(.top, screenHeight * 0.022)
                    .padding(.horizontal, screenHeight * 0.025)
                    .padding(.bottom, screenHeight * 0.016)

                if useNativePicker {
                    DatePicker("", selection: $selectedDate, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, screenHeight * 0.01)
                        .padding(.bottom, screenHeight * 0.012)
                        .transition(.opacity)
                } else {
                    HStack(alignment: .bottom, spacing: screenHeight * 0.012) {
                        VStack(alignment: .leading, spacing: screenHeight * 0.006) {
                            TextField("", text: $hourText)
                                .font(.app(screenHeight * 0.05, weight: .semiBold))
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                                .focused($focusedField, equals: .hour)
                                .frame(width: screenHeight * 0.11, height: screenHeight * 0.08)
                                .background(
                                    RoundedRectangle(cornerRadius: screenHeight * 0.012)
                                        .fill(focusedField == .hour ? Color.white : Color(red: 0.93, green: 0.93, blue: 0.95))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: screenHeight * 0.012)
                                                .stroke(
                                                    focusedField == .hour
                                                        ? Color(red: 0.4, green: 0.35, blue: 0.75)
                                                        : Color.clear,
                                                    lineWidth: 2
                                                )
                                        )
                                )
                            Text("Hour")
                                .font(.app(screenHeight * 0.015))
                                .foregroundStyle(Color(red: 0.55, green: 0.52, blue: 0.62))
                        }

                        Text(":")
                            .font(.app(screenHeight * 0.045, weight: .semiBold))
                            .foregroundStyle(.primary)
                            .padding(.bottom, screenHeight * 0.028)

                        VStack(alignment: .leading, spacing: screenHeight * 0.006) {
                            TextField("", text: $minuteText)
                                .font(.app(screenHeight * 0.05, weight: .semiBold))
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                                .focused($focusedField, equals: .minute)
                                .frame(width: screenHeight * 0.11, height: screenHeight * 0.08)
                                .background(
                                    RoundedRectangle(cornerRadius: screenHeight * 0.012)
                                        .fill(focusedField == .minute ? Color.white : Color(red: 0.93, green: 0.93, blue: 0.95))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: screenHeight * 0.012)
                                                .stroke(
                                                    focusedField == .minute
                                                        ? Color(red: 0.4, green: 0.35, blue: 0.75)
                                                        : Color.clear,
                                                    lineWidth: 2
                                                )
                                        )
                                )
                            Text("Minute")
                                .font(.app(screenHeight * 0.015))
                                .foregroundStyle(Color(red: 0.55, green: 0.52, blue: 0.62))
                        }

                        Spacer()

                        VStack(spacing: 0) {
                            Button {
                                isAM = true
                            } label: {
                                Text("AM")
                                    .font(.app(screenHeight * 0.018, weight: .semiBold))
                                    .foregroundStyle(isAM ? Color(red: 0.4, green: 0.35, blue: 0.75) : Color(red: 0.55, green: 0.52, blue: 0.62))
                                    .frame(width: screenHeight * 0.075, height: screenHeight * 0.05)
                                    .background(isAM ? Color(red: 0.88, green: 0.85, blue: 0.97) : Color.clear)
                            }
                            Divider()
                            Button {
                                isAM = false
                            } label: {
                                Text("PM")
                                    .font(.app(screenHeight * 0.018, weight: .semiBold))
                                    .foregroundStyle(!isAM ? Color(red: 0.4, green: 0.35, blue: 0.75) : Color(red: 0.55, green: 0.52, blue: 0.62))
                                    .frame(width: screenHeight * 0.075, height: screenHeight * 0.05)
                                    .background(!isAM ? Color(red: 0.88, green: 0.85, blue: 0.97) : Color.clear)
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: screenHeight * 0.01)
                                .stroke(Color(red: 0.8, green: 0.78, blue: 0.88), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, screenHeight * 0.025)
                    .padding(.bottom, screenHeight * 0.022)
                    .transition(.opacity)
                }

                Divider()

                HStack {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if !useNativePicker {
                                syncDateFromBindings()
                            }
                            useNativePicker.toggle()
                        }
                    } label: {
                        Image(systemName: useNativePicker ? "keyboard" : "clock")
                            .font(.system(size: screenHeight * 0.024))
                            .foregroundStyle(Color(red: 0.55, green: 0.52, blue: 0.62))
                    }

                    Spacer()

                    Button(action: onCancel) {
                        Text("CANCEL")
                            .font(.app(screenHeight * 0.018, weight: .semiBold))
                            .foregroundStyle(Color(red: 0.4, green: 0.35, blue: 0.75))
                    }

                    Button {
                        commitValues()
                        onConfirm()
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
            .padding(.horizontal, screenHeight * 0.06)
            .shadow(color: .black.opacity(0.18), radius: screenHeight * 0.02, x: 0, y: screenHeight * 0.008)
        }
        .ignoresSafeArea(.keyboard)
        .onAppear {
            hourText = "\(hour == 0 ? 12 : hour)"
            minuteText = String(format: "%02d", minute)
            syncDateFromBindings()
        }
    }

    private func syncDateFromBindings() {
        var components = DateComponents()
        let h24 = isAM ? (hour == 12 ? 0 : hour) : (hour == 12 ? 12 : hour + 12)
        components.hour = h24
        components.minute = minute
        selectedDate = Calendar.current.date(from: components) ?? Date()
    }

    private func commitValues() {
        if useNativePicker {
            let components = Calendar.current.dateComponents([.hour, .minute], from: selectedDate)
            let h = components.hour ?? 0
            let m = components.minute ?? 0
            hour = h > 12 ? h - 12 : (h == 0 ? 12 : h)
            minute = m
            isAM = h < 12
        } else {
            hour = min(max(Int(hourText) ?? 12, 1), 12)
            minute = min(max(Int(minuteText) ?? 0, 0), 59)
        }
    }
}

#Preview {
    ZStack {
        Image("mainBG_1").resizable().ignoresSafeArea()
        TimePickerDialogView(
            hour: .constant(7),
            minute: .constant(0),
            isAM: .constant(true),
            onCancel: {},
            onConfirm: {}
        )
    }
}
