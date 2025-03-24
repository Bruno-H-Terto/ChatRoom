require 'rails_helper'

RSpec.describe Room, type: :model do
  context 'validations' do
    it { should have_many(:messages) }
    it { should have_many(:users).through(:messages) }
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(128) }
  end
end
