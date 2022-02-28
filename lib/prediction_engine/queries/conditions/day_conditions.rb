module DayConditions
  def on_day_of_week(day_of_week)
    <<-SQL
      AND EXTRACT(dow FROM orders.created_at) = #{day_of_week}
    SQL
  end
end
