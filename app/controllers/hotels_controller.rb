class HotelsController < ApplicationController
  before_action :set_hotel, only: [:show, :edit, :update, :destroy, :update_picture]

  # GET /hotels
  # GET /hotels.json
  def index
    @hotels = Hotel.all
  end

  # GET /hotels/1
  # GET /hotels/1.json
  def show
  end

  # GET /hotels/new
  def new
    @hotel = Hotel.new
  end

  # GET /hotels/1/edit
  def edit
  end

  # POST /hotels
  # POST /hotels.json
  def create
    rand_hex = SecureRandom.hex(10)
    pimage = params[:hotel][:hotel_pic]
    if(pimage==nil)
      flash[:notice]= "Please attach your profile picture"
      redirect_to new_hotel_path
      return
    end
    puts pimage.original_filename
    @uploadedFile=pimage
    cl_response = Cloudinary::Uploader.upload(@uploadedFile.tempfile, :public_id => rand_hex)
    if(cl_response['secure_url']==nil)
      flash[:notice]= "There is a server side problem. Please try again later"
      redirect_to new_hotel_path
      return
    end
    params[:hotel][:hotel_pic_path]=cl_response['secure_url']
    puts "\n\n\n"
    puts params.inspect

    @hotel = Hotel.new(hotel_params)
    respond_to do |format|
      if @hotel.save
        format.html { redirect_to @hotel, notice: 'Hotel was successfully created.' }
        format.json { render :show, status: :created, location: @hotel }
      else
        format.html { render :new }
        format.json { render json: @hotel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hotels/1
  # PATCH/PUT /hotels/1.json
  def update
    respond_to do |format|
      if @hotel.update(hotel_params)
        format.html { redirect_to @hotel, notice: 'Hotel was successfully updated.' }
        format.json { render :show, status: :ok, location: @hotel }
      else
        format.html { render :edit }
        format.json { render json: @hotel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hotels/1
  # DELETE /hotels/1.json
  def destroy
    @hotel.destroy
    respond_to do |format|
      format.html { redirect_to hotels_url, notice: 'Hotel was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def update_picture
    puts "\n\nUpdating picture"
    puts params.inspect
    puts "\n\n\n"
    if(current_user==nil || current_user.role.id!=0)
      flash[:notice]= "You must be an admin to change a hotel picture"
      redirect_to edit_hotel_path(@hotel)
      return
    end
    rand_hex = SecureRandom.hex(10)
    pimage = params[:hotel_pic]
    if(pimage!=nil)
      puts pimage.original_filename
      @uploadedFile=pimage
      cl_response = Cloudinary::Uploader.upload(@uploadedFile.tempfile, :public_id => rand_hex)
      if(cl_response['secure_url']==nil)
        flash[:notice]= "There is a server side problem. Please try again later"
        redirect_to edit_hotel_path(@hotel)
        return
      end
      @hotel.update(hotel_pic_path: cl_response['secure_url'])
      redirect_to edit_hotel_path(@hotel)
    else
      redirect_to edit_hotel_path(@hotel)
    end
    return
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hotel
      @hotel = Hotel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hotel_params
      params.require(:hotel).permit(:name, :slogan, :location, :hotel_pic_path, :description)
    end
end
