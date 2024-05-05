require "rails_helper"

RSpec.describe Customer, type: :model do
  describe "validations" do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }

    it { should allow_value("something@something.something").for(:email) }
    it { should_not allow_value("something somthing@something.something").for(:email) }
    it { should_not allow_value("something.something@").for(:email) }
    it { should_not allow_value("something").for(:email) }
  end

  describe "relationships" do
    it { should have_many :subscriptions }
  end
end