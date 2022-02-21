require 'rails_helper'

RSpec.describe MenuAssignment, type: :model do
  describe '#validate' do
    include_examples 'validates presence of', [ #required field
                                                :menu_id,
                                                :menu_item_id
                                              ]
  end

  context 'associations' do
    [  #model      #association
      [:menu,      :belongs_to],
      [:menu_item, :belongs_to],
    ].each do |model, association|
      include_examples 'associates_with', model, association
    end
  end
end
