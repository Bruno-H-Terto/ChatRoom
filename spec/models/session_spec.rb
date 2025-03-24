require 'rails_helper'

RSpec.describe Session, type: :model do
  context 'validations' do
    it { should belong_to(:user) }
  end
end
