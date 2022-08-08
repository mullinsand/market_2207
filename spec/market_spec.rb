require './lib/item'
require './lib/vendor'
require './lib/market'

describe Market do
  let(:item1){Item.new({name: 'Peach', price: "$0.75"})}
  let(:item2){Item.new({name: 'Tomato', price: '$0.50'})}
  let(:item3){Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})}
  let(:item4){Item.new({name: "Banana Nice Cream", price: "$4.25"})}
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

end