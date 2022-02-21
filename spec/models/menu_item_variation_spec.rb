require 'rails_helper'

RSpec.describe MenuItemVariation, type: :model do
  describe '#validate' do
    include_examples 'validates presence of', [ #required field
                                                :parent_item_id,
                                                :child_item_id
                                              ]
  end

  context '#parents' do
    it 'has many parents' do
      association_to_parents = MenuItem.reflect_on_association(:parents)
      expect(association_to_parents.macro).to eq(:has_many)
    end
  end

  context '#children' do
    it 'has many children' do
      association_to_children = MenuItem.reflect_on_association(:children)
      expect(association_to_children.macro).to eq(:has_many)
    end
  end
end
