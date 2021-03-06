import PromiseKit
import PusherSwift
import UIKit

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
                             ControllerProviding, CommentsWebSocketDelegate {

    private let fetchCommentsService: FetchCommentsServiceProtocol
    private let commentsWebSocketService: CommentsWebSocketProtocol
    private let commentPresenter: CommentPresenting

    var comments: Comments?

    var voteContext: VoteContext

    init(fetchCommentsService: FetchCommentsServiceProtocol,
         commentsWebSocketService: CommentsWebSocketProtocol,
         commentPresenter: CommentPresenting,
         voteContext: VoteContext) {
        self.fetchCommentsService = fetchCommentsService
        self.commentsWebSocketService = commentsWebSocketService
        self.commentPresenter = commentPresenter
        self.voteContext = voteContext

        super.init(nibName: nil, bundle: nil)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back to Voting",
                                                                style: .plain,
                                                                target: nil,
                                                                action: nil)
    }

    override func loadView() {
        view = CommentsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchComments()
        commentsView.commentsTableView.registerCell(SingleCommentCell.self)
        commentsView.commentsTableView.dataSource = self

        commentsWebSocketService.startWebSocket(delegate: self)
        title = "Live Chat Feed"
    }

    var commentsView: CommentsView { return forceCast(view) }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments?.comments.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowNumber = indexPath.row
        guard let commentBody = comments?.comments[rowNumber] else {
            fatalError("Comment list should not be nil") }

        let cell = tableView.dequeueReusabelCell(SingleCommentCell.self, for: indexPath)
        commentPresenter.present(comment: commentBody, in: cell)

        return cell
    }

    // MARK: - Fetch Comments Service

    func fetchComments() {
        let authToken = voteContext.authToken
        _ = fetchCommentsService.fetchComments(authToken: authToken).then { [weak self] comments -> Void in
            self?.comments = comments
            self?.commentsView.commentsTableView.reloadData()
        }

    }

    func commentReceived(comment: Comment) {
        guard var updatedCommentList = self.comments?.comments else {
            return
        }
        updatedCommentList.append(comment)

        let sortedCommentsList = updatedCommentList.sorted { ( $0.id > $1.id ) }
        self.comments = self.comments?.copy(withNewComment: sortedCommentsList)

        self.commentsView.commentsTableView.reloadData()
    }

    // MARK: - ControllerProviding

    var controller: UIViewController { return self }

    // MARK: - Required initializer

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
