//
//  RepoListViewModel.swift
//  Github App
//
//  Created by Artem Korzh on 27.01.2022.
//

import Foundation
import Combine

final class RepoListViewModel: ObservableObject {

    private let githubResource: GithubResourceProtocol
    var cancellables: Set<AnyCancellable> = []

    @Published var query: String = ""
    @Published var sort: GithubSort = .stars
    @Published var repos: [RepoListItemModel] = []
    @Published var isFetching = false
    @Published var error: Error?

    init(githubResource: GithubResourceProtocol) {
        self.githubResource = githubResource

        $query
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .combineLatest($sort)
            .dropFirst()
            .sink { (query, sort) in
                self.isFetching = true
                githubResource.search(query: query, sort: sort)
                    .subscribe(on: DispatchQueue.global())
                    .receive(on: DispatchQueue.main)
                    .map({ $0.items })
                    .sink(receiveCompletion: {
                        switch $0 {
                        case .failure(let error):
                            self.error = error
                            print(error)
                        case .finished:
                            print("finished")
                        }
                        self.isFetching = false
                    }, receiveValue: { self.repos = $0 })
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)





    }
}
