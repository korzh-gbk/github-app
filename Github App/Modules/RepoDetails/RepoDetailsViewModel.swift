//
//  RepoDetailsViewModel.swift
//  Github App
//
//  Created by Artem Korzh on 28.01.2022.
//

import Foundation
import Combine

final class RepoDetailsViewModel: ObservableObject {

    private let githubResource: GithubResourceProtocol
    private let repoData: RepoData
    private var cancellables: Set<AnyCancellable> = []

    @Published var repo: RepoModel!
    @Published var isFetching = true
    @Published var error: Error?

    init(repoData: RepoData, githubResource: GithubResourceProtocol) {
        self.repoData = repoData
        self.githubResource = githubResource
    }

    public func onAppear() {
        fetchRepoDetails()
    }

    private func fetchRepoDetails() {
        githubResource.repoDetails(data: repoData)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                switch $0 {
                case .failure(let error):
                    self.error = error
                    print(error)
                case .finished:
                    print("finished")
                }
                self.isFetching = false
            }, receiveValue: { self.repo = $0 })
            .store(in: &self.cancellables)
    }
}
