require 'csv'

class User < ApplicationRecord
    has_and_belongs_to_many :courses
    has_many :questions
    has_many :answers
    validates :email, uniqueness: true
    
    #handling the CSV import
    def self.import(file)
        #set up an array to hold the users that we have verified are not malformed
        checked_users = []
        #check the filetype of the CSV
        if File.extname(file.original_filename).eql? ".csv"
            data  = CSV.read(file.path)
            h = data[0]
            #make sure we have the right fields, and in the right order
            if (h[0].eql? "name") && (h[1].eql? "email") && (h[2].eql? "is_admin") && (h[3].eql? "is_registrar") && (h[4].eql? "course_1") && (h[5].eql? "course_2") && (h[6].eql? "course_3")
                new_users = []
                #check each row for length, to make sure a field is not missing from any row
                (1..(data.length-1)).each do |i|
                    if data[i].length == 7
                        new_users << data[i]
                    else
                       raise "Improperly formatted CSV"
                    end
                end
                new_users.each do |u|
                    #make sure there isnt a user with this username already in the DB
                    if User.find_by(email: u[1]) == nil
                        user = User.new()
                        courses = []
                        if u[0].length > 0
                        user.name = u[0]
                        else
                            raise "Name must be present"
                        end
                        #validate an email address string format
                        if u[1] =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
                            user.email = u[1]
                        else
                            raise "Improperly formatted email address"
                        end
                        #only allow true or false strings in this field
                        if (u[2].eql? "true") || (u[2].eql? "false")
                            user.is_admin = u[2]
                        else
                            raise "is_admin should be true or false"
                        end
                        #only allow true or false strings in this field
                        if (u[3].eql? "true") || (u[3].eql? "false")
                            user.is_registrar = u[3]
                        else
                            raise "is_registrar should be true or false"
                        end
                        #collapse courses into a unique array, then make sure that the course actually exists before adding it to the user
                        u[4..6].uniq.each do |c|
                            if c.to_i != 0
                                begin
                                    courses << Course.find(c.to_i)
                                rescue
                                end
                            end
                        end
                        user.courses = courses
                        checked_users << user
                    else
                        raise "Duplicate User: #{u[1]}"
                    end
                end
            else
                raise "Improperly formatted CSV"
            end
        else 
            raise "Unknown file type: #{file.original_filename}"
        end
        #add each checked user to the database
        checked_users.each do |checked_user|
            checked_user.save
        end
    end
end
