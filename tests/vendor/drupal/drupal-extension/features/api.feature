@d7 @api
Feature: DrupalContext
  In order to prove the Drupal context is working properly
  As a developer
  I need to use the step definitions of this context

  # These scenarios assume a "standard" install of Drupal 7.

  @drushTest
  Scenario: Create and log in as a user
    Given I am logged in as a user with the "authenticated user" role
    When I click "My account"
    Then I should see the heading "History"

  @drushTest
  Scenario: Target links within table rows
    Given I am logged in as a user with the "administrator" role
    When I am at "admin/structure/types"
    And I click "manage fields" in the "Article" row
    Then I should be on "admin/structure/types/manage/article/fields"
    And I should see text matching "Add new field"

  @drushTest @d8
  Scenario: Find a heading in a region
    Given I am not logged in
    When I am on the homepage
    Then I should see the heading "User login" in the "left sidebar" region

  @drushTest @d8 @d8wip
  Scenario: Clear cache
    Given the cache has been cleared
    When I am on the homepage
    Then I should get a "200" HTTP response

  @d8
  Scenario: Create a node
    Given I am logged in as a user with the "administrator" role
    When I am viewing an "article" with the title "My article"
    Then I should see the heading "My article"

  @drushTest @d8
  Scenario: Run cron
    Given I am logged in as a user with the "administrator" role
    When I run cron
    And am on "admin/reports/dblog"
    Then I should see the link "Cron run completed"

  @d8
  Scenario: Create many nodes
    Given "page" content:
    | title    |
    | Page one |
    | Page two |
    And "article" content:
    | title          |
    | First article  |
    | Second article |
    And I am logged in as a user with the "administrator" role
    When I go to "admin/content"
    Then I should see "Page one"
    And I should see "Page two"
    And I should see "First article"
    And I should see "Second article"

  @d8
  Scenario: Create nodes with fields
    Given "article" content:
    | title                     | promote | body             |
    | First article with fields |       1 | PLACEHOLDER BODY |
    And I am logged in as a user with the "authenticated user" role
    When I am on the homepage
    And follow "First article with fields"
    Then I should see the text "PLACEHOLDER BODY"

  Scenario: Create and view a node with fields
    Given I am viewing an "Article":
    | title | My article with fields! |
    | body  | A placeholder           |
    Then I should see the heading "My article with fields!"
    And I should see the text "A placeholder"

  @d8
  Scenario: Create users
    Given users:
    | name     | mail            | status |
    | Joe User | joe@example.com | 1      |
    And I am logged in as a user with the "administrator" role
    When I visit "admin/people"
    Then I should see the link "Joe User"

  Scenario: Create users with roles
    Given users:
    | name     | mail            | roles         |
    | Joe User | joe@example.com | administrator |
    And I am logged in as a user with the "administrator" role
    When I visit "admin/people"
    Then I should see the text "administrator" in the "Joe User" row

  @d8
  Scenario: Login as a user created during this scenario
    Given users:
    | name      | status |
    | Test user |      1 |
    When I am logged in as "Test user"
    Then I should see the link "Log out"

  Scenario: Create a term
    Given I am logged in as a user with the "administrator" role
    When I am viewing a "tags" term with the name "My tag"
    Then I should see the heading "My tag"

  Scenario: Create many terms
    Given "tags" terms:
    | name    |
    | Tag one |
    | Tag two |
    And I am logged in as a user with the "administrator" role
    When I go to "admin/structure/taxonomy/tags"
    Then I should see "Tag one"
    And I should see "Tag two"

  Scenario: Create terms using vocabulary title rather than machine name.
    Given "Tags" terms:
    | name    |
    | Tag one |
    | Tag two |
    And I am logged in as a user with the "administrator" role
    When I go to "admin/structure/taxonomy/tags"
    Then I should see "Tag one"
    And I should see "Tag two"

  Scenario: Create nodes with specific authorship
    Given users:
    | name     | mail            | status |
    | Joe User | joe@example.com | 1      |
    And "article" content:
    | title          | author   | body             | promote |
    | Article by Joe | Joe User | PLACEHOLDER BODY | 1       |
    When I am logged in as a user with the "administrator" role
    And I am on the homepage
    And I follow "Article by Joe"
    Then I should see the link "Joe User"

  Scenario: Create an article with multiple term references
    Given "tags" terms:
    | name      |
    | Tag one   |
    | Tag two   |
    | Tag three |
    | Tag four  |
    And "article" content:
    | title           | body             | promote | field_tags                  |
    | Article by Joe  | PLACEHOLDER BODY |       1 | Tag one, Tag two, Tag three |
    | Article by Mike | PLACEHOLDER BODY |       1 | Tag four                    |
    When I am on the homepage
    Then I should see the link "Tag one"
    And I should see the link "Tag two"
    And I should see the link "Tag three"
    And I should see the link "Tag four"

  Scenario: Readable created dates
    Given "article" content:
    | title        | body             | created            | status | promote |
    | Test article | PLACEHOLDER BODY | 07/27/2014 12:03am |      1 |       1 |
    When I am on the homepage
    Then I should see the text "Sun, 07/27/2014 - 00:03"

  Scenario: Node hooks are functioning
    Given "article" content:
    | title        | body        | published on       | status | promote |
    | Test article | PLACEHOLDER | 04/27/2013 11:11am |      1 |       1 |
    When I am on the homepage
    Then I should see the text "Sat, 04/27/2013 - 11:11"

  Scenario: Node edit access by administrator
    Given I am logged in as a user with the "administrator" role
    Then I should be able to edit an "Article"

  Scenario: User hooks are functioning
    Given users:
    | First name | Last name | E-mail               |
    | Joe        | User      | joe.user@example.com |
    And I am logged in as a user with the "administrator" role
    When I visit "admin/people"
    Then I should see the link "Joe User"

  Scenario: Term hooks are functioning
    Given "tags" terms:
    | Label     |
    | Tag one   |
    | Tag two   |
    And I am logged in as a user with the "administrator" role
    When I go to "admin/structure/taxonomy/tags"
    Then I should see "Tag one"
    And I should see "Tag two"

  @d8
  Scenario: Log in as a user with specific permissions
    Given I am logged in as a user with the "Administer content types" permission
    When I go to "admin/structure/types"
    Then I should see the link "Add content type"
