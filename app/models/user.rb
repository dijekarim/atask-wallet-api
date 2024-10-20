require 'digest'

class User < ActiveRecord::Base
  validates :username, presence: true
  validates :username, uniqueness: true

  def authenticate(password)
    self.password_digest == Digest::SHA256.hexdigest("#{self.salt}-#{password}")
  end

  def generate_digest(password)
    self.password_digest = Digest::SHA256.hexdigest("#{self.salt}-#{password}")
  end
end
