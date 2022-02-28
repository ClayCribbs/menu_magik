module MenuItemSelects
  include SelectsHelper

  def total_for_menu_item(menu_item_id)
    return unless menu_item_id
    <<-SQL
      , #{count_case(menu_item_select_sql(menu_item_id))} AS total_for_menu_item
    SQL
  end

  def total_for_all_menu_items
    <<-SQL
      , #{count_case("menu_item_representations.id IS NOT NULL ")} AS total_for_all_menu_items
    SQL
  end
end
