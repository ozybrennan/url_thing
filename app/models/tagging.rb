class Tagging < ActiveRecord::Base

  belongs_to(
    :tag,
    class_name: 'TagTopic',
    foreign_key: :topic_id,
    primary_key: :id
  )

  belongs_to(
    :shortenedurl,
    class_name: 'ShortenedUrl',
    foreign_key: :url_id,
    primary_key: :id
  )

end
