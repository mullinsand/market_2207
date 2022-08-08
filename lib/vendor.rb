class Vendor
  attr_reader :name,
              :inventory
  def initialize(name)
    @name = name
    @inventory = Hash.new{|h,k| h[k] = 0}
  end

  def stock(item, amt)
    @inventory[item] += amt
  end

  def check_stock(item)
    @inventory[item]
  end

  def potential_revenue
    @inventory.sum do |item, amt|
      item.price * amt
    end.round(2)
  end
end
