require 'test_helper'

class UserTasksTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:first)
    @list = lists(:one)
    @task = tasks(:one)
    Capybara.current_driver = Capybara.javascript_driver
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start 
    log_in_as @user
    visit root_path
  end

  def teardown
    click_link("Sign out", href: destroy_user_session_path)
    DatabaseCleaner.clean
    Capybara.use_default_driver
  end

  test "tasks layout" do
    @user.lists.each do |list|
      assert page.assert_selector("form[action='#{list_tasks_path(list)}']")
    end
    assert page.has_button?("Add Task", count: @user.lists.count) 
    @user.tasks.each do |task|
      assert page.assert_selector('a', complete_list_task_path(task.list, task))
      assert page.assert_selector('a', prioritize_list_task_path(task.list, task))
      assert page.assert_selector('a', list_task_path(task.list, task))
      assert page.assert_selector("a[data-method='delete']", list_task_path(task.list, task))
    end   
  end

  test "should delete a task" do
    assert_difference "@user.tasks.count", -1 do
      page.execute_script("$('.hoverable').show();") # Selenium couldn't interacte with invisible elements
      find("a[href='#{list_task_path(@list, @task)}'][data-method='delete']").click
      sleep 0.1 # need to wait for Ajax
    end
    assert_not page.has_content?(@task.content.to_s)
  end

  test "should create a task" do
    assert_difference "@user.tasks.count", 1 do
      form = find("#list-#{@list.id}-todos form")
      form.fill_in "task_content", with: "New task"
      form.click_button("Add Task")
      sleep 0.1 # need to wait for Ajax
    end
    assert page.has_content?("New task")
  end

  test "shouldn't create a task" do
    assert_no_difference "@user.tasks.count" do
      form = find("#list-#{@list.id}-todos form")
      form.fill_in "task_content", with: "    "
      form.click_button("Add Task")
    end
  end

  test "should complete a task" do
    find("a[href='#{complete_list_task_path(@list, @task)}']").click
    task = find("#list-#{@list.id}-todos #todo-item-#{@task.id}")
    assert task.find("s").has_content?(@task.content.to_s)
  end

  test "should uncomplete a task" do
    @task = tasks(:completed)
    find("a[href='#{complete_list_task_path(@list, @task)}']").click
    task = find("#list-#{@list.id}-todos #todo-item-#{@task.id}")
    assert task.assert_no_selector("s", @task.content.to_s)
  end

  test "should set/unset task priority" do
    page.execute_script("$('.hoverable').show();") # Selenium couldn't interacte with invisible elements
    find("a[href='#{prioritize_list_task_path(@list, @task)}']").click
    task = find("#list-#{@list.id}-todos #todo-item-#{@task.id}")
    assert task.assert_selector("span.star")
    page.execute_script("$('.hoverable').show();") # Selenium couldn't interacte with invisible elements
    find("a[href='#{prioritize_list_task_path(@list, @task)}']").click
    assert task.assert_no_selector("span.star")
  end

  test "should update a task content" do
    page.execute_script("$('.hoverable').show();") # Selenium couldn't interacte with invisible elements
    find("a[href='#{list_task_path(@list, @task)}'][data-toggle='modal']").click
    modal = find("#modal-window")
    modal.fill_in "task_content", with: "New content"
    modal.click_button("Update")
    assert page.has_content?("New content")
  end

  test "shouldn't update a task content" do
    page.execute_script("$('.hoverable').show();") # Selenium couldn't interacte with invisible elements
    find("a[href='#{list_task_path(@list, @task)}'][data-toggle='modal']").click
    modal = find("#modal-window")
    modal.fill_in "task_content", with: "New content"
    modal.click_button("Close", match: :first)
    assert_not page.has_content?("New content")
  end

  test "shouldn't update a task with blank content" do
    page.execute_script("$('.hoverable').show();") # Selenium couldn't interacte with invisible elements
    find("a[href='#{list_task_path(@list, @task)}'][data-toggle='modal']").click
    modal = find("#modal-window")
    modal.fill_in "task_content", with: "    "
    modal.click_button("Update")
    assert modal.has_css?('.field_with_errors #task_content')
    modal.click_button("Close", match: :first)
  end

  test "should update a task deadline" do
    page.execute_script("$('.hoverable').show();") # Selenium couldn't interacte with invisible elements
    find("a[href='#{list_task_path(@list, @task)}'][data-toggle='modal']").click
    modal = find("#modal-window")
    modal.fill_in "task_deadline_at", with: "2016-05-07 12:00 AM"
    modal.click_button("Update")
    assert page.has_content?("2016-05-07")
  end

  test "should update a task priority" do
    page.execute_script("$('.hoverable').show();") # Selenium couldn't interacte with invisible elements
    find("a[href='#{list_task_path(@list, @task)}'][data-toggle='modal']").click
    modal = find("#modal-window")
    modal.find('label', text: 'Important').click
    modal.click_button("Update")
    task = find("#list-#{@list.id}-todos #todo-item-#{@task.id}")
    assert task.assert_selector("span.star")
  end
end
