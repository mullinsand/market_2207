require './lib/item'
require './lib/vendor'

describe Vendor do
  let(:item1){Item.new({name: 'Peach', price: "$0.75"})}
  let(:item2){Item.new({name: 'Tomato', price: '$0.50'})}
  let(:vendor){Vendor.new("Rocky Mountain Fresh")}

  it 'exists and has attributes' do
    expect(vendor).to be_instance_of(Vendor)
    expect(vendor.name).to eq("Rocky Mountain Fresh")
    expect(vendor.inventory).to eq({})
  end

  it '#stocks items' do
    vendor.stock(item1, 30)
    expect(vendor.inventory).to eq({item1 => 30})
    vendor.stock(item2, 25)
    expect(vendor.inventory).to eq({
      item1 => 30,
      item2 => 25
    })
  end

  it '#checks stock' do
    vendor.stock(item1, 30)
    expect(vendor.check_stock(item1)).to eq(30)
    expect(vendor.check_stock(item2)).to eq(0)
    vendor.stock(item1, 25)
    expect(vendor.check_stock(item1)).to eq(55)
  end
end