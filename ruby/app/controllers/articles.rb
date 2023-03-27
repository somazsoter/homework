class ArticleController
  def create_article(article_hash)
    article_exists = !Article.find_by(title: article_hash[:title]).nil?

    return { ok: false, msg: 'Article with given title already exists' } if article_exists

    new_article = Article.create!(title: article_hash[:title], content: article_hash[:content], created_at: Time.now)
    { ok: true, obj: new_article, msg: 'Article created' }
  rescue StandardError
    { ok: false }
  end

  def update_article(id, update_hash)
    article = Article.find_by(id: id)
    return { ok: false, msg: 'Article could not be found' } if article.nil?

    article.update!(title: update_hash[:title], content: update_hash[:content])
    { ok: true, obj: article.reload, msg: 'Article updated' }
  rescue StandardError
    { ok: false }
  end

  def get_article(id)
    article = Article.find_by(id: id)
    return { ok: false, msg: 'Article not found' } if article.nil?

    { ok: true, data: article }
  end

  def delete_article(id)
    article = Article.find_by(id: id)
    return { ok: false, msg: 'Article not found' } if article.nil?

    article.destroy!
    { ok: true, delete_count: 1, msg: 'Article deleted' }
  rescue StandardError
    { ok: false }
  end

  def get_batch
    articles = Article.all
    return { ok: false } if articles.empty?

    { ok: true, data: articles }
  end
end
