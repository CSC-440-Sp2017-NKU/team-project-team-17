class User < ApplicationRecord
    has_and_belongs_to_many :courses
    has_many :questions
    has_many :answers
    validates :email, uniqueness: true
end
