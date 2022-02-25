require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe '#validate' do
    include_examples 'validates presence of', [ #required field
                                                :restaurant_id,
                                                :status,
                                                :title,
                                              ]
  end

  context 'associations' do
    [  #model       #association
      [:restaurant, :belongs_to],
      [:menu_items, :has_many],
    ].each do |model, association|
      include_examples 'associates_with', model, association
    end
  end
end
