class User < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2 }
  validates :username, presence: true, length: { minimum: 4, maximum: 25 }, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true
end
