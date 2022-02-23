RSpec.shared_context 'with a namespaced menu_item_representation tree', shared_context: :metadata do
  let!(:greatgrandparent) { create(:menu_item_representation) }
  let!(:granduncle)       { create(:menu_item_representation, parent: greatgrandparent) }
  let!(:grandparent)      { create(:menu_item_representation, parent: greatgrandparent) }
  let!(:parent)           { create(:menu_item_representation, parent: grandparent) }
  let!(:uncle)            { create(:menu_item_representation, parent: grandparent) }
  let!(:established_mir)  { create(:menu_item_representation, parent: parent) }
  let!(:sibling)          { create(:menu_item_representation, parent: parent) }
  let!(:child)            { create(:menu_item_representation, parent: established_mir) }
  let!(:nephew)           { create(:menu_item_representation, parent: sibling) }
  let!(:grandchild)       { create(:menu_item_representation, parent: child) }
end
