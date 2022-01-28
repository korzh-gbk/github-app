//
//  ContributorDetailsViewModel.swift
//  Github App
//
//  Created by Artem Korzh on 28.01.2022.
//

import Foundation
import Combine

final class ContributorDetailsViewModel: ObservableObject {

    private let githubResource: GithubResourceProtocol
    private let login: String
    private var cancellables: Set<AnyCancellable> = []

    @Published var contributor: ContributorModel!
    @Published var isFetching = true
    @Published var error: Error?

    init(login: String, githubResource: GithubResourceProtocol) {
        self.githubResource = githubResource
        self.login = login
    }

    public func onAppear() {
        fetchContributorDetails()
    }

    private func fetchContributorDetails() {
        githubResource.contributor(login: login)
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
            }, receiveValue: { self.contributor = $0 })
            .store(in: &self.cancellables)
    }
}
