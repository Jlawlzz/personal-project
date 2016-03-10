require 'rails_helper'

RSpec.describe Invite, type: :model do
  it "invites group users" do

    user = User.create(name: "Jordan", uid: '1')
    users = ['1']

    group = Group.create
    group.users << user

    Invite.send_invite(users, group)

    expect(Invite.all.count).to eq 1
    expect(user.invites.count).to eq 1
  end
end
