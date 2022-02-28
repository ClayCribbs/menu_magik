class PredictionEngine
  attr_accessor :total_query, :day_query

  def initialize(options = {})
    options = {
      menu_item_id:   OrderItem.where(menu_item_representation_id: MenuItemRepresentation.where('menu_item_id != ?', 1).pluck(:id)).first.menu_item_representation.menu_item_id,
      order_id:       Order.find(1).id,
      user_id:        Order.find(1).user.id,
    }

    @total_query = MenuItemPredictionQuery.new(options).execute
    options.merge(day_of_week: 6)
    @day_query   = MenuItemPredictionQuery.new(options).execute
    [total_query[0], day_query[0]].map(&:hash_rows)
  end

  def total_query
    @total_query
  end

  def global_user_comparison(user_ordered, all_users_ordered)
    user_portion   = ( percentage(user_ordered)      * global_user_weight )
    global_portion = ( percentage(all_users_ordered) * global_all_users_weight )
    (user_portion + global_portion)
  end
end
