class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories
  
  validates :name, presence: true, uniqueness: true
  
  before_save :generate_slug!
  
  def generate_slug!
    the_slug = to_slug(self.name)
    category = Category.find_by slug: the_slug
    count = 2
    while category && category != self
      the_slug = append_suffix(the_slug, count)
      category = Category.find_by slug: the_slug
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