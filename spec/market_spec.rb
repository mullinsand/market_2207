require './lib/item'
require './lib/vendor'
require './lib/market'
require 'date'

describe Market do
  let(:item1){Item.new({name: 'Peach', price: "$0.75"})}
  let(:item2){Item.new({name: 'Tomato', price: '$0.50'})}
  let(:item3){Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})}
  let(:item4){Item.new({name: "Banana Nice Cream", price: "$4.25"})}
  let(:item5){Item.new({name: 'Onion', price: '$0.25'})}

  let(:vendor1){Vendor.new("Rocky Mountain Fresh")}
  let(:vendor2){Vendor.new("Ba-Nom-a-Nom")}
  let(:vendor3){Vendor.new("Palisade Peach Shack")}
  let(:market){Market.new("South Pearl Street Farmers Market")}

  it 'exists and has attributes' do
    expect(market).to be_instance_of(Market)
    expect(market.name).to eq("South Pearl Street Farmers Market")
    expect(market.vendors).to eq([])
  end

  it '#add_vendors' do
    market.add_vendor(vendor1)
    expect(market.vendors).to eq([vendor1])
    market.add_vendor(vendor2)
    market.add_vendor(vendor3)
    expect(market.vendors).to eq([vendor1, vendor2, vendor3])
  end

  it 'lists vendor names' do
    market.add_vendor(vendor1)
    market.add_vendor(vendor2)
    market.add_vendor(vendor3)
    expect(market.vendor_names).to eq(["Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack"])
  end

  it 'lists vendors that sell an item' do
    vendor1.stock(item1, 35)
    vendor1.stock(item2, 7)
    vendor2.stock(item4, 50)
    vendor2.stock(item3, 25)
    vendor3.stock(item1, 65)
    market.add_vendor(vendor1)
    market.add_vendor(vendor2)
    market.add_vendor(vendor3)
    expect(market.vendors_that_sell(item1)).to eq([vendor1, vendor3])
    expect(market.vendors_that_sell(item4)).to eq([vendor2])
  end

  it 'checks total quantity of an item' do
    vendor1.stock(item1, 35)
    vendor1.stock(item2, 7)
    vendor2.stock(item4, 50)
    vendor2.stock(item3, 25)
    vendor3.stock(item1, 65)
    market.add_vendor(vendor1)
    market.add_vendor(vendor2)
    market.add_vendor(vendor3)
    expect(market.total_quantity(item1)).to eq(100)
    expect(market.total_quantity(item2)).to eq(7)
  end

  it 'show total_inventory of market' do
    vendor1.stock(item1, 35)
    vendor1.stock(item2, 7)
    vendor2.stock(item4, 50)
    vendor2.stock(item3, 25)
    vendor3.stock(item1, 65)
    vendor3.stock(item3, 10)
    market.add_vendor(vendor1)
    market.add_vendor(vendor2)
    market.add_vendor(vendor3)
    expect(market.total_inventory).to eq({
      item1 => { quantity: 100,
                  vendors: [vendor1, vendor3]},
      item2 => { quantity: 7,
                  vendors: [vendor1]},
      item4 => { quantity: 50,
                  vendors: [vendor2]},
      item3 => { quantity: 35,
                  vendors: [vendor2, vendor3]}
    })
  end

  it 'identifies overstocked_items' do
    vendor1.stock(item1, 35)
    vendor1.stock(item2, 7)
    vendor2.stock(item4, 50)
    vendor2.stock(item3, 25)
    vendor3.stock(item1, 65)
    vendor3.stock(item3, 10)
    market.add_vendor(vendor1)
    market.add_vendor(vendor2)
    market.add_vendor(vendor3)
    expect(market.overstocked_items).to eq([item1])
  end

  it 'creates a sorted_item_list' do
    vendor1.stock(item1, 35)
    vendor1.stock(item2, 7)
    vendor2.stock(item4, 50)
    vendor2.stock(item3, 25)
    vendor3.stock(item1, 65)
    vendor3.stock(item3, 10)
    market.add_vendor(vendor1)
    market.add_vendor(vendor2)
    market.add_vendor(vendor3)
    expect(market.sorted_item_list).to eq([
      "Banana Nice Cream", "Peach", "Peach-Raspberry Nice Cream", "Tomato"
    ])
  end

  it 'has a date' do
    allow(Date).to receive(:today).and_return(Date.new(2020, 02, 24))
    market = Market.new("South Pearl Street Farmers Market")
    expect(market.date).to be_instance_of(String)
    expect(market.date).to eq("24/02/2020")
  end

  it 'can sell items' do
    vendor1.stock(item1, 35)
    vendor1.stock(item2, 7)
    vendor2.stock(item4, 50)
    vendor2.stock(item3, 25)
    vendor3.stock(item1, 65)
    market.add_vendor(vendor1)
    market.add_vendor(vendor2)
    market.add_vendor(vendor3)
    expect(market.sell(item1, 200)).to eq(false)
    expect(market.sell(item5, 1)).to eq(false)
    expect(market.sell(item4, 5)).to eq(true)
    market.sell(item1, 40)
    expect(vendor1.check_stock(item1)).to eq(0)
    expect(vendor3.check_stock(item1)).to eq(60)
  end
end