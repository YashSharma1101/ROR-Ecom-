class HomesController < ApplicationController

  def index
    @products = Product.all
    @categories = Category.all
  end

  def search
    @query = params[:query]
    @products = Product.where("name LIKE ?", "%#{@query}%")
    @categories = Category.where("name LIKE ?", "%#{@query}%")
    render :index
  end
  
end
