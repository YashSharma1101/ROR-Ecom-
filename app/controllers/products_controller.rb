class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
  end

def create
    @product = Product.find(params[:product_id])
end

end
