require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { should have_secure_password }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should have_one(:session) }
    it { should have_many(:messages) }
    it { should have_many(:rooms).through(:messages) }
  end

  context '#valid?' do
    it 'email must be uniqueness' do
      user = User.create!(name: 'Test', email: 'test@email.com', password: '123456')

      other_user = User.new(name: 'Other', email: 'test@email.com', password: '123456')

      expect(other_user).not_to be_valid
    end

    it 'must be correct format' do
      user = User.new(name: 'Other', email: 'test', password: '123456')

      expect(user.save).to eq false
      expect(user.errors.full_messages.to_sentence).to eq 'E-mail não é válido'
    end
  end
end
