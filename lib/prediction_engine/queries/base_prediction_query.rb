class BasePredictionQuery
  def initialize(options = {})
  end

  def selects
    <<-SQL
      MAX(order_items.created_at) as last_ordered
    SQL
  end

  def conditions
    <<-SQL
      WHERE orders.id IS NOT NULL
    SQL
  end

  def group_bys
    <<-SQL
    SQL
  end

  def execute
    ActiveRecord::Base.connection.select_all(query)
  end

  def query
    base_query(selects, conditions)
  end

  def base_query(selects, conditions)
    <<-SQL
      SELECT
        #{selects}
      FROM orders
        LEFT JOIN order_items ON order_items.order_id = orders.id
        LEFT JOIN menu_item_representations ON order_items.menu_item_representation_id = menu_item_representations.id
        LEFT JOIN menu_items ON menu_item_representations.menu_item_id = menu_items.id
      #{conditions}
      #{group_bys}
    SQL
  end
end

