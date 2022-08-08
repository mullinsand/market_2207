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
end
