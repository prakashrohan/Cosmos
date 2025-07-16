import SwiftUI
import QuickLook

struct ARModelView: UIViewControllerRepresentable {
    let modelName: String  // e.g., "ISS_stationary"

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: QLPreviewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(modelName: modelName)
    }

    class Coordinator: NSObject, QLPreviewControllerDataSource {
        let modelName: String

        init(modelName: String) {
            self.modelName = modelName
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            guard let url = Bundle.main.url(forResource: modelName, withExtension: "usdz") else {
                fatalError("Model file not found")
            }
            return url as QLPreviewItem
        }
    }
}
