import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ModelCard: View {
    let model: ARModel
    @State private var isFavorited = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(model.imageName)
                .resizable()
                .scaledToFill()
                .frame(width:150,height: 120)
                .clipped()
                .cornerRadius(12)

            Text(model.name)
                .font(.headline)
                .foregroundColor(.white)

            HStack {
                Button(action: {
                    toggleFavorite()
                }) {
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                        .padding(10)
                        .background(Circle().fill(Color.white.opacity(0.2)))
                }

                Spacer()

                NavigationLink(destination: ARModelView(modelName: model.modelFile)) {
                    Image(systemName: "arkit")
                        .padding()
                        .background(Circle().fill(Color.white))
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
        .onAppear {
            checkIfFavorited()
        }
    }

    func toggleFavorite() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("❌ User not logged in")
            return
        }

        let db = Firestore.firestore()
        let favRef = db.collection("users").document(userID).collection("favorites").document(model.id)

        if isFavorited {
            favRef.delete { error in
                if let error = error {
                    print("❌ Error removing favorite: \(error.localizedDescription)")
                } else {
                    isFavorited = false
                }
            }
        } else {
            favRef.setData([
                "name": model.name,
                "imageName": model.imageName,
                "modelFile": model.modelFile
            ]) { error in
                if let error = error {
                    print("❌ Error adding favorite: \(error.localizedDescription)")
                } else {
                    isFavorited = true
                }
            }
        }
    }

    func checkIfFavorited() {
        guard let userID = Auth.auth().currentUser?.uid else {
            isFavorited = false
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(userID).collection("favorites").document(model.id).getDocument { doc, error in
            if let error = error {
                print("❌ Error checking favorite: \(error.localizedDescription)")
                return
            }

            if doc?.exists == true {
                isFavorited = true
            }
        }
    }
}
