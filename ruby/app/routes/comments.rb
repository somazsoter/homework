require_relative '../controllers/comments'

class CommentRoutes < Sinatra::Base
  use AuthMiddleware

  def initialize
    super
    @comment_ctrl = CommentController.new
  end

  before do
    content_type :json
  end

  get('/') do
    summary = @comment_ctrl.get_batch
    return { msg: 'Could not get comments.' }.to_json unless summary[:ok]

    { comments: summary[:data] }.to_json
  end

  get('/:id') do
    summary = @comment_ctrl.get_comment(params[:id])
    return { msg: 'Could not get comment.' }.to_json unless summary[:ok]

    { comment: summary[:data] }.to_json
  end

  post('/') do
    payload = JSON.parse(request.body.read)
    summary = @comment_ctrl.create_comment(payload)
    return { msg: summary[:msg] }.to_json unless summary[:ok]

    { msg: 'Comment created' }.to_json
  end

  put('/:id') do
    payload = JSON.parse(request.body.read)
    summary = @comment_ctrl.update_comment(params[:id], payload)
    return { msg: 'Could not update comment.' }.to_json unless summary[:ok]

    { msg: summary[:msg] }.to_json
  end

  delete('/:id') do
    summary = @comment_ctrl.delete_comment(params[:id])
    return { msg: 'Comment does not exist' }.to_json unless summary[:ok]

    { msg: summary[:msg] }.to_json
  end
end
