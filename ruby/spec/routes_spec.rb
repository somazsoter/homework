require 'sinatra/base'
require 'rack/test'
require 'rspec/autorun'
require 'json'
require 'base64'
require_relative '../app/middleware/auth'
require_relative './helpers/headers'
require_relative '../app/routes/home'
require_relative '../app/routes/articles'
require_relative '../app/routes/comments'

describe HomeRoutes do
  include Rack::Test::Methods

  let(:app) { HomeRoutes.new }

  context 'testing the homepage endpoint GET /' do
    let(:response) { get '/', nil, prepare_headers(HeaderType::HTTP_AUTH) }

    it 'checks response status' do
      expect(response.status).to eq 200
    end
  end
end

describe ArticleRoutes do
  include Rack::Test::Methods

  let(:app) { ArticleRoutes.new }
  let(:auth_header) {prepare_headers(HeaderType::HTTP_AUTH)}
  let(:content_type_header) {prepare_headers(HeaderType::CONTENT_TYPE)}

  before(:all) do
    require_relative '../config/environment'
    require_relative '../app/models/db_init' # initializes the database schema; uses ENV credentials
  end

  context 'testing the get articles endpoint GET /' do
    let(:response) { get '/', nil, auth_header}

    it 'checks response status and body' do

      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('articles')
      expect(hashed_response['articles'].length).to eq(3)
    end
  end

  context 'testing the get single article endpoint GET /2' do
    let(:response) { get '/2', nil, auth_header }

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('article')
      expect(hashed_response['article']).to be_truthy
    end
  end

  context 'testing the get single article endpoint GET /99' do
    let(:response) { get '/99', nil, auth_header }

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('msg')
      expect(hashed_response['msg']).to be_truthy
    end
  end

  context 'testing the create article endpoint ' do
    let(:response) do
      post '/', JSON.generate('title' => 'Route Test Article', 'content' => 'test content'),
      prepare_headers
    end

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('msg')
      expect(hashed_response['msg']).to eq('Article created')
    end
  end

  context 'testing the update article endpoint ' do
    let(:response) do
      put '/2', JSON.generate('title' => 'Updated Test Article', 'content' => 'update'),
      prepare_headers
    end

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('msg')
      expect(hashed_response['msg']).to eq('Article updated')
    end
  end

  context 'testing the delete article endpoint ' do
    let(:response) { delete '/2', nil, auth_header }

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('msg')
      expect(hashed_response['msg']).to eq('Article deleted')
    end
  end

  context 'testing the delete article endpoint; wrong id' do
    let(:response) { delete '/99', nil, auth_header }

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('msg')
      expect(hashed_response['msg']).to eq('Article does not exist')
    end
  end
end

describe CommentRoutes do
  include Rack::Test::Methods

  let(:app) { CommentRoutes.new }
  let(:auth_header) {prepare_headers(HeaderType::HTTP_AUTH)}
  let(:content_type_header) {prepare_headers(HeaderType::CONTENT_TYPE)}

  before(:all) do
    require_relative '../config/environment'
    require_relative '../app/models/db_init' # initializes the database schema; uses ENV credentials
  end

  context 'testing the get comments endpoint GET /' do
    let(:response) { get '/', nil, auth_header}

    it 'checks response status and body' do

      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('comments')
      expect(hashed_response['comments'].length).to eq(4)
    end
  end

  context 'testing the get single comment endpoint GET /2' do
    let(:response) { get '/2', nil, auth_header }

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('comment')
      expect(hashed_response['comment']).to be_truthy
    end
  end

  context 'testing the get single comment endpoint GET /99' do
    let(:response) { get '/99', nil, auth_header }

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('msg')
      expect(hashed_response['msg']).to be_truthy
    end
  end

  context 'testing the create comment endpoint ' do
    let(:response) do
      post '/', JSON.generate('article_id' => 3, 'content' => 'test content', 'author_name' => 'stari'),
      prepare_headers
    end

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('msg')
      expect(hashed_response['msg']).to eq('Comment created')
    end
  end

  context 'testing the update comment endpoint ' do
    let(:response) do
      put '/2', JSON.generate('article_id' => 3, 'content' => 'updated_content', 'author_name' => 'updated_name'),
      prepare_headers
    end

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('msg')
      expect(hashed_response['msg']).to eq('Comment updated')
    end
  end

  context 'testing the delete comment endpoint ' do
    let(:response) { delete '/2', nil, auth_header }

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('msg')
      expect(hashed_response['msg']).to eq('Comment deleted')
    end
  end

  context 'testing the delete comment endpoint; wrong id' do
    let(:response) { delete '/99', nil, auth_header }

    it 'checks response status and body' do
      expect(response.status).to eq 200
      hashed_response = JSON.parse(response.body)
      expect(hashed_response).to have_key('msg')
      expect(hashed_response['msg']).to eq('Comment does not exist')
    end
  end
end
