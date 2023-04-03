class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user

  end

  def show
    item = Item.find(params[:id])
    render json: item
  end 

  def create
    user = User.find(params[:user_id])
    item = user.items.create(item_params)
    render json: item, status: :created
  # rescue ActiveRecord::RecordInvalid => invalid 
  #   render json:{erros:invalid.record.errors.full_message}, status: :unprocessable_entity
  end 

  private

  def item_params
    params.permit(:name, :description, :price)
  end

  def render_not_found_response(exception)
    render json: { error: "#{exception.model} not found" }, status: :not_found
  end

end
