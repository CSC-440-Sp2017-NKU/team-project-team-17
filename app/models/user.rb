class User < ApplicationRecord
    belongs_to :course
    has_many :questions
    has_many :answers
end