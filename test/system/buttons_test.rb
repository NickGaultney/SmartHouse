require "application_system_test_case"

class ButtonsTest < ApplicationSystemTestCase
  setup do
    @button = buttons(:one)
  end

  test "visiting the index" do
    visit buttons_url
    assert_selector "h1", text: "Buttons"
  end

  test "creating a Button" do
    visit buttons_url
    click_on "New Button"

    fill_in "Coordinates", with: @button.coordinates
    fill_in "Device", with: @button.device
    fill_in "Name", with: @button.name
    click_on "Create Button"

    assert_text "Button was successfully created"
    click_on "Back"
  end

  test "updating a Button" do
    visit buttons_url
    click_on "Edit", match: :first

    fill_in "Coordinates", with: @button.coordinates
    fill_in "Device", with: @button.device
    fill_in "Name", with: @button.name
    click_on "Update Button"

    assert_text "Button was successfully updated"
    click_on "Back"
  end

  test "destroying a Button" do
    visit buttons_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Button was successfully destroyed"
  end
end
