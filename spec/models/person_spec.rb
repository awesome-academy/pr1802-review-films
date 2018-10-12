require 'rails_helper'

RSpec.describe Person, type: :model do
  let(:person) {build :person}

  it "is a valid person" do
    expect(person).to be_valid
  end

  it "has no name" do
    person.name = ""
    person.valid?
    expect(person.errors[:name]).to include(
      t "activerecord.errors.messages.blank"
    )
  end
end
