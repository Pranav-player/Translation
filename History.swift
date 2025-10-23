import SwiftUI
class HistoryViewModel: ObservableObject {
    @Published var recentTranslations: [String] = []

    func addTranslation(_ translation: String) {
        if !recentTranslations.contains(translation) {
            recentTranslations.insert(translation, at: 0)
        }
        if recentTranslations.count > 20 {
            recentTranslations.removeLast()
        }
    }

    func clearHistory() {
        recentTranslations.removeAll()
    }
}

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel 

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.recentTranslations.isEmpty {
                    Text("No translations yet.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.recentTranslations, id: \.self) { translation in
                            Text(translation)
                        }
                        .onDelete(perform: deleteItem)
                    }
                }

                Button(action: {
                    viewModel.clearHistory()
                }) {
                    Text("Clear History")
                        .foregroundColor(.red)
                }
                .padding()
            }
            .navigationTitle("History")
        }
    }

    private func deleteItem(at offsets: IndexSet) {
        viewModel.recentTranslations.remove(atOffsets: offsets)
    }
}
