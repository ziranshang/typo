Feature: Merge Articles
  As an author
  In order to keep the site organized
  I want to be able to merge articles on the same topic

Background: 
  Given the blog is set up

  Given the following articles exist:
    | title     | author  | body     | allow_comments | id | published_at        | user_id |
    | article 1 | author1 | article1 | 1              | 3  | 2013-10-29 10:00:00 | 3       |
    | article 2 | author2 | article2 | 1              | 4  | 2013-10-30 10:00:00 | 4       |

  Given the following comments exist:
    | author  | article_id | body     | id |
    | author3 | 3          | comment1 | 1  |
    | author4 | 4          | comment2 | 2  |

  Given the following users exist:
    | login   | password | profile_id | state  | name  | email |
    | user    | pass1    | 2          | active | user  | mail1 |
    | author1 | pass1    | 3          | active | auth1 | mail2 |
    | author2 | pass1    | 4          | active | auth2 | mail3 |

  Scenario: Non admin should not be able to merge
    Given the current user is "user" with password "pass1"
    When I am on the edit page for id "3"
    Then I should not see "Merge Articles"

  Scenario: Admin should be able to merge
    Given the current user is "admin" with password "aaaaaaaa"
    And I am on the edit page for id "3"
    When I fill in "merge_with" with "4"
    And I press "Merge"
    Then I should be on the edit page for id "3"
    And I should see "Successfully merged"
    And I should see "article1"
    And I should see "article2"

  Scenario: After merging, only article 1 remains
    Given the current user is "admin" with password "aaaaaaaa"
    And the articles with ids "3" and "4" are merged
    When I go to the content page
    Then I should see "auth1"
    And I should see "article 1"
    But I should not see "article 2"

  Scenario: After merging, author1 is only author
    Given the current user is "admin" with password "aaaaaaaa"
    And the articles with ids "3" and "4" are merged
    Then "author1" should be the author of 1 articles
    And "author2" should be the author of 0 articles

  Scenario: Comments should point to merged article
    Given the current user is "admin" with password "aaaaaaaa"
    And the articles with ids "3" and "4" are merged
    And I am on the content page
    When I go to the view page for id "3"
    Then I should see "comment1"
    And I should see "comment2"
