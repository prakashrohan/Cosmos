struct NeonBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.black, Color.blue.opacity(0.2)], startPoint: .top, endPoint: .bottom)
            StarfieldView()
        }
        .ignoresSafeArea()
    }
}
