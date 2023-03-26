class CommentController
  def create_comment(comment_hash)
    new_comment = Comment.create!(article_id: comment_hash[:article_id], content: comment_hash[:content],
                                  author_name: comment_hash[:author_name], created_at: Time.now)
    { ok: true, obj: new_comment, msg: 'Comment created' }
  rescue StandardError
    { ok: false }
  end

  def update_comment(id, update_hash)
    comment = Comment.find_by(id: id)
    return { ok: false, msg: 'Comment could not be found' } if comment.nil?

    comment.update!(content: update_hash[:content], author_name: update_hash[:author_name])
    { ok: true, obj: comment.reload, msg: 'Comment updated' }
  rescue StandardError
    { ok: false }
  end

  def get_comment(id)
    comment = Comment.find_by(id: id)
    return { ok: false, msg: 'Comment not found' } if comment.nil?

    { ok: true, data: comment }
  end

  def delete_comment(id)
    comment = Comment.find_by(id: id)
    return { ok: false, msg: 'Comment not found' } if comment.nil?

    comment.destroy!
    { ok: true, delete_count: 1, msg: 'Comment deleted' }
  rescue StandardError
    { ok: false }
  end

  def get_batch
    comments = Comment.all
    return { ok: false } if comments.empty?

    { ok: true, data: comments }
  end
end
