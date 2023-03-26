require_relative '../controllers/articles'

class ArticleRoutes < Sinatra::Base
  use AuthMiddleware

  def initialize
    super
    @article_ctrl = ArticleController.new
  end

  before do
    content_type :json
  end

  get('/') do
    summary = @article_ctrl.get_batch
    return { msg: 'Could not get articles.' }.to_json unless summary[:ok]

    { articles: summary[:data] }.to_json
  end

  get('/:id') do
    summary = @article_ctrl.get_article(params[:id])
    return { msg: 'Could not get article.' }.to_json unless summary[:ok]

    { article: summary[:data] }.to_json
  end

  post('/') do
    payload = JSON.parse(request.body.read)
    summary = @article_ctrl.create_article(payload)
    return { msg: summary[:msg] }.to_json unless summary[:ok]

    { msg: 'Article created' }.to_json
  end

  put('/:id') do
    payload = JSON.parse(request.body.read)
    summary = @article_ctrl.update_article(params[:id], payload)
    return { msg: 'Could not update article.' }.to_json unless summary[:ok]

    { msg: summary[:msg] }.to_json
  end

  delete('/:id') do
    summary = @article_ctrl.delete_article(params[:id])
    return { msg: 'Article does not exist' }.to_json unless summary[:ok]

    { msg: summary[:msg] }.to_json
  end
end
