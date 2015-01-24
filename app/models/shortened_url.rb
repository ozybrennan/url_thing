class ShortenedUrl < ActiveRecord::Base
  validates :submitter_id, presence: true
  validates :long_url, presence: true, length: { maximum: 1024 }
  validates :short_url, presence: true, uniqueness: true
  validate :no_spammy_users

  belongs_to(
    :submitter,
    class_name: 'User',
    foreign_key: :submitter_id,
    primary_key: :id
  )

  has_many(
    :visits,
    class_name: 'Visit',
    foreign_key: :url_id,
    primary_key: :id
  )

  has_many :visitors, Proc.new { distinct }, through: :visits, source: :visitor

  has_many(
    :taggings,
    class_name: 'Tagging',
    foreign_key: :url_id,
    primary_key: :id
  )

  has_many :tags, through: :taggings, source: :tagtopic

  def self.random_code
    code = SecureRandom.urlsafe_base64(4)
    while ShortenedUrl.exists?(:short_url => code)
      code = SecureRandom.urlsafe_base64
    end
    code
  end

  def self.create_for_user_and_long_url!(user, long_url, tag = nil)
    ShortenedUrl.create!({submitter_id: user.id, long_url: long_url, short_url: self.random_code})
    Tag.find_by(topic: tag).add_url(self) unless tag.nil?
  end

  def num_clicks
     Visit.where("url_id = ?", self.id).count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    Visit.select(:user_id).distinct.where("created_at >= ?", 10.minutes.ago).count
  end

  private

  def no_spammy_users
    count = ShortenedUrl.select(:submitter_id).where("created_at >= ?", 5.minutes.ago).count
    if count > 5
      errors[:long_url] << "user is a spammer"
    end
  end

end
