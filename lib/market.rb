require 'date'

class Market
  attr_reader :name,
              :vendors,
              :date
  def initialize(name)
    @name = name
    @vendors = []
    @date = Date.today.strftime("%d/%m/%Y")
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map(&:name)
  end

  def vendors_that_sell(item)
    @vendors.reject do |vendor|
      vendor.check_stock(item) <= 0
    end
  end
  
  def total_quantity(item)
    vendors_that_sell(item).sum { |vendor| vendor.check_stock(item)}
  end

  def total_inventory
    total_inventory = Hash.new
    items_list = @vendors.reduce([]) do |all_items, vendor|
      all_items + vendor.inventory.keys
    end.uniq
    items_list.each do |item|
      total_inventory[item] = { quantity: total_quantity(item),
                                vendors: vendors_that_sell(item)}
    end
    total_inventory
  end

  def overstocked_items
    overstocked_items = []
    total_inventory.each do |item, info|
      overstocked_items << item if info[:quantity] > 50 && info[:vendors].length > 1
    end
    overstocked_items
  end

  def sorted_item_list
    total_inventory.keys.map(&:name).sort
  end

  def sell(item, sell_quantity)
    return false if 
    !total_inventory.keys.include?(item) || total_inventory[item][:quantity] < sell_quantity
    current_amt = sell_quantity
    total_inventory[item][:vendors].each do |vendor|
      return if current_amt == 0
      if vendor.check_stock(item) <= current_amt
        current_amt -= vendor.check_stock(item)
        vendor.stock(item, -vendor.check_stock(item))
      elsif vendor.check_stock(item) > current_amt
        vendor.stock(item, -current_amt)
        current_amt = 0
      end
    end
    true
  end
end
