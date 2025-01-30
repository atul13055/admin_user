require 'rqrcode'
class UsersController < ApplicationController
  def new
    @user = User.new
    @package = Package.find(params[:package_id])
  end

  def create
    @user = User.new(user_params)
    @package = Package.find(params[:user][:package_id])
    @user.package = @package

    if @user.save
      redirect_to qr_code_user_path(@user), notice: "Please complete the payment to become a member."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # def show_qr
  #   @user = User.find(params[:id])
  #   # Generate a dynamic payment URL (Replace with actual logic)
  #   #payment_url = "https://your-payment-gateway.com/pay?user_id=#{@user.id}&amount=100"
  #   # Generate QR code
  #   #@qr_code = RQRCode::QRCode.new(payment_url)
  #   @qr_code = RQRCode::QRCode.new(@user.id.to_s)
  #     # @qr_code = RQRCode::QRCode.new(user_profile_url(@user))
  # end
  def show_qr
    @user = User.find(params[:id])

    # Convert user details into a structured string (JSON format)
    user_data = {
      id: @user.id,
      name: @user.name,
      email: @user.email,
      mobile: @user.mobile,
      location: @user.location
    }.to_json # Convert hash to JSON string

    # Generate QR code with user details
    @qr_code = RQRCode::QRCode.new(user_data)
  end

  private

  def user_params
    params.require(:user).permit(:name, :location, :mobile, :email, :profession, :age, :sex, :height, :weight, :package_id)
  end
end
