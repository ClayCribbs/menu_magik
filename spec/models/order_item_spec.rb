require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe '#validate' do
    include_examples 'validates presence of', [ #required field
                                                :menu_item_representation_id,
                                                :order_id
                                              ]
  end

  context 'associations' do
    [  #model                     #association
      [:menu_item_representation, :belongs_to],
      [:order,                    :belongs_to],
    ].each do |model, association|
      include_examples 'associates_with', model, association
    end
  end
end
