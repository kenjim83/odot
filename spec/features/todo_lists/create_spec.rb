require 'spec_helper'


describe "Creating todo lists" do

  def create_todo_list(options={})
    options[:title] ||= "My todo list"
    options[:description] ||= "This is my description."
    visit "/todo_lists"
    click_link "New Todo list"
    expect(page).to have_content "Todo List"
    fill_in "Title", with: options[:title]
    fill_in "Description", with: options[:description]
    click_button "Create Todo list"
  end


  it "redirects to the todo list index page on success" do
    visit "/todo_lists"
    click_link "New Todo list"
    expect(page).to have_content "Todo List"
    create_todo_list title: "My todo list", description: "This is what I'm doing today."
    expect(page).to have_content "My todo list"
  end

  it "displays an error when the list has no title" do
    expect(TodoList.count).to eq(0)
    create_todo_list title: "", description: "This is what I'm doing today."
    expect(page).to have_content "error"
    expect(TodoList.count).to eq(0)
    visit "/todo_lists"
    expect(page).to_not have_content("This is what I'm doing today.")
  end

  it "displays an error when the title is less than 3 characters." do
    expect(TodoList.count).to eq(0)
    create_todo_list title: "Yo", description: "This is what I'm doing today."
    expect(page).to have_content "error"
    expect(TodoList.count).to eq(0)
    visit "/todo_lists"
    expect(page).to_not have_content("This is what I'm doing today.")
  end

 it "displays an error when the description is blank" do
    expect(TodoList.count).to eq(0)
    create_todo_list title: "Valid title", description: ""
    expect(TodoList.count).to eq(0)
    visit "/todo_lists"
    expect(page).to_not have_content("No description")
  end

  it "displays an error when the description is less than 5 characters." do
    expect(TodoList.count).to eq(0)
    create_todo_list title: "Valid title", description: "1233"
    expect(page).to have_content "Description is too short"
    expect(TodoList.count).to eq(0)
    visit "/todo_lists"
    expect(page).to_not have_content("This is what I'm doing today.")
  end


end