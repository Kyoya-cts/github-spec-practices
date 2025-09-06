import SwiftUI

struct TaskEditView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: TaskStore
    @ObservedObject var vm: TaskEditViewModel

    var body: some View {
        Form {
            Section(header: Text("タイトル")) {
                TextField("タイトルを入力", text: $vm.title)
                    .textInputAutocapitalization(.sentences)
                    .disableAutocorrection(false)
                    .accessibilityLabel("タイトル")
            }

            Section(header: Text("メモ")) {
                TextField("任意", text: Binding(
                    get: { vm.note ?? "" },
                    set: { vm.note = $0.isEmpty ? nil : $0 }
                ))
                .accessibilityLabel("メモ")
            }

            Section(header: Text("締切")) {
                Toggle(isOn: Binding(
                    get: { vm.dueDate != nil },
                    set: { vm.dueDate = $0 ? (vm.dueDate ?? .now) : nil }
                )) { Text("締切を設定") }
                if let due = vm.dueDate {
                    DatePicker("日付", selection: Binding(
                        get: { due },
                        set: { vm.dueDate = $0 }
                    ), displayedComponents: [.date])
                }
            }

            Section(header: Text("優先度")) {
                Picker("優先度", selection: $vm.priority) {
                    Text("低").tag(0)
                    Text("中").tag(1)
                    Text("高").tag(2)
                }
                .pickerStyle(.segmented)
            }

            if let msg = vm.errorMessage {
                Section { Text(msg).foregroundStyle(.red) }
            }
        }
        .navigationTitle(vmTitle)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("キャンセル") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("保存") { vm.save(into: store); if vm.isValid { dismiss() } }
                    .disabled(!vm.isValid)
            }
        }
    }

    private var vmTitle: String { vmTitle(editing: vm) }
}

private func vmTitle(editing vm: TaskEditViewModel) -> String {
    vm.editing == nil ? "新規タスク" : "編集"
}

#if DEBUG
struct TaskEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { TaskEditView(vm: TaskEditViewModel()) }
            .environmentObject(TaskStore())
    }
}
#endif

