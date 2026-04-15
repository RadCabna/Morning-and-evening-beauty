import SwiftUI

struct AddCosmeticView: View {
    @StateObject private var viewModel = AddCosmeticViewModel()
    let onDismiss: () -> Void
    let onCreated: (CosmeticItem) -> Void

    @State private var keyboardHeight: CGFloat = 0

    var body: some View {
        ZStack {
            Image("mainBG_1")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: screenHeight * 0.022) {
                        nameSection
                        brandSection
                        volumeSection
                        imageSection
                        categorySection
                        openedSection
                        notesSection
                        createButton
                    }
                    .padding(.horizontal, screenHeight * 0.022)
                    .padding(.top, screenHeight * 0.022)
                    .padding(.bottom, screenHeight * 0.15)

                    if keyboardHeight > 0 {
                        Spacer().frame(height: keyboardHeight)
                    }
                }
            }
        }
        .overlay {
            if viewModel.showDatePicker {
                DatePickerDialogView(
                    selectedDate: $viewModel.openedDate,
                    onCancel: { viewModel.showDatePicker = false },
                    onConfirm: { viewModel.showDatePicker = false }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.showDatePicker)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isOpened)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation(.easeOut(duration: 0.25)) { keyboardHeight = frame.height }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation(.easeOut(duration: 0.25)) { keyboardHeight = 0 }
        }
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
            Text("Create New Cosmetic")
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
        formField(label: "Enter name:") {
            TextField("", text: $viewModel.name,
                      prompt: Text("Hyaluronic...").foregroundStyle(Color(.placeholderText)))
        }
    }

    private var brandSection: some View {
        formField(label: "Enter Brand name:") {
            TextField("", text: $viewModel.brandName,
                      prompt: Text("Brand name...").foregroundStyle(Color(.placeholderText)))
        }
    }

    private var volumeSection: some View {
        formField(label: "Enter volume:") {
            TextField("", text: $viewModel.volume,
                      prompt: Text("100 ml...").foregroundStyle(Color(.placeholderText)))
        }
    }

    private var imageSection: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.01) {
            sectionLabel("Upload image:")

            Button {
                viewModel.showImageSourceDialog = true
            } label: {
                if let image = viewModel.selectedImage {
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: screenHeight * 0.11, height: screenHeight * 0.11)
                            .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.014, style: .continuous))

                        Button {
                            viewModel.selectedImage = nil
                        } label: {
                            ZStack {
                                Circle().fill(.white)
                                    .frame(width: screenHeight * 0.028, height: screenHeight * 0.028)
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: screenHeight * 0.028))
                                    .foregroundStyle(.red)
                            }
                        }
                        .padding(screenHeight * 0.006)
                    }
                } else {
                    RoundedRectangle(cornerRadius: screenHeight * 0.014, style: .continuous)
                        .fill(Color(red: 0.9, green: 0.88, blue: 0.95))
                        .frame(width: screenHeight * 0.11, height: screenHeight * 0.11)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: screenHeight * 0.036))
                                .foregroundStyle(Color(red: 0.65, green: 0.62, blue: 0.78))
                        )
                }
            }
        }
    }

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.01) {
            sectionLabel("Category:")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: screenHeight * 0.01) {
                    ForEach(CosmeticCategory.allCases) { cat in
                        Button {
                            viewModel.selectedCategory = cat
                        } label: {
                            Text(cat.title)
                                .font(.app(screenHeight * 0.015, weight: viewModel.selectedCategory == cat ? .semiBold : .regular))
                                .foregroundStyle(viewModel.selectedCategory == cat ? .white : Color(red: 0.45, green: 0.42, blue: 0.6))
                                .lineLimit(1)
                                .padding(.horizontal, screenHeight * 0.016)
                                .frame(height: screenHeight * 0.036)
                                .background(
                                    Capsule().fill(
                                        viewModel.selectedCategory == cat
                                            ? Color(red: 0.55, green: 0.48, blue: 0.78)
                                            : Color.white.opacity(0.72)
                                    )
                                )
                        }
                    }
                }
                .padding(.vertical, screenHeight * 0.004)
            }
        }
    }

    private var openedSection: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.012) {
            sectionLabel("Status opened:")

            Button {
                viewModel.isOpened.toggle()
            } label: {
                HStack(spacing: screenHeight * 0.012) {
                    Text("Opened:")
                        .font(.app(screenHeight * 0.018, weight: .semiBold))
                        .foregroundStyle(Color(red: 0.42, green: 0.38, blue: 0.62))

                    ZStack {
                        Circle()
                            .strokeBorder(
                                viewModel.isOpened
                                    ? Color(red: 0.2, green: 0.65, blue: 0.6)
                                    : Color(red: 0.65, green: 0.62, blue: 0.78),
                                lineWidth: 2
                            )
                            .frame(width: screenHeight * 0.028, height: screenHeight * 0.028)

                        if viewModel.isOpened {
                            Circle()
                                .fill(Color(red: 0.2, green: 0.65, blue: 0.6))
                                .frame(width: screenHeight * 0.016, height: screenHeight * 0.016)
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, screenHeight * 0.02)
                .frame(height: screenHeight * 0.056)
                .background(
                    RoundedRectangle(cornerRadius: screenHeight * 0.016, style: .continuous)
                        .fill(.white.opacity(0.72))
                )
            }

            if viewModel.isOpened {
                Button {
                    viewModel.showDatePicker = true
                } label: {
                    HStack {
                        Image(systemName: "calendar")
                            .font(.system(size: screenHeight * 0.02))
                            .foregroundStyle(Color(red: 0.42, green: 0.38, blue: 0.72))

                        Text(viewModel.openedDate.formatted(.dateTime.day().month(.wide).year()))
                            .font(.app(screenHeight * 0.018))
                            .foregroundStyle(Color(red: 0.42, green: 0.38, blue: 0.62))

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: screenHeight * 0.016, weight: .medium))
                            .foregroundStyle(Color(red: 0.65, green: 0.62, blue: 0.75))
                    }
                    .padding(.horizontal, screenHeight * 0.02)
                    .frame(height: screenHeight * 0.056)
                    .background(
                        RoundedRectangle(cornerRadius: screenHeight * 0.016, style: .continuous)
                            .fill(.white.opacity(0.72))
                    )
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.01) {
            sectionLabel("Notes:")

            TextField("", text: $viewModel.notes,
                      prompt: Text("Notes...").foregroundStyle(Color(.placeholderText)))
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

    private var createButton: some View {
        Button {
            let item = viewModel.buildItem()
            onCreated(item)
            onDismiss()
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

    private func formField(label: String, @ViewBuilder field: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.01) {
            sectionLabel(label)
            field()
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

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.app(screenHeight * 0.017, weight: .semiBold))
            .foregroundStyle(Color(red: 0.45, green: 0.42, blue: 0.6))
    }
}

#Preview {
    AddCosmeticView(onDismiss: {}, onCreated: { _ in })
}
