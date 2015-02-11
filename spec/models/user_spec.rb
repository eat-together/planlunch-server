require 'rails_helper'

RSpec.describe User, :type => :model do
  it "has token set after creation" do
    user = User.new(name: 'foo', email: 'foo', password: 'foo')
    expect(user.token.length).to eq(32)
  end

  it "token can not be set" do
    user = User.create(name: 'foo', email: 'foo', password: 'foo')
    token = user.token
    user.update(token: "foobar")
    expect(token).to eq(User.last.token)
  end
end
