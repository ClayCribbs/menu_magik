class RepresentationStiType < ActiveRecord::Type::String
  def cast_value(value)
    case value
    when 'menu'; 'MenuItemRepresentation'
    when 'order'; 'OrderItemRepresentation'
    else super
    end
  end

  def serialize(value)
    case value
    when 'menu'; 'MenuItemRepresentation'
    when 'order'; 'OrderItemRepresentation'
    when 'MenuItemRepresentation'; 'menu'
    when 'OrderItemRepresentation'; 'order'
    else super
    end
  end

  def changed_in_place?(original_value_for_database, value)
    original_value_for_database != serialize(value)
  end
end