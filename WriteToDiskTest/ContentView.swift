import SwiftUI

struct ContentView: View {
    enum RestoreAlertType {
        case empty, complete
    }
    private let presenter = ContentViewPresenter()

    @State var dictionaryKey: String = ""
    @State var dictionaryValue: String = ""

    @State var showSaveAlert = false
    @State var showRestoreAlert = false

    @State var restoreAlertType = ContentView.RestoreAlertType.empty

    var body: some View {
        VStack {
            Text("永続化テスト")
            VStack {
                HStack {
                    Text("Key").padding()
                    TextField("Key", text: $dictionaryKey)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                HStack {
                    Text("Value").padding()
                    TextField("Value", text: $dictionaryValue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                HStack {
                    Button("Save") {
                        guard !self.dictionaryKey.isEmpty && !self.dictionaryValue.isEmpty else {
                            self.showSaveAlert = true
                            return
                        }
                        self.presenter.save(key: self.dictionaryKey, value: self.dictionaryValue)

                    }
                    .alert(isPresented: $showSaveAlert) { () -> Alert in
                        Alert(title: Text("Error!"), message: Text("key or value is empty.\nThese value is required to save"))
                    }

                    Button("Restore") {
                        let dictionary = self.presenter.restore()
                        guard !dictionary.isEmpty else {
                            self.restoreAlertType = .empty

                            self.showRestoreAlert = true
                            return
                        }
                        self.restoreAlertType = .complete
                        self.showRestoreAlert = true
                    }
                    .alert(isPresented: $showRestoreAlert, content: { () -> Alert in
                        switch restoreAlertType {
                        case .empty:
                            return Alert(title: Text("Error!"), message: Text("Looks like local data is cleared."))
                        case .complete:
                            return Alert(title: Text("Restored"),
                                         message: Text("Dictionary Key is \(presenter.restore().first!.key).\n Dictionary Value is \(presenter.restore() .first!.value)"))
                        }
                    })
                        .padding()

                        Button("Delete") {
                            self.presenter.delete()
                        }
                    }
                }
            }
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
}
