require 'rails_helper'

RSpec.describe Role, type: :model do
  let(:role) {build :role}

  it "is a valid role" do
    expect(role).to be_valid
  end

  it "has no name" do
    role.name = ""
    role.valid?
    expect(role.errors[:name]).to include(
      t "activerecord.errors.messages.blank"
    )
  end
end
