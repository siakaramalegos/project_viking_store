class Admin::OrdersController < ApplicationController
  layout 'admin'
  before_action :set_user, except: [:all_orders]
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_params

  def all_orders
    # TODO: add pagination
    @orders = Order.all.limit(100)
  end

  def index
    @orders = @user.orders
  end

  def show
    @card = @order.credit_card
    @contents = @order.order_contents
    @order.checkout_date ? @title = "Order" : @title = "Shopping Cart"
  end

  def new

    @order = @user.orders.new
  end

  def create
    @order = @user.orders.new(order_params)

    if @order.save
      redirect_to edit_admin_user_order_url(@user, @order), notice: 'Order successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @order.checkout_date.nil? && params[:order][:status] == 'PLACED'
      @order.checkout_date = Time.now
    elsif @order.checkout_date && params[:order][:status] == 'UNPLACED'
      @order.checkout_date = nil
    end

    if @order.update(order_params)
      redirect_to admin_user_order_url(@user, @order), notice: 'Order successfully saved.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def invalid_params
    redirect_to admin_orders_path, alert: 'The page you attempted to view could not be found.'
  end

  def order_params
    params.require(:order).permit(:shipping_id, :billing_id, :credit_card_id)
  end
end
