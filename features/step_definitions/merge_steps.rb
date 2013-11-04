Given /the following articles exist/ do |articles_table|
  articles_table.hashes.each do |article|
    Article.create!(article)
  end
end

Given /the following comments exist/ do |comments_table|
  comments_table.hashes.each do |comment|
    Comment.create!(comment)
  end
end

Given /the following users exist/ do |users_table|
  users_table.hashes.each do |user|
    User.create!(user)
  end
end

Given /the current user is "(.*?)" with password "(.*?)"/ do |user, password|
  visit '/accounts/login'
  fill_in 'user_login', :with => user
  fill_in 'user_password', :with => password
  click_button 'Login'
  if page.respond_to? :should
    page.should have_content('Login successful')
  else
    assert page.has_content?('Login successful')
  end
end

Given /the articles with ids "(\d+)" and "(\d+)" are merged/ do |id1, id2|
  article = Article.find_by_id(id1)
  article.merge_with(id2)
end

Then /I should see the body of "(.*?)"/ do |article|
  if page.respond_to? :should
    page.should have_content(article.body)
  else
    assert page.has_content?(article.body)
  end
end

Then /"(.*?)" should be the author of (\d+) articles/ do |author, num|
  assert Article.find_all_by_author(author).size == Integer(num)
end
