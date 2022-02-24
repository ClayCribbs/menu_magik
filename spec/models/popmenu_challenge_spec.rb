require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  context 'when ensuring it passes the Popmenu challenge' do
    it 'exists' do
    end

    it 'has many menus' do
    end

    it 'has many menu_items' do
    end

    it 'shares menu_items between menus' do
    end
  end
end

RSpec.describe Menu, type: :model do
  context 'when ensuring it passes the Popmenu challenge' do
    it 'exists' do
    end

    it 'has many menu_items' do
    end

    it 'has a title that is unique to restaurant' do
    end
  end
end

RSpec.describe MenuItem, type: :model do
  context 'when ensuring it passes the Popmenu challenge' do
    it 'exists' do
    end

    it 'has many menus' do
    end

    it 'has a title that is unique to restaurant' do
    end
  end
end

RSpec.describe User, type: :model do
  context 'when ensuring it passes the Popmenu challenge' do
    it 'exists' do
    end

    it 'has many orders' do
    end

    it 'has many order_items' do
    end

    context 'can order a dinner salad' do
      context 'as a standalone dish' do
        context 'with a selection of dressing' do
        end
      end

      context 'as a side of another item' do
        context 'with a selection of dressing' do
        end
      end
    end
  end
end

RSpec.describe Order, type: :model do
  context 'when ensuring it passes the Popmenu challenge' do
    it 'exists' do
    end

    it 'has many menu_item_representations' do
    end

    it 'has a title that is unique to restaurant' do
    end
  end
end
