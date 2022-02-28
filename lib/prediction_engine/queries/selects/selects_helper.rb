module SelectsHelper
  def menu_item_select_sql(menu_item_id)
    <<-SQL
      menu_item_representations.menu_item_id = #{menu_item_id}
    SQL
  end

  def user_select_sql(user_id)
    <<-SQL
      orders.user_id = #{user_id}
    SQL
  end

  def root_menu_item_select_sql
    <<-SQL
      menu_item_representations.parent_id IS NULL
    SQL
  end

  def count_case(case_sql)
    <<-SQL
      COUNT(CASE WHEN #{case_sql} THEN 1 ELSE NULL END)
    SQL
  end
end
