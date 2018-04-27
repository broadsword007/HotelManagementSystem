class RoomCategoriesController < ApplicationController
  before_action :set_room_category, only: [:show, :edit, :update, :destroy, :update_picture]

  # GET /room_categories
  # GET /room_categories.json
  def index
    @room_categories = RoomCategory.all
  end

  # GET /room_categories/1
  # GET /room_categories/1.json
  def show
  end

  # GET /room_categories/new
  def new
    @room_category = RoomCategory.new
  end

  # GET /room_categories/1/edit
  def edit
  end

  # POST /room_categories
  # POST /room_categories.json
  def create
    rand_hex = SecureRandom.hex(10)
    pimage = params[:room_category][:category_pic]
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
    params[:room_category][:category_pic_path]=cl_response['secure_url']
    puts "\n\n\n"
    puts params.inspect
    @room_category = RoomCategory.new(room_category_params)

    respond_to do |format|
      if @room_category.save
        format.html { redirect_to adminpanel_path, notice: 'Room category was successfully created.' }
        format.json { render :show, status: :created, location: @room_category }
      else
        format.html { render :new }
        format.json { render json: @room_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /room_categories/1
  # PATCH/PUT /room_categories/1.json
  def update
    respond_to do |format|
      if @room_category.update(room_category_params)
        format.html { redirect_to adminpanel_path, notice: 'Room category was successfully updated.' }
        format.json { render :show, status: :ok, location: @room_category }
      else
        format.html { render :edit }
        format.json { render json: @room_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /room_categories/1
  # DELETE /room_categories/1.json
  def destroy
    @room_category.destroy
    respond_to do |format|
      format.html { redirect_to adminpanel_path, notice: 'Room category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def update_picture
    puts "\n\nUpdating picture"
    puts params.inspect
    puts "\n\n\n"
    if(current_user==nil || current_user.role.id!=0)
      flash[:notice]= "You must be an admin to change a room's picture"
      redirect_to edit_room_category_path(@room_category)
      return
    end
    rand_hex = SecureRandom.hex(10)
    pimage = params[:category_pic]
    if(pimage!=nil)
      puts pimage.original_filename
      @uploadedFile=pimage
      cl_response = Cloudinary::Uploader.upload(@uploadedFile.tempfile, :public_id => rand_hex)
      if(cl_response['secure_url']==nil)
        flash[:notice]= "There is a server side problem. Please try again later"
        redirect_to edit_room_category_path(@room_category)
        return
      end
      @room_category.update(category_pic_path: cl_response['secure_url'])
      redirect_to edit_room_category_path(@room_category)
    else
      redirect_to edit_room_category_path(@room_category)
    end
    return
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room_category
      @room_category = RoomCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_category_params
      params.require(:room_category).permit(:name, :description, :rate, :category_pic_path, :category_pic)
    end
end
