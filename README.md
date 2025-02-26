# 📘 Case Study: Todo App 

## 📝 Project Description

This case study involves the development of a Todo App with the following core components:

- **Local and Remote Storage**: Using Core Data with CloudKit.
- **Abstraction & Architecture**: Separation of business logic, API, and database layers.
- **Test-Driven Development (TDD)**: Development based on acceptance and unit tests.

## 🧑‍💻 User Story (create todo)

```gherkin
Feature: Create To-Do
  As a user
  I want to create, save, and view to-dos
  So that I can manage my tasks efficiently.

  Scenario: Successfully create a to-do ✅
    Given I am on the "Create Todo" tab
    When I enter a new to-do with the title "Buy milk"
    And select a due date of "15.03.2025"
    And select priority "medium"
    And tap "Save"
    Then I am automatically navigated to the "Todos" tab
    And I see the to-do "Buy milk - Due: 15.03.2025" in the list

  Scenario: Title contains only whitespace ✅
    When the user clicks on "New To-Do"
    And the user enters the title "   "
    And the user clicks on "Save"
    Then the system validates the inputs:
      | Field | Validation                        |
      | Title | Contains only whitespace, invalid |
    And the system displays the error message "Title cannot be empty"
    And the to-do is not saved.

  Scenario: Invalid due date (Sad Path) ✅
    When the user clicks on "New To-Do"
    And the user sets a due date in the past
    And the user clicks on "Save"
    Then the system validates the inputs:
      | Field        | Validation                           |
      | Due Date     | Invalid, date is in the past         |
    And the system displays the error message "Invalid due date"
    And the to-do is not saved.
```
Steps:
- The user creates a to-do with the **required data**
- The system validates the to-do data
- The system **saves** the to-do
- And the to-do is **added to the list**

## Data
### 📝 TODO-ITEM Model

| **Field**       | **Type** | **Description**                             | **Optional** |
|-----------------|----------|---------------------------------------------|--------------|
| `id`            | `UUID`   | Unique identifier for the to-do item        | No           |
| `title`         | `String` | Title of the to-do item                     | No           |
| `note`          | `String` | Additional notes or description             | Yes          |
| `priority`      | `String` | Priority level (e.g., low, medium, high)    | No           |
| `dueDate`       | `Date`   | Due date for the to-do item                 | No           |
| `createdAt`     | `Date`   | Timestamp when the to-do item was created   | No           |
| `isComplete`    | `Bool`   | Indicates if the to-do item is completed    | No           |
| `assignedUsers` | `[UUID]` | List of users assigned to the to-do item    | Yes          |

## Architecture
Based on the described steps and requirements, I was able to create an architecture diagram that illustrates the interaction between different components of the application.
![Architecture Diagram](architecture.svg)
 

