class Post < ActiveRecord::Base
  include Voteable

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories


  validates :title, presence: true, length: {minimum: 5}
  validates :description, presence: true
  validates :url, presence: true, uniqueness: true

  before_save :generate_slug!

  def generate_slug!
    the_slug = to_slug(self.title)
    post = Post.find_by slug: the_slug
    count = 2
    while post && post != self
      the_slug = append_suffix(the_slug, count)
      post = Post.find_by slug: the_slug
      count += 1
    end
    self.slug = the_slug.downcase
  end

  def append_suffix(slug_for_append, count)
    if slug_for_append.split('-').last.to_i != 0
      return slug_for_append.split('-').slice(0...-1).join('-') + "-" + count.to_s
    else
      return slug_for_append + "-" + count.to_s
    end
  end

  def to_slug(initial_slug)
    initial_slug = initial_slug.strip
    initial_slug.gsub! /\s*[^A-Za-z0-9]\s*/, '-'
    initial_slug.gsub! /-+/, "-"
    initial_slug.downcase
  end

  def to_param
    self.slug
  end
end
