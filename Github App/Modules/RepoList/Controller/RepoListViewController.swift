//
//  RepoListViewController.swift
//  Github App
//
//  Created by Artem Korzh on 27.01.2022.
//

import UIKit
import Combine

class RepoListViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var repoCollectionView: UICollectionView!
    @IBOutlet weak var infoLabel: UILabel!

    private let viewModel: RepoListViewModel
    private var cancellables: Set<AnyCancellable> = []

    private lazy var dataSource: RepoListDataSource = {
        return RepoListDataSource(collectionView: repoCollectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.repoCell, for: indexPath)!
            cell.repo = item
            cell.onOwnerSelected = { self.navigateToOwner(owner: $0) }
            return cell
        }
    }()

    init(viewModel: RepoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutlets()
        setupBinding()
        title = "GitHub App"
    }

    @IBAction func didTapSort(_ sender: Any) {
        showSortSelection()
    }

    // MARK: - Configuration
    private func setupOutlets() {
        repoCollectionView.register(R.nib.repoCell)
        repoCollectionView.collectionViewLayout = createCollectionLayout()
        repoCollectionView.delegate = self
    }

    private func setupBinding() {
        searchField.textPublisher
            .map({ $0.trimmingCharacters(in: .whitespaces) })
            .assign(to: \.query, on: viewModel)
            .store(in: &cancellables)

        viewModel.$repos
            .sink { repos in
                var snapshot = RepoListSnapshot()
                snapshot.appendSections([.main])
                snapshot.appendItems(repos, toSection: .main)
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)

        searchField.textPublisher
            .map({ $0.trimmingCharacters(in: .whitespaces) })
            .combineLatest(viewModel.$repos.map({ $0.count }), viewModel.$isFetching)
            .sink { (searchQuery, reposCount, isFetching) in
                if reposCount == 0, !isFetching {
                    self.infoLabel.text = searchQuery.isEmpty ? "Start entering repo name for search" : "No repositories found for \(searchQuery)"
                    self.infoLabel.isHidden = false
                } else {
                    self.infoLabel.isHidden = true
                }
            }
            .store(in: &cancellables)
    }

    private func createCollectionLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
        section.interGroupSpacing = 24
        return UICollectionViewCompositionalLayout(section: section)
    }

    // MARK: - Private methods

    private func showSortSelection() {
        let sheet = UIAlertController(title: "Sort results", message: nil, preferredStyle: .actionSheet)
        for sort in GithubSort.allCases {
            var title = sort.rawValue.capitalized
            if sort == viewModel.sort {
                title = "✓ \(title)"
            }
            sheet.addAction(UIAlertAction(title: title, style: .default, handler: {_ in self.viewModel.sort = sort }))
        }
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(sheet, animated: true)
    }

    private func navigateToOwner(owner: RepoOwnerModel) {
        ContributorDetailsNavigator(navigationController: navigationController!).openContributorDetails(login: owner.login)
    }
}

extension RepoListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let repo = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        RepoDetailsNavigator(navigationController: navigationController!)
            .openRepoDetails(repoData: .init(name: repo.name, ownerName: repo.owner.login))
    }
}
