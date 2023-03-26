require 'active_record'

DB = ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: ENV['DB_NAME'],
  host: ENV['DB_HOST'],
  username: ENV['DB_USER'],
  password: ENV['DB_PASS']
)

ActiveRecord::Base.connection.create_table(:articles, primary_key: 'id', force: true) do |t|
  t.string :title
  t.text :content
  t.datetime :created_at
end

ActiveRecord::Base.connection.create_table(:comments, primary_key: 'id', force: true) do |t|
  t.integer :article_id
  t.text :content
  t.datetime :created_at
  t.string :author_name
end

require_relative 'article'
require_relative 'comment'

Article.create(title: 'Title ABC', content: 'Lorem Ipsum', created_at: Time.now)
Article.create(title: 'Title ZFX', content: 'Some Blog Post', created_at: Time.now)
Article.create(title: 'Title YNN', content: 'O_O_Y_O_O', created_at: Time.now)

Comment.create(article_id: 1, content: 'Yeah!', created_at: Time.now, author_name: 'lenni')
Comment.create(article_id: 1, content: 'It was ok', created_at: Time.now, author_name: 'mecca')
Comment.create(article_id: 2, content: 'So-so', created_at: Time.now, author_name: 'harri')
Comment.create(article_id: 3, content: 'Unbearable', created_at: Time.now, author_name: 'stari')

puts "Article count in DB: #{Article.count}"
puts "Comment count in DB: #{Comment.count}"
