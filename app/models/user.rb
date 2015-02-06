class User < ActiveRecord::Base
  after_initialize :set_token
  attr_readonly :token

  private

  def set_token
    self.token = SecureRandom.hex if new_record?
  end
end
