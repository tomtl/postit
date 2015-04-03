class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 4}
  
  before_save :generate_slug!
  
  def generate_slug!
    the_slug = to_slug(self.username)
    user = User.find_by slug: the_slug
    count = 2
    while user && user != self
      the_slug = append_suffix(the_slug, count)
      user = User.find_by slug: the_slug
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
