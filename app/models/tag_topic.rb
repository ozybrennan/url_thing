class TagTopic < ActiveRecord::Base

  has_many(
    :taggings,
    class_name: 'Tagging',
    foreign_key: :topic_id,
    primary_key: :id )

  has_many :urls, through: :taggings, source: :shortenedurl

  def add_url(url)
    Tagging.create!(topic_id: id, url_id: url.id)
  end

  def most_popular_links(n)
    self.urls.sort_by{ |url| url.num_uniques }.last(n)
  end

end
