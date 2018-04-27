require 'test_helper'

class RoomCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @room_category = room_categories(:one)
  end

  test "should get index" do
    get room_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_room_category_url
    assert_response :success
  end

  test "should create room_category" do
    assert_difference('RoomCategory.count') do
      post room_categories_url, params: { room_category: { category_pic_path: @room_category.category_pic_path, description: @room_category.description, name: @room_category.name, rate: @room_category.rate } }
    end

    assert_redirected_to room_category_url(RoomCategory.last)
  end

  test "should show room_category" do
    get room_category_url(@room_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_room_category_url(@room_category)
    assert_response :success
  end

  test "should update room_category" do
    patch room_category_url(@room_category), params: { room_category: { category_pic_path: @room_category.category_pic_path, description: @room_category.description, name: @room_category.name, rate: @room_category.rate } }
    assert_redirected_to room_category_url(@room_category)
  end

  test "should destroy room_category" do
    assert_difference('RoomCategory.count', -1) do
      delete room_category_url(@room_category)
    end

    assert_redirected_to room_categories_url
  end
end
