import SwiftUI

struct TaskListView: View {
    @EnvironmentObject private var store: TaskStore
    @StateObject private var vm = TaskListViewModel()
    @State private var showEditor = false
    @State private var editTask: Task? = nil

    var body: some View {
        List {
            ForEach(vm.filtered(tasks: store.tasks)) { task in
                Button {
                    editTask = task
                    showEditor = true
                } label: {
                    HStack(alignment: .center, spacing: 12) {
                        Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(task.isDone ? .green : .secondary)
                        VStack(alignment: .leading) {
                            Text(task.title)
                                .strikethrough(task.isDone)
                                .foregroundStyle(task.isDone ? .secondary : .primary)
                                .lineLimit(1)
                            HStack(spacing: 8) {
                                if let due = task.dueDate {
                                    Label(due, formatter: dateFormatter)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Label(priorityText(task.priority), systemImage: "flag.fill")
                                    .font(.caption)
                                    .foregroundStyle(priorityColor(task.priority))
                            }
                        }
                        Spacer()
                    }
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        store.toggle(task.id)
                    } label: { Label("完了", systemImage: "checkmark") }
                    .tint(.green)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        store.delete(task.id)
                    } label: { Label("削除", systemImage: "trash") }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("ToDo")
        .toolbar { toolbarContent }
        .sheet(isPresented: $showEditor, onDismiss: { editTask = nil }) {
            NavigationStack {
                TaskEditView(vm: TaskEditViewModel(editing: editTask))
            }
            .environmentObject(store)
        }
        .searchable(text: $vm.searchText)
        .safeAreaInset(edge: .top) { controls }
    }

    private var controls: some View {
        HStack(spacing: 12) {
            Picker("Filter", selection: $vm.filter) {
                ForEach(TaskListViewModel.Filter.allCases) { f in
                    Text(f.rawValue).tag(f)
                }
            }
            .pickerStyle(.segmented)

            Menu {
                Picker("Sort Key", selection: $vm.sortKey) {
                    ForEach(TaskListViewModel.SortKey.allCases) { k in
                        Text(k.rawValue).tag(k)
                    }
                }
                Toggle(isOn: $vm.ascending) {
                    Label(vm.ascending ? "昇順" : "降順", systemImage: vm.ascending ? "arrow.up" : "arrow.down")
                }
            } label: {
                Label("並べ替え", systemImage: "arrow.up.arrow.down")
                    .labelStyle(.iconOnly)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.thinMaterial)
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button {
                editTask = nil
                showEditor = true
            } label: { Image(systemName: "plus") }
        }
    }

    private func priorityText(_ p: Int) -> String {
        switch p {
        case 2: return "高"
        case 1: return "中"
        default: return "低"
        }
    }

    private func priorityColor(_ p: Int) -> Color {
        switch p {
        case 2: return .red
        case 1: return .orange
        default: return .blue
        }
    }
}

private let dateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateStyle = .medium
    f.timeStyle = .none
    return f
}()

#if DEBUG
struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TaskListView()
                .environmentObject(TaskStore())
        }
    }
}
#endif

