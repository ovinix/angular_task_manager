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
      assert page.assert_selector("#list-#{list.id}-todos")
    end
    assert page.has_button?("Add Task", count: @user.lists.count)
    @user.tasks.each do |task|
      if task.completed?
        assert find("#task-#{task.id} input[type=checkbox]").checked?
      else
        assert_not find("#task-#{task.id} input[type=checkbox]").checked?
      end

      if task.important?
        assert page.assert_selector("#task-#{task.id} span.glyphicon-star")
      end

      assert page.has_content?(task.content)

      if task.has_deadline?
        task_selector = find("#task-#{task.id}")
        assert task_selector.has_content?(task.deadline_at.year)
        assert task_selector.has_content?(task.deadline_at.month)
        assert task_selector.has_content?(task.deadline_at.day)
      end 

      assert page.assert_selector("#task-#{task.id} span[title='Prioritize']", visible: false)
      assert page.assert_selector("#task-#{task.id} span[title='Edit']", visible: false)
      assert page.assert_selector("#task-#{task.id} span[title='Delete']", visible: false)
      assert page.assert_selector('a', "#/list/#{task.list_id}/task/#{task.id}")

      page.execute_script("$('.hoverable').show();") # Selenium couldn't interacte with invisible elements
      find("a[href='#/list/#{task.list_id}/task/#{task.id}']").click

      assert page.has_content?(task.content)

      if task.completed?
        assert find("input[type=checkbox]").checked?
      else
        assert_not find("input[type=checkbox]").checked?
      end

      page.execute_script("$('input[type=radio]').show();") # Selenium couldn't interacte with invisible elements
      if task.important?
        assert page.has_checked_field?("Important")
      else
        assert page.has_checked_field?("Normal")
      end
      page.execute_script("$('input[type=radio]').hide();")

      if task.has_deadline?
        assert page.has_content?(task.deadline_at.year)
        assert page.has_content?(task.deadline_at.month)
        assert page.has_content?(task.deadline_at.day)
      end   

      first("a[href='#/']").click
    end   
  end

  test "should delete a task" do
    assert_difference "@user.tasks.count", -1 do
      page.execute_script("$('.hoverable').show();") # Selenium couldn't interacte with invisible elements
      find("#task-#{@task.id} span[title='Delete']").click
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
    find("#task-#{@task.id} input[type=checkbox]").click
    task = find("#task-#{@task.id}")
    assert task.has_css?("td.task-true")
  end

  test "should uncomplete a task" do
    @task = tasks(:completed)
    find("#task-#{@task.id} input[type=checkbox]").click
    task = find("#task-#{@task.id}")
    assert_not task.has_css?("td.task-true")
  end

  test "should set/unset task priority" do
    page.execute_script("$('.hoverable').show();") # Selenium couldn't interacte with invisible elements
    find("#task-#{@task.id} span[title='Prioritize']").click
    task = find("#task-#{@task.id}")
    assert task.assert_selector("span.star")
    page.execute_script("$('.hoverable').show();") # Selenium couldn't interacte with invisible elements
    find("#task-#{@task.id} span[title='Prioritize']").click
    assert task.assert_no_selector("span.star")
  end

  test "should update a task content" do
    page.execute_script("$('.hoverable').show();") # Selenium couldn't interacte with invisible elements
    find("a[href='#/list/#{@task.list_id}/task/#{@task.id}']").click
    assert page.has_content?(@task.content)
    fill_in "task_content", with: "New content"
    click_button("Save")
    assert page.has_content?("New content")
  end

  test "shouldn't update a task content" do
    page.execute_script("$('.hoverable').show();") # Selenium couldn't interacte with invisible elements
    find("a[href='#/list/#{@task.list_id}/task/#{@task.id}']").click
    assert page.has_content?(@task.content)
    fill_in "task_content", with: "New content"
    first("a[href='#/']").click
    assert_not page.has_content?("New content")
  end

  test "shouldn't update a task with blank content" do
    page.execute_script("$('.hoverable').show();") # Selenium couldn't interacte with invisible elements
    find("a[href='#/list/#{@task.list_id}/task/#{@task.id}']").click
    assert page.has_content?(@task.content)
    fill_in "task_content", with: "   "
    click_button("Save")
    assert page.has_content?(@task.content)
  end

  test "should update a task deadline" do
    page.execute_script("$('.hoverable').show();") # Selenium couldn't interacte with invisible elements
    find("a[href='#/list/#{@task.list_id}/task/#{@task.id}']").click
    fill_in "deadline_at", with: "2016-05-07 12:00 AM"
    click_button("Save")
    assert page.has_content?("2016-05-07")
  end

  test "should update a task priority" do
    page.execute_script("$('.hoverable').show();") # Selenium couldn't interacte with invisible elements
    find("a[href='#/list/#{@task.list_id}/task/#{@task.id}']").click
    find('label', text: 'Important').click
    click_button("Save")
    assert page.assert_selector("#task-#{@task.id} span.glyphicon-star")
  end
end
