require 'rails_helper'

RSpec.describe HomesController, type: :controller do
  
  before(:each) do
    @user = FactoryBot.create(:user)
    sign_in @user
  end

  describe 'GET #index' do

    it 'assigns all products and categories' do
      category = FactoryBot.create(:category)
      product = FactoryBot.create(:product, category: category)
      get :index
      # expect(response).to be_successful
      expect(assigns(:products)).to eq(Product.all)
      expect(assigns(:categories)).to eq(Category.all)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET #search' do

    it 'assigns products based on the search query' do
      category = create(:category, name: 'Electronics') # Create a valid category
      product1 = create(:product, name: 'Apple iPhone 13', category: category)
      product2 = create(:product, name: 'Samsung Galaxy S21', category: category)
      get :search, params: { query: 'Galaxy' }

      expect(assigns(:query)).to eq('Galaxy')
      expect(assigns(:products)).to eq([product2])
      expect(response).to render_template(:index)
    end

    it 'assigns category based on the search query' do
      category = create(:category, name: 'Electronics') # Create a valid category
      get :search, params: { query: 'Electronics' }

      expect(assigns(:query)).to eq('Electronics')
      expect(assigns(:categories)).to eq([category]) 
      expect(response).to render_template(:index)
    end

    it 'renders the index template' do
      get :search, params: { query: 'iPhone' }

      expect(response).to render_template(:index)
    end
  end
end

