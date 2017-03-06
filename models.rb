ActiveRecord::Base.establish_connection("sqlite3:db/development.db")

class User < ActiveRecord::Base
    has_secure_password
    validates :mail,
        presence: true,
        format: {with:/.+@.+/}
    validates :password,
        length: {in: 5..10}
end

class Contribution < ActiveRecord::Base
end