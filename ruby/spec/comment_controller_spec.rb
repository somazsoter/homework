require 'rspec/autorun'
require 'dotenv'
require_relative '../app/controllers/comments'

describe CommentController do
  let(:controller) { CommentController.new }

  before(:all) do
    require_relative '../config/environment'
    require_relative '../app/models/db_init' # initializes the database schema; uses ENV credentials
  end

  it 'gets a comment from db' do
    result = controller.get_comment(1)
    expect(result).to have_key(:ok)
    expect(result).to have_key(:data)
    expect(result[:ok]).to be true
    expect(result[:data]).to be_truthy
    expect(result[:data][:content]).to eq('Yeah!')
  end

  it 'gets all comments from db' do
    result = controller.get_batch
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be true
    expect(result).to have_key(:data)
    expect(result[:data]).to be_truthy
    expect(result[:data].length).to eq(4)
  end

  it 'adds a test comment to db' do
    comment = { 'comment_id' => 2, 'content' => 'content unit test', 'author_name' => 'name unit test' }
    result = controller.create_comment(comment)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be true
    expect(result).to have_key(:obj)
    expect(result[:obj]).to be_truthy
    expect(result[:obj].id).to eq(5)
  end

  it 'updates the test comment in db' do
    comment = { content: 'updated content unit test', author_name: 'updated name unit test' }
    result = controller.update_comment(5, comment)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be true
    expect(result).to have_key(:obj)
    expect(result[:obj]).to be_truthy
    expect(result[:obj].content).to eq('updated content unit test')
    expect(result[:obj].author_name).to eq('updated name unit test')
  end

  it 'tries to update a non-existent comment in db' do
    comment = { 'content' => 'updated content unit test', 'author_name' => 'updated name unit test' }
    result = controller.update_comment(99, comment)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be false
    expect(result).to have_key (:msg)
  end

  it 'deletes the test comment from db' do
    result = controller.delete_comment(5)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be true
    expect(result).to have_key(:delete_count)
    expect(result[:delete_count]).to eq(1)
  end

  it 'tries to delete a non-existent comment' do
    result = controller.delete_comment(99)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be false
  end
end
