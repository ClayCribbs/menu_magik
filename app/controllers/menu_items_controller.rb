class MenuItemsController < ApplicationController
  def new
  end

  def create
  end

  def index
    @menu_items = MenuItem.all
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
