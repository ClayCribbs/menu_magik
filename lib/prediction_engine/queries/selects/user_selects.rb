module UserSelects
  include SelectsHelper

  def total_for_menu_item_and_user(menu_item_id, user_id)
    return unless menu_item_id
    return unless user_id
    <<-SQL
      , #{count_case("#{menu_item_select_sql(menu_item_id)} AND
                    #{user_select_sql(user_id)} ")} AS total_for_menu_item_and_user
    SQL
  end

  def total_for_all_menu_items_and_user(user_id)
    return unless user_id
    <<-SQL
      , #{count_case("#{user_select_sql(user_id)} ")} AS total_for_all_menu_items_and_user
    SQL
  end
end
