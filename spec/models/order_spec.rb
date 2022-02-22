require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#validate' do
    include_examples 'validates presence of', [ #required field
                                                :status,
                                                :user_id
                                              ]
  end

  context 'associations' do
    [  #model        #association
      [:order_items, :has_many],
      [:user,        :belongs_to],
    ].each do |model, association|
      include_examples 'associates_with', model, association
    end
  end
end
