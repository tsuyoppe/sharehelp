ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:db/development.db")

class User < ActiveRecord::Base
    has_secure_password
    validates :mail,
        presence: true,
        format: {with:/.+@.+/}
    validates :password,
        length: {in: 5..10}
end

class Contribution < ActiveRecord::Base
    belongs_to :category
end

class Category < ActiveRecord::Base
    has_many :contributions
end