//
//  ContributorDetailsViewController.swift
//  Github App
//
//  Created by Artem Korzh on 28.01.2022.
//

import UIKit
import Combine
import Kingfisher

class ContributorDetailsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var companyView: UIStackView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationView: UIStackView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var emailView: UIStackView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var blogView: UIStackView!
    @IBOutlet weak var blogLabel: UILabel!
    @IBOutlet weak var repositoriesLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!


    private let viewModel: ContributorDetailsViewModel
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: ContributorDetailsViewModel) {
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

    @IBAction func didTapOpenInBrowser(_ sender: Any) {
        openURL(url: viewModel.contributor.htmlURL)
    }
    // MARK: - Configuration

    private func setupBinding() {
        viewModel.$contributor
            .sink { contributor in
                guard let contributor = contributor else {
                    return
                }
                self.fillContributorData(contributor: contributor)
            }
            .store(in: &cancellables)

        viewModel.$isFetching
            .zip(viewModel.$contributor)
            .sink(receiveValue: { isFetching, contributor in
                if !isFetching, contributor != nil {
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
        followersLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFollowersTap)))
        followingLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFollowingTap)))
        repositoriesLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRepositoriesTap)))
        blogLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBlogTap)))
        emailLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEmailTap)))
        [followersLabel, followingLabel, repositoriesLabel, blogLabel, emailLabel].forEach({ $0?.isUserInteractionEnabled = true })
    }

    // MARK: - Private methods

    private func fillContributorData(contributor: ContributorModel) {
        avatarImageView.kf.setImage(
            with: contributor.avatarURL,
            placeholder: R.image.octocat()!
        )
        nameLabel.isHidden = contributor.name == nil
        nameLabel.text = contributor.name
        loginLabel.text = contributor.login
        bioLabel.isHidden = contributor.bio == nil
        bioLabel.text = contributor.bio
        followersLabel.text = "\(contributor.followersCount) followers"
        followingLabel.text = "\(contributor.followingCount) following"
        repositoriesLabel.text = "\(contributor.repoCount) repositories"
        companyView.isHidden = contributor.company == nil
        companyLabel.text = contributor.company
        locationView.isHidden = contributor.location == nil
        locationLabel.text = contributor.location
        emailView.isHidden = contributor.email == nil
        emailLabel.text = contributor.email
        blogView.isHidden = contributor.blogURL == nil
        blogLabel.text = contributor.blogURL?.absoluteString
    }

    @objc private func handleFollowersTap() {
        openURL(url: URL(string: "https://github.com/\(viewModel.contributor.login)?tab=followers")!)
    }

    @objc private func handleFollowingTap() {
        openURL(url: URL(string: "https://github.com/\(viewModel.contributor.login)?tab=following")!)
    }

    @objc private func handleRepositoriesTap() {
        openURL(url: URL(string: "https://github.com/\(viewModel.contributor.login)?tab=repositories")!)
    }

    @objc private func handleBlogTap() {
        if let blogURL = viewModel.contributor.blogURL {
            openURL(url: blogURL)
        }
    }

    @objc private func handleEmailTap() {
        if let email = viewModel.contributor.email,
           let url = URL(string: "mailto://\(email)"){
            openURL(url: url)
        }
    }
}
