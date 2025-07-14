struct ExpandedAPODCard: View {
    let apod: APOD
    let animation: Namespace.ID
    var dismiss: () -> Void
    var viewARAction: () -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                .edgesIgnoringSafeArea(.all)
                .overlay(Color.black.opacity(0.6))

            VStack(spacing: 20) {
                HStack {
                    Button(action: dismiss) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.top, 60)
                .padding(.horizontal)

                Spacer(minLength: 10)

                if let url = URL(string: apod.url ?? "") {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFit()
                            .matchedGeometryEffect(id: apod.id, in: animation)
                    } placeholder: {
                        ProgressView()
                    }
                    .cornerRadius(20)
                    .padding(.horizontal)
                }

                Text(apod.title ?? "Untitled")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 10)

                if let desc = apod.explanation {
                    ScrollView {
                        Text(desc)
                            .foregroundColor(.white.opacity(0.8))
                            .padding()
                    }
                    .frame(maxHeight: 180)
                }

                Spacer()

                Button(action: viewARAction) {
                    Text("🌌 View in AR")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(radius: 10)
                        .padding(.horizontal, 40)
                }

                Spacer(minLength: 30)
            }
        }
    }
}
