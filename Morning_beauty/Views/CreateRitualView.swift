import SwiftUI

struct CreateRitualView: View {
    @StateObject private var viewModel = CreateRitualViewModel()
    let onDismiss: () -> Void
    let onCreated: (RitualTemplate) -> Void

    @State private var activeStepPickerIndex: Int? = nil

    var body: some View {
        ZStack {
            Image("mainBG_1")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: screenHeight * 0.025) {
                        nameSection
                        photoSection
                        iconSection
                        stepsSection
                        timeSection
                        createButton
                    }
                    .padding(.horizontal, screenHeight * 0.022)
                    .padding(.top, screenHeight * 0.022)
                    .padding(.bottom, screenHeight * 0.15)
                }
            }
        }
        .overlay {
            if viewModel.showIconPicker {
                IconPickerOverlayView(
                    iconNames: viewModel.iconNames,
                    selectedIconName: $viewModel.selectedIconName,
                    onDismiss: { viewModel.showIconPicker = false }
                )
                .transition(.opacity)
            }
        }
        .overlay {
            if viewModel.showTimePicker {
                TimePickerDialogView(
                    hour: $viewModel.reminderHour,
                    minute: $viewModel.reminderMinute,
                    isAM: $viewModel.isAM,
                    onCancel: { viewModel.showTimePicker = false },
                    onConfirm: { viewModel.showTimePicker = false }
                )
                .transition(.opacity)
            }
        }
        .overlay {
            if let index = activeStepPickerIndex, viewModel.steps.indices.contains(index) {
                StepDurationPickerView(
                    minutes: $viewModel.steps[index].durationMinutes,
                    onDismiss: { activeStepPickerIndex = nil }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.showIconPicker)
        .animation(.easeInOut(duration: 0.2), value: viewModel.showTimePicker)
        .animation(.easeInOut(duration: 0.2), value: activeStepPickerIndex)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .confirmationDialog("Add photo", isPresented: $viewModel.showImageSourceDialog) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Camera") {
                    viewModel.imagePickerSourceType = .camera
                    viewModel.showImagePicker = true
                }
            }
            Button("Photo Library") {
                viewModel.imagePickerSourceType = .photoLibrary
                viewModel.showImagePicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePickerView(
                sourceType: viewModel.imagePickerSourceType,
                onImagePicked: { image in
                    viewModel.selectedImage = image
                    viewModel.showImagePicker = false
                },
                onCancel: { viewModel.showImagePicker = false }
            )
            .ignoresSafeArea()
        }
    }

    private var header: some View {
        ZStack {
            Text("Create New Ritual")
                .font(.app(screenHeight * 0.024, weight: .semiBold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)

            HStack {
                Button(action: onDismiss) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: screenHeight * 0.022, weight: .semibold))
                        .foregroundStyle(.white)
                }
                Spacer()
            }
        }
        .padding(.horizontal, screenHeight * 0.022)
        .frame(height: screenHeight * 0.06)
        .background(
            Color(red: 0.72, green: 0.65, blue: 0.82)
                .opacity(0.88)
                .ignoresSafeArea(edges: .top)
        )
        .shadow(color: .black.opacity(0.12), radius: screenHeight * 0.01, x: 0, y: screenHeight * 0.004)
    }

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.01) {
            sectionLabel("Enter name:")

            TextField("", text: $viewModel.name,
                      prompt: Text("For example, Morning care...")
                          .foregroundStyle(Color(.placeholderText)))
                .font(.app(screenHeight * 0.018))
                .foregroundStyle(.primary)
                .padding(.horizontal, screenHeight * 0.018)
                .frame(height: screenHeight * 0.056)
                .background(
                    RoundedRectangle(cornerRadius: screenHeight * 0.014, style: .continuous)
                        .fill(.white.opacity(0.72))
                )
        }
    }

    private var photoSection: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.01) {
            sectionLabel("Add photo:")

            if let image = viewModel.selectedImage {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: screenHeight * 0.22)
                        .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.018, style: .continuous))

                    Button {
                        viewModel.selectedImage = nil
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: screenHeight * 0.034, height: screenHeight * 0.034)
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: screenHeight * 0.034))
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(screenHeight * 0.01)
                }
            } else {
                Button {
                    viewModel.showImageSourceDialog = true
                } label: {
                    VStack(spacing: screenHeight * 0.012) {
                        Image("uploadImage")
                            .resizable()
                            .scaledToFit()
                            .frame(height: screenHeight * 0.06)

                        Text("Tap to add photo")
                            .font(.app(screenHeight * 0.016))
                            .foregroundStyle(Color(red: 0.55, green: 0.52, blue: 0.68))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: screenHeight * 0.13)
                    .background(
                        RoundedRectangle(cornerRadius: screenHeight * 0.018, style: .continuous)
                            .fill(.white.opacity(0.72))
                    )
                }
            }
        }
    }

    private var iconSection: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.01) {
            sectionLabel("Select icon:")

            Button {
                viewModel.showIconPicker = true
            } label: {
                HStack(spacing: screenHeight * 0.016) {
                    if let iconName = viewModel.selectedIconName {
                        Image(iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenHeight * 0.04, height: screenHeight * 0.04)
                    } else {
                        Circle()
                            .stroke(Color(red: 0.3, green: 0.7, blue: 0.65).opacity(0.5), lineWidth: 1.5)
                            .frame(width: screenHeight * 0.038, height: screenHeight * 0.038)
                    }

                    Text(viewModel.selectedIconName == nil ? "Choose from library..." : "Change icon")
                        .font(.app(screenHeight * 0.018))
                        .foregroundStyle(Color(red: 0.45, green: 0.42, blue: 0.6))

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: screenHeight * 0.016, weight: .medium))
                        .foregroundStyle(Color(red: 0.65, green: 0.62, blue: 0.75))
                }
                .padding(.horizontal, screenHeight * 0.018)
                .frame(height: screenHeight * 0.056)
                .background(
                    RoundedRectangle(cornerRadius: screenHeight * 0.014, style: .continuous)
                        .fill(.white.opacity(0.72))
                )
            }
        }
    }

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.01) {
            sectionLabel("Add steps:")

            VStack(spacing: screenHeight * 0.01) {
                ForEach(viewModel.steps.indices, id: \.self) { index in
                    HStack(spacing: screenHeight * 0.01) {
                        Text("\(index + 1).")
                            .font(.app(screenHeight * 0.018, weight: .semiBold))
                            .foregroundStyle(Color(red: 0.45, green: 0.42, blue: 0.6))
                            .frame(width: screenHeight * 0.03)

                        TextField("", text: $viewModel.steps[index].title,
                                  prompt: Text("Step name...")
                                      .foregroundStyle(Color(.placeholderText)))
                            .font(.app(screenHeight * 0.018))
                            .foregroundStyle(.primary)
                            .padding(.horizontal, screenHeight * 0.016)
                            .frame(height: screenHeight * 0.052)
                            .background(
                                RoundedRectangle(cornerRadius: screenHeight * 0.012, style: .continuous)
                                    .fill(.white.opacity(0.72))
                            )

                        Button {
                            activeStepPickerIndex = index
                        } label: {
                            Text(formatDuration(viewModel.steps[index].durationMinutes))
                                .font(.app(screenHeight * 0.015, weight: .semiBold))
                                .foregroundStyle(Color(red: 0.35, green: 0.3, blue: 0.55))
                                .lineLimit(1)
                                .padding(.horizontal, screenHeight * 0.012)
                                .frame(height: screenHeight * 0.052)
                                .background(
                                    RoundedRectangle(cornerRadius: screenHeight * 0.012, style: .continuous)
                                        .fill(Color(red: 0.88, green: 0.85, blue: 0.97))
                                )
                        }
                    }
                }
            }

            Button(action: viewModel.addStep) {
                Image(systemName: "plus")
                    .font(.system(size: screenHeight * 0.022, weight: .semibold))
                    .foregroundStyle(Color(red: 0.45, green: 0.42, blue: 0.6))
                    .frame(width: screenHeight * 0.05, height: screenHeight * 0.05)
                    .background(
                        Circle()
                            .fill(.white.opacity(0.72))
                    )
            }
            .frame(maxWidth: .infinity)
            .padding(.top, screenHeight * 0.004)
        }
    }

    private func formatDuration(_ minutes: Int) -> String {
        if minutes >= 60 {
            let h = minutes / 60
            let m = minutes % 60
            return m > 0 ? "\(h)h \(m)m" : "\(h)h"
        }
        return "\(minutes) min"
    }

    private var timeSection: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.012) {
            sectionLabel("Select time on ritual:")

            HStack(spacing: screenHeight * 0.014) {
                Text(viewModel.reminderTimeFormatted)
                    .font(.app(screenHeight * 0.018, weight: .semiBold))
                    .foregroundStyle(Color(red: 0.35, green: 0.3, blue: 0.2))
                    .padding(.horizontal, screenHeight * 0.022)
                    .frame(height: screenHeight * 0.048)
                    .background(
                        Capsule()
                            .fill(Color(red: 1.0, green: 0.92, blue: 0.72))
                    )

                Spacer()

                Button {
                    viewModel.showTimePicker = true
                } label: {
                    Text("SET")
                        .font(.app(screenHeight * 0.018, weight: .semiBold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, screenHeight * 0.032)
                        .frame(height: screenHeight * 0.048)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.5, green: 0.45, blue: 0.78))
                        )
                }
            }
            .padding(.horizontal, screenHeight * 0.02)
            .padding(.vertical, screenHeight * 0.016)
            .background(
                RoundedRectangle(cornerRadius: screenHeight * 0.018, style: .continuous)
                    .fill(.white.opacity(0.72))
            )
        }
    }

    private var createButton: some View {
        Button {
            viewModel.onCreateTapped { template in
                onCreated(template)
                onDismiss()
            }
        } label: {
            Text("Create New")
                .font(.app(screenHeight * 0.02, weight: .semiBold))
                .foregroundStyle(Color(red: 0.4, green: 0.35, blue: 0.65))
                .frame(maxWidth: .infinity)
                .frame(height: screenHeight * 0.062)
                .background(
                    RoundedRectangle(cornerRadius: screenHeight * 0.018, style: .continuous)
                        .fill(.white.opacity(0.82))
                )
                .shadow(color: .black.opacity(0.1), radius: screenHeight * 0.01, x: 0, y: screenHeight * 0.004)
        }
        .padding(.top, screenHeight * 0.01)
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.app(screenHeight * 0.017, weight: .semiBold))
            .foregroundStyle(Color(red: 0.45, green: 0.42, blue: 0.6))
    }
}

#Preview {
    CreateRitualView(onDismiss: {}, onCreated: { _ in })
}
