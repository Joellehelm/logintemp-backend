class User < ApplicationRecord
    has_secure_password
    validates :username, :email, uniqueness: { case_sensitive: false }
end
