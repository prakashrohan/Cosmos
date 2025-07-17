import SwiftUI

struct PhotoInputView: View {
    @State private var selectedImage: UIImage?
    @State private var predictions: [Prediction] = []
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isProcessing = false

    private let predictor = CoreMLPrediction()

    var body: some View {
        NavigationStack{
            
            
            ZStack {
                
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color(red: 0.05, green: 0.05, blue: 0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Constellation Scanner")
                        .font(.largeTitle.bold())
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.blue, Color.purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .blue.opacity(0.6), radius: 10)
                    
                    ImageSelectionCard(image: selectedImage, isProcessing: isProcessing)
                    
                    if !predictions.isEmpty {
                        PredictionDisplayView(
                            predictions: predictions,
                            onARButtonTap: { constellationName in
                                showARView(for: constellationName)
                            }
                        )
                        .padding(.horizontal)
                    }
                    
                    HStack(spacing: 16) {
                        CustomButton(title: "📷 Take Photo", color: .blue) {
                            sourceType = .camera
                            showImagePicker = true
                        }
                        
                        CustomButton(title: "📂 Upload Photo", color: .green) {
                            sourceType = .photoLibrary
                            showImagePicker = true
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(image: $selectedImage, sourceType: sourceType)
            }
            .onChange(of: selectedImage) { newImage in
                if let image = newImage {
                    isProcessing = true
                    predictor.predict(from: image) { results in
                        predictions = results.map {
                            Prediction(label: $0.identifier, confidence: Double($0.confidence))
                        }
                        isProcessing = false
                    }
                }
            }
            //.navigationBarBackButtonHidden(true)
        }
    }

    func showARView(for constellationName: String) {
        let arView = ARViewPlaceholder(constellationName: constellationName)
        let controller = UIHostingController(rootView: arView)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(controller, animated: true)
        }
    }
}


// MARK: - 📷 Image Selection Card
struct ImageSelectionCard: View {
    var image: UIImage?
    var isProcessing: Bool

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.3), lineWidth: 2))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 300)
                    .overlay(
                        VStack {
                            if isProcessing {
                                ProgressView("Processing...")
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.5)
                            } else {
                                Text("No Image Selected")
                                    .foregroundColor(.white.opacity(0.6))
                                    .font(.headline)
                            }
                        }
                    )
                    .shadow(radius: 10)
            }
        }
        .padding()
        .background(BlurView(style: .systemUltraThinMaterialDark))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

// MARK: - 🚀 Custom Button
struct CustomButton: View {
    var title: String
    var color: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(color)
                .cornerRadius(12)
                .shadow(radius: 8)
        }
        .padding(.horizontal, 10)
    }
}

// MARK: - AR View Placeholder
struct ARViewPlaceholder: View {
    let constellationName: String

    var body: some View {
        VStack {
            Text("🔭 AR View for \(constellationName.capitalized)")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
                .padding()

            Text("This is where the AR experience will be implemented.")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .padding()

            Spacer()
        }
        .padding()
        .background(Color.black.opacity(0.9))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}


// MARK: - 📸 Preview
#Preview {
    PhotoInputView()
}
