require 'digest'

class User < ActiveRecord::Base
  validates :username, presence: true
  validates :username, uniqueness: true
  has_many :wallets
  has_many :credits
  has_many :debits

  def balance
    wallets.sum(:amount)
  end

  def authenticate(password)
    self.password_digest == Digest::SHA256.hexdigest("#{self.salt}-#{password}")
  end

  def generate_digest(password)
    self.password_digest = Digest::SHA256.hexdigest("#{self.salt}-#{password}")
  end
end
