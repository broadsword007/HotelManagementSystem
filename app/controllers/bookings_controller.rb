class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy, :checkout_booking]
  skip_before_action :verify_authenticity_token, only: [:add_booking]
  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = Booking.all
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
    @categories = RoomCategory.all
    @users = User.all
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @categories = RoomCategory.all
    @users = User.all
    user = User.find_by_id(params[:booking][:customer_id])
    cat_id = (params[:booking][:room_category_id]).to_i
    validRoom = nil
    Room.all.each do |room|
      if room.room_category.id==cat_id and room.isAvailable==true
        validRoom = room
      end
    end
    if(validRoom==nil)
      flash[:notice]="No room available in this category"
      redirect_to new_booking_path
      return
    end
    params[:booking][:room_id] = validRoom.id
    params[:booking][:user_id]= user.id
    params[:booking][:hasCheckedOut]= false
    puts "\n\n\n Params: #{params.inspect}"
    @booking = Booking.new(booking_params)

    respond_to do |format|
      if @booking.save
        validRoom.isAvailable = false
        validRoom.user = user
        validRoom.save
        format.html { redirect_to adminpanel_path, notice: 'Booking was successfully created.' }
        format.json { render :show, status: :created, location: @booking }
      else
        format.html { render :new }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    params[:booking][:room_id]=@booking.room.id
    params[:booking][:user_id]= @booking.user.id
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to adminpanel_path, notice: 'Booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url, notice: 'Booking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def checkout_booking
    @booking.hasCheckedOut=true
    @booking.room.isAvailable=true
    @booking.room.user=nil
    @booking.save
    @booking.room.save
    redirect_to adminpanel_path
    return
  end
  def check_availability
    puts "\n\n\n\n In check avaiability"
    puts params.inspect
    puts "\n\n\n\n"
    custom_params
    cat_id=(params[:booking][:room_category_id]).to_i
    from=(params[:booking][:from]).to_date
    to=(params[:booking][:to]).to_date
    Room.all.each do |room|
      if room.room_category.id==cat_id and room.isAvailable==true
        render json:{
           "success" => true,
           "reason" => "A room for given category is available",
           "params" => {"room_category_id" => cat_id,
                        "from" => from,
                        "to" => to}
        }.to_json
        return
      end
    end
    render json:{
       "success" => false,
       "reason" => "No room for given category is available",
    }.to_json
    return
  end
  def add_booking
    if(!user_signed_in?)
      render json:{
          "success" => false,
          "reason" => "You must be signed in to book",
      }.to_json
      return
    end
    pbooking = params[:booking]
    cat_id = pbooking[:room_category_id]
    from = (pbooking[:from]).to_date
    to = (pbooking[:to]).to_date
    Room.all.each do |room|
      if(room.isAvailable)
        @availableRoom = room
        break
      end
    end
    if(@availableRoom!=nil)
      booking = Booking.new
      booking.from=from
      booking.to=to
      booking.hasCheckedOut=false
      booking.room=@availableRoom
      booking.user=current_user
      booking.save
      booking.room.isAvailable=false
      booking.room.user=current_user
      booking.room.save
      render json:{
          "success" => true,
          "reason" => "",
      }.to_json
      return
    end
    render json:{
        "success" => false,
        "reason" => "No room available in this category",
    }.to_json
    return
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:user_id, :room_id, :from, :to, :hasCheckedOut)
    end
    def custom_params
      params.require(:booking).permit(:room_category_id, :from, :to, :user_id)
    end
end
