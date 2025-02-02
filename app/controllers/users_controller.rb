require 'rqrcode'

class UsersController < ApplicationController
  def new
    @user = User.new
    @package = Package.find_by(id: params[:package_id])
    return redirect_to root_path, alert: 'Package not found' if @package.nil?
  end

  def create
    @user = User.new(user_params)
    @package = Package.find_by(id: params[:user][:package_id])

    if @package.nil?
      flash.now[:alert] = "Package not found"
      render :new, status: :unprocessable_entity
      return
    end

    @user.package = @package
    @user.role = :member

    # Handle mobile phone validation
    full_number = params[:user][:mobile]
    parsed_number = Phonelib.parse(full_number)
    @user.mobile = parsed_number.e164 if parsed_number.valid?

    if @user.save
      redirect_to qr_code_user_path(@user), notice: "Please complete the payment to become a member."
    else
      @user.errors.add(:mobile, "Invalid phone number") if parsed_number.invalid?
      render :new, status: :unprocessable_entity
    end
  end

  def show_qr
    @user = User.find(params[:id])

    # Generate QR code with user details in JSON format
    user_data = {
      id: @user.id,
      name: @user.name,
      email: @user.email,
      mobile: @user.mobile,
      country_code: @user.country_code,
      location: @user.location
    }.to_json

    @qr_code = RQRCode::QRCode.new(user_data)
  end

  def get_states
    country = params[:country]&.upcase
    states = CS.states(country).map { |code, name| { code: code, name: name } }
    render json: states
  end

  def get_cities
    country = params[:country]&.upcase
    state_name = params[:state]
    cities = CS.cities(state_name, country) || []
    render json: cities
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :country, :password, :password_confirmation, :state, :city, 
      :other_city, :mobile, :email, :profession, :age, 
      :sex, :height, :weight, :package_id, :role
    )
  end
end
