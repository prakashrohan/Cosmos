import SwiftUI
import WebKit

struct NASA3DModelView: UIViewRepresentable {
    let urlString = "https://eyes.nasa.gov/apps/orrery/#/inner_solar_system?time=2025-01-24T15:14:41.407+00:00"

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}
}

struct NASA3DModelScreen: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            NASA3DModelView()
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 40, height: 40)
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .font(.system(size: 18, weight: .bold))
                        }
                    }
                    .padding(.leading, 5)
                    .padding(.top, 5)
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
    }
}

struct NASA3DModelScreen_Previews: PreviewProvider {
    static var previews: some View {
        NASA3DModelScreen()
    }
}
