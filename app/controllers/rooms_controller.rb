class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy, :update_picture]

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @room = Room.new
    @categories = RoomCategory.all
    puts "\n\n\n Running \n\n\n"
  end

  # GET /rooms/1/edit
  def edit
    @categories=RoomCategory.all
  end

  # POST /rooms
  # POST /rooms.json
  def create
    rand_hex = SecureRandom.hex(10)
    pimage = params[:room][:room_pic]
    if(pimage==nil)
      flash[:notice]= "Please attach the room picture"
      redirect_to new_room_path
      return
    end
    puts pimage.original_filename
    @uploadedFile=pimage
    cl_response = Cloudinary::Uploader.upload(@uploadedFile.tempfile, :public_id => rand_hex)
    if(cl_response['secure_url']==nil)
      flash[:notice]= "There is a server side problem. Please try again later"
      redirect_to new_room_path
      return
    end
    params[:room][:room_pic_path]=cl_response['secure_url']
    params[:room][:isAvailable]=true
    params[:room][:rating]=0
    puts "\n\n\n"
    puts params.inspect
    @room = Room.new(room_params)
    cat = RoomCategory.find_by_id(room_params[:room_category_id])
    @room.user=current_user
    @room.room_category=cat
    puts "\n\n\nRoom Object\n"
    puts @room.inspect
    puts "\n\n\n-----------Room Object\n"
    puts "\n\n\n-----------Room Object\n"
    respond_to do |format|
      if @room.save
        puts "\n\n\n created \n\n\n"
        format.html { redirect_to adminpanel_path, notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      else
        @room = Room.new
        @categories = RoomCategory.all
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to adminpanel_path, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        @categories = RoomCategory.all
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def update_picture
    puts "\n\nUpdating picture"
    puts params.inspect
    puts "\n\n\n"
    if(current_user==nil || current_user.role.id!=0)
      flash[:notice]= "You must be an admin to change a room's picture"
      redirect_to edit_room_path(@room)
      return
    end
    rand_hex = SecureRandom.hex(10)
    pimage = params[:room_pic]
    if(pimage!=nil)
      puts pimage.original_filename
      @uploadedFile=pimage
      cl_response = Cloudinary::Uploader.upload(@uploadedFile.tempfile, :public_id => rand_hex)
      if(cl_response['secure_url']==nil)
        flash[:notice]= "There is a server side problem. Please try again later"
        redirect_to edit_room_path(@room)
        return
      end
      @room.update(room_pic_path: cl_response['secure_url'])
      redirect_to edit_room_path(@room)
    else
      redirect_to edit_room_path(@room)
    end
    return
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:number, :isAvailable, :description, :room_category_id, :price, :user_id, :room_pic_path, :rating)
    end
end
