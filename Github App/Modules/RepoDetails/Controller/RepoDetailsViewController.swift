//
//  RepoDetailsViewController.swift
//  Github App
//
//  Created by Artem Korzh on 28.01.2022.
//

import UIKit
import Combine
import Kingfisher

class RepoDetailsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var homepageView: UIStackView!
    @IBOutlet weak var homepageButton: UIButton!

    @IBOutlet weak var ownerView: UIStackView!
    @IBOutlet weak var ownerAvatarImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!

    @IBOutlet weak var languageView: UIStackView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!

    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!

    private let viewModel: RepoDetailsViewModel
    private var cancellables: Set<AnyCancellable> = []



    init(viewModel: RepoDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupTouches()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onAppear()
    }

    @IBAction func didTapHomepage(_ sender: Any) {
        if let url = viewModel.repo.homepageURL {
            openURL(url: url)
        }
    }

    @IBAction func didTapOpenInBrowser(_ sender: Any) {
        openURL(url: viewModel.repo.htmlURL) 
    }

    // MARK: - Configuration

    private func setupBinding() {
        viewModel.$repo
            .sink { repo in
                guard let repo = repo else {
                    return
                }
                self.fillRepoData(repo: repo)
            }
            .store(in: &cancellables)

        viewModel.$isFetching
            .zip(viewModel.$repo)
            .sink(receiveValue: { isFetching, repo in
                if !isFetching, repo != nil {
                    self.scrollView.isHidden = false
                } else {
                    self.scrollView.isHidden = true
                }
            })
            .store(in: &cancellables)

        viewModel.$isFetching
            .map({ !$0 })
            .assign(to: \.isHidden, on: activityIndicatorView)
            .store(in: &cancellables)

        viewModel.$error
            .sink { error in
                guard let error = error else {
                    return
                }
                self.displayError(error: error)
            }
            .store(in: &cancellables)
    }

    private func setupTouches() {
        ownerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOwnerTap)))
    }

    // MARK: - Private methods

    private func fillRepoData(repo: RepoModel) {
        nameLabel.text = repo.name
        descriptionLabel.text = repo.repoDescription
        if let homepageURL = repo.homepageURL {
            homepageView.isHidden = false
            homepageButton.setTitle(homepageURL.absoluteString, for: .normal)
        } else {
            homepageView.isHidden = true
        }
        createdAtLabel.text = String(format: "Created: %@", repo.createdAt.formatted(date: .abbreviated, time: .omitted))
        updatedAtLabel.text = String(format: "Last updated: %@", repo.updatedAt.formatted(date: .abbreviated, time: .omitted))
        ownerNameLabel.text = repo.owner.login
        ownerAvatarImageView.kf.setImage(
            with: repo.owner.avatarURL,
            placeholder: R.image.octocat()!
        )
        languageView.isHidden = repo.language == nil
        languageLabel.text = repo.language
        starsLabel.text = "\(repo.starsCount)"
        watchersLabel.text = "Subscribers: \(repo.subscribersCount)"
        forksLabel.text = "Forks: \(repo.forksCount)"
        issuesLabel.text = "Issues: \(repo.openIssuesCount)"
    }

    @objc private func handleOwnerTap() {
        guard let repo = viewModel.repo else {
            return
        }
        ContributorDetailsNavigator(navigationController: navigationController!).openContributorDetails(login: repo.owner.login)
    }
}
