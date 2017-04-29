require 'csv'

class User < ApplicationRecord
    has_and_belongs_to_many :courses
    has_many :questions
    has_many :answers
    validates :email, uniqueness: true
    
    def self.import(file)
        if File.extname(file.original_filename).eql? ".csv"
            data  = CSV.read(file.path)
            h = data[0]
            if (h[0].eql? "name") && (h[1].eql? "email") && (h[2].eql? "is_admin") && (h[3].eql? "course_1") && (h[4].eql? "course_2") && (h[5].eql? "course_3")
                new_users = []
                (1..(data.length-1)).each do |i|
                    if data[i].length == 6
                        new_users << data[i]
                    else
                       raise "Improperly formatted CSV"
                    end
                end
                new_users.each do |u|
                    user = User.new()
                    courses = []
                    user.name = u[0]
                    user.email = u[1]
                    user.is_admin = u[2]
                    (3..5).each do |i|
                        if u[i].to_i != 0
                            courses << Course.find(u[i].to_i)
                        end
                    end
                    user.courses = courses
                    user.save
                end
            else
                raise "Improperly formatted CSV"
            end
        else 
            raise "Unknown file type: #{file.original_filename}"
        end
    end
end
