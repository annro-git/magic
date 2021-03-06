class CategoriesController < ApplicationController
  before_action :authenticate_user!

  add_breadcrumb 'home', :root_path
  add_breadcrumb 'My decks', :user_decks_path
  add_breadcrumb 'Categories', :categories_path

  def index
    @categories = current_user.categories
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.create(category_params.merge(user_id: current_user.id))
    if @category.valid?
      redirect_to categories_path
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def category_params
    params.require('category').permit(:name)
  end
end
