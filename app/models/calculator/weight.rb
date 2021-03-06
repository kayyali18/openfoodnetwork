module Calculator
  class Weight < Spree::Calculator
    preference :per_kg, :decimal, default: 0.0
    attr_accessible :preferred_per_kg

    def self.description
      I18n.t('spree.weight')
    end

    def compute(object)
      line_items = line_items_for object
      total_weight = line_items.sum { |li| ((li.variant.andand.weight || 0) * li.quantity) }
      total_weight * preferred_per_kg
    end

    private

    def line_items_for(object)
      if object.respond_to? :order
        object.order.line_items
      elsif object.respond_to? :line_items
        object.line_items
      elsif object.respond_to?(:variant) && object.respond_to?(:quantity)
        [object]
      else
        raise "Unknown object type: #{object.inspect}"
      end
    end
  end
end
