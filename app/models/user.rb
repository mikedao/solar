class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, 
                       uniqueness: true,
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers and underscores" }
  
  validates :email, presence: true, 
                    uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  
  validates :password, presence: true, 
                       length: { minimum: 8 },
                       if: -> { new_record? || !password.nil? }
end
