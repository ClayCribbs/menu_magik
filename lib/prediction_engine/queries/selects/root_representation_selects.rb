module RootRepresentationSelects
  include SelectsHelper

  def total_for_root_menu_item_and_user(menu_item_id, user_id)
    return unless menu_item_id
    return unless user_id
    <<-SQL
      , #{count_case("#{menu_item_select_sql(menu_item_id)} AND
      #{user_select_sql(user_id)} AND
      #{root_menu_item_select_sql} ")} AS total_for_root_menu_item_and_user
    SQL
  end

  def total_for_root_menu_item_for_all_users(menu_item_id)
    return unless menu_item_id
    <<-SQL
      , #{count_case("#{menu_item_select_sql(menu_item_id)} AND
                      #{root_menu_item_select_sql} ")} AS total_for_root_menu_item_for_all_users
    SQL
  end

  def total_roots_for_all_users
    <<-SQL
      , #{count_case("#{root_menu_item_select_sql} ")} AS total_roots_for_all_users
    SQL
  end
end
