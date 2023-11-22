class Product < ApplicationRecord
  belongs_to :category
  has_one_attached :image
  has_many :cart_items
end
