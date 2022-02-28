class MenuItemPredictionQuery < BasePredictionQuery
  include MenuItemSelects
  include UserSelects
  include RootRepresentationSelects
  include DayConditions

  def initialize(options = {})
    @menu_item_id = options[:menu_item_id]
    @user_id      = options[:user_id]
    @day_of_week  = options[:day_of_week]
  end

  def selects
    super + [
      total_for_menu_item(@menu_item_id),
      total_for_all_menu_items,
      total_for_menu_item_and_user(@menu_item_id, @user_id),
      total_for_all_menu_items_and_user(@user_id),
      total_for_root_menu_item_and_user(@menu_item_id, @user_id),
      total_for_root_menu_item_for_all_users(@user_id),
      total_roots_for_all_users,
    ].join(' ')
  end

  def conditions
    if @day_of_week.present?
      super + on_day_of_week(@day_of_week)
    else
      super
    end
  end
end
