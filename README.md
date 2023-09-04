# Requirement

- ruby 3.1.3
- bundler
- docker-compose(To run mysql container)

# Getting Started to Run in Local

## Switch to the desired branch

**We use main branch as demo.**

    $ git checkout main

## Install required softwares

### ruby 3.1.3

    $ sudo apt install rbenv(for ubuntu)
    $ brew install rbenv ruby-build(for MacOS)
    $ echo 'eval "$(rbenv init -)"' >> ~/.bashrc #depend on which sh you choose
    $ source ~/.bashrc
    $ rbenv install 3.1.3

### bundler

    $ RBENV_VERSION=3.1.3 gem install bundler

### docker-compose / mysql 5.6

**In this project we provide docker-compose.yml to install mysql.**

    $ sudo apt install docker-compose
    $ docker-compose up -d
    $ docker ps #to check if mysql is running successfully

### install gems

    $ bundle install

## env settings

**If docker-compose runs well, the database.yml settings fit mysql, no need to change.**

## create rails database

    $ bundle exec rake db:create
    $ bundle exec rake db:migrate

## run rails

    # You need to set binding if you connect from other machine
    $ bundle exec rails s

# RSpec

To run the RSpec locally, follow the steps below:

## create rails database for test env

    $ RAILS_ENV=test bundle exec rake db:create
    $ RAILS_ENV=test bundle exec rake db:migrate

## execute rspec

    $ bundle exec rspec

# API document

## Courses

### Get all courses with chapters and units

- URL: `{base_url}/courses`
- Method: `GET`
- Parameters: N/A
- Response:
  ```json
  [
    {
      "id": 1,
      "name": "Course Title",
      "lecturer": "lecturer name",
      "description": null,
      "available": true,
      "chapters": [
        {
          "id": 1,
          "course_id": 1,
          "name": "Chapter 1",
          "sequence": 0,
          "units": [
            {
              "id": 2,
              "chapter_id": 1,
              "name": "Unit 1.2",
              "description": null,
              "content": "Unit Content 1.2",
              "sequence": 0
            },
            {
              "id": 1,
              "chapter_id": 1,
              "name": "Unit 1.1",
              "description": null,
              "content": "Unit Content 1.1",
              "sequence": 0
            }
          ]
        }
      ]
    },
    {
      "id": 2,
      "name": "Course Title 2",
      "lecturer": "lecturer name 2",
      "description": null,
      "available": true,
      "chapters": [
        {
          "id": 3,
          "course_id": 2,
          "name": "Chapter 1",
          "sequence": 5,
          "units": [
            {
              "id": 6,
              "chapter_id": 3,
              "name": "Unit 1.1",
              "description": null,
              "content": "Unit Content 1.1",
              "sequence": 5
            },
            {
              "id": 7,
              "chapter_id": 3,
              "name": "Unit 1.2",
              "description": null,
              "content": "Unit Content 1.2",
              "sequence": 15
            }
          ]
        },
        {
          "id": 2,
          "course_id": 2,
          "name": "Chapter 2",
          "sequence": 10,
          "units": [
            {
              "id": 3,
              "chapter_id": 2,
              "name": "Unit 2.1",
              "description": null,
              "content": "Unit Content 2.1",
              "sequence": 5
            },
            {
              "id": 5,
              "chapter_id": 2,
              "name": "Unit 2.2",
              "description": null,
              "content": "Unit Content 2.2",
              "sequence": 10
            },
            {
              "id": 4,
              "chapter_id": 2,
              "name": "Unit 2.3",
              "description": null,
              "content": "Unit Content 2.3",
              "sequence": 15
            }
          ]
        }
      ]
    }
  ]
  ```
- Error: N/A

### Get specific course with chapters and units

- URL: `{base_url}/courses/:course_id`
- Method: `GET`
- Parameters: N/A
- Response:
  ```json
  {
    "id": 1,
    "name": "Course Title",
    "lecturer": "lecturer name",
    "description": null,
    "available": true,
    "chapters": [
      {
        "id": 1,
        "course_id": 1,
        "name": "Chapter 1",
        "sequence": 0,
        "units": [
          {
            "id": 2,
            "chapter_id": 1,
            "name": "Unit 1.2",
            "description": null,
            "content": "Unit Content 1.2",
            "sequence": 0
          },
          {
            "id": 1,
            "chapter_id": 1,
            "name": "Unit 1.1",
            "description": null,
            "content": "Unit Content 1.1",
            "sequence": 0
          }
        ]
      }
    ]
  }
  ```
- Error: N/A

### Create course

- URL: `{base_url}/courses/`
- Method: `POST`
- Body:

  - course:
    - `name`: Course name. (required)
    - `lecturer`: Course lecturer name. (required)
    - `description`
    - `available`
  - chapter:
    - `name`: Chapter name. (required)
    - `sequence`: Order of chapters.
  - unit:
    - `name`: Unit name. (required)
    - `description`
    - `content` (required)
    - `sequence`: Order of units.

  ```json
  {
    "course": {
      "name": "Course Title",
      "lecturer": "lecturer name",
      "chapters_attributes": [
        {
          "name": "Chapter 1",
          "units_attributes": [
            {
              "name": "Unit 1.1",
              "content": "Unit Content 1.1"
            },
            {
              "name": "Unit 1.2",
              "content": "Unit Content 1.2"
            }
          ]
        }
      ]
    }
  }
  ```

- Response:

  ```json
  {
    "id": 16,
    "name": "Course Title",
    "lecturer": "Lecturer name",
    "description": null,
    "available": true,
    "chapters": [
      {
        "id": 20,
        "course_id": 16,
        "name": "Chapter 1",
        "sequence": 0,
        "units": [
          {
            "id": 12,
            "chapter_id": 20,
            "name": "Unit 1.1",
            "description": null,
            "content": "Unit Content 1.1",
            "sequence": 0
          },
          {
            "id": 13,
            "chapter_id": 20,
            "name": "Updated Unit 1.2",
            "description": null,
            "content": "Unit Content 1.2",
            "sequence": 0
          }
        ]
      }
    ]
  }
  ```

- Error:

  ```json
  { "error_code": "PARAMETER_MISSING" }
  ```

  | http status |    error_code     |               description                |
  | :---------: | :---------------: | :--------------------------------------: |
  |     400     | PARAMETER_MISSING | The paramters is not fitting the format. |

### Update course

- URL: `{base_url}/courses/:course_id`
- Method: `PUT`
- Body:

  - course:
    - `name`: Course name. (required)
    - `lecturer`: Course lecturer name. (required)
    - `description`
    - `available`
  - chapter:
    - `id`: Id of the chapter to be modified. Create new chapter if no id parameter.
    - `name`: Chapter name. (required)
    - `sequence`: Order of chapters.
    - `_destroy`: Id of the chapter to be destroyed.
  - unit:
    - `id`: Id of the unit to be modified. Create new unit if no id parameter.
    - `name`: Unit name. (required)
    - `description`
    - `content` (required)
    - `sequence`: Order of units.
    - `_destroy`: Id of the unit to be destroyed.

  ```json
  {
    "course": {
      "name": "Updated Course Title",
      "chapters_attributes": [
        {
          "id": 1,
          "name": "Updated Chapter 1",
          "units_attributes": [
            {
              "id": 1,
              "name": "Updated Unit 1.1"
            },
            {
              "id": 2,
              "title": "Updated Unit 1.2"
            }
          ]
        },
        {
          "id": 2,
          "_destroy": true
        },
        {
          "name": "New Chapter",
          "units_attributes": [
            {
              "name": "New Unit 1",
              "content": "New Unit 1 content"
            },
            {
              "name": "New Unit 2",
              "content": "New Unit 2 content"
            }
          ]
        }
      ]
    }
  }
  ```

- Response:

  ```json
  {
    "id": 1,
    "name": "Updated Course Title",
    "lecturer": "Lecturer",
    "description": null,
    "available": true,
    "chapters": [
      {
        "id": 1,
        "course_id": 1,
        "name": "Updated Chapter 1",
        "sequence": 0,
        "units": [
          {
            "id": 1,
            "chapter_id": 1,
            "name": "Updated Unit 1.1",
            "description": null,
            "content": "Updated Content 1.1",
            "sequence": 0
          },
          {
            "id": 2,
            "chapter_id": 1,
            "name": "Updated Unit 1.2",
            "description": null,
            "content": "Updated Content 1.2",
            "sequence": 0
          }
        ]
      },
      {
        "id": 23,
        "course_id": 1,
        "name": "New Chapter",
        "sequence": 0,
        "units": [
          {
            "id": 14,
            "chapter_id": 23,
            "name": "New Unit 1",
            "description": null,
            "content": "New Unit 1 content",
            "sequence": 0
          },
          {
            "id": 15,
            "chapter_id": 23,
            "name": "New Unit 2",
            "description": null,
            "content": "New Unit 2 content",
            "sequence": 0
          }
        ]
      }
    ]
  }
  ```

- Error:

  ```json
  { "error_code": "PARAMETER_MISSING" }
  ```

  | http status |    error_code     |               description                |
  | :---------: | :---------------: | :--------------------------------------: |
  |     400     | PARAMETER_MISSING | The paramters is not fitting the format. |

### Delete specific course with chapters and units

- URL: `{base_url}/courses/:course_id`
- Method: `DELETE`
- Parameters: N/A
- Response:
  ```json
  {
    "success": true
  }
  ```
- Error: N/A
