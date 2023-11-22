require 'rails_helper'

RSpec.describe Product, type: :model do
  context 'when creating a user' do
    let(:product) { build :product }
    it 'should be a valid product name with all attributes' do
      expect(product.name).to eq("PocoM4")
    end
    it 'should be a valid product price with all attributes' do
      expect(product.price).to eq(15600)
    end
    # it 'should be a valid product with all attributes' do
    #   expect(product.valid?).to eq(true) 
    # end
  end
end
