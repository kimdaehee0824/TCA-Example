import ComposableArchitecture
import SwiftUI
import Core

public struct PersonView: View {
    @State private var isPresented = false

    private var pictureURL: URL?
    private let store: StoreOf<Person>

    let columns = [GridItem.init(.flexible(), spacing: 16, alignment: .top), GridItem.init(.flexible(), alignment: .top)]
    public init(store: StoreOf<Person>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    Menu {
                        Button("1단", action: { viewStore.send(.tapIsCellButton("1단")) })
                        Button("2단", action: { viewStore.send(.tapIsCellButton("2단"))})
                    } label: {
                        Text(viewStore.isCell)
                            .font(.title3)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.blue, lineWidth: 1)
                            )
                    }
                    .padding(.leading, 20)
                    .padding(.vertical, 5)
                    Spacer()
                }
                if viewStore.isCell == "1단" {
                    List(viewStore.humanResult) { result in
                        Button {
                        } label: {
                            PersonCellView(entity: result) {
                                viewStore.send(.setDetailPicture(pictureURL: result.picture))
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        viewStore.send(.onAppear)
                    }

                } else {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(viewStore.humanResult) { result in
                                PersonGridView(entity: result) {
                                    viewStore.send(.setDetailPicture(pictureURL: result.picture))
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .refreshable {
                        viewStore.send(.onAppear)
                    }
                }
            }
            .fullScreenCover(
                isPresented: viewStore.binding(
                    get: \.isSheetPresented,
                    send: Person.Action.setSheet(isPresented:)
                )
            ) {
                IfLetStore(
                    self.store.scope(
                        state: returningLastNonNilValue { $0.personDetail },
                        action: Person.Action.personDetail
                    )
                ) {
                    PersonDetailView(store: $0)
                }
            }
            .task {
                viewStore.send(.onAppear)
            }
        }
    }
}