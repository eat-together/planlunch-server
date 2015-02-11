class User < ActiveRecord::Base
  after_initialize :set_token
  attr_readonly :token

  validates_presence_of :name, :password, :token
  validates_uniqueness_of :name

  private

  def set_token
    self.token = SecureRandom.hex if new_record?
  end
end
