# Requirement

- ruby 3.1.3
- bundler
- docker-compose(To run mysql container)

# API server info(Heroku)
- BASE_URL: https://matt-homework-d8aad95e11be.herokuapp.com/
- ex: https://matt-homework-d8aad95e11be.herokuapp.com/courses/1

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

# API server architecture
## Models
1. Course
  - string:name
  - string:lecturer
  - text:description
  - boolean:available
  - datetime:created_at
  - datetime:updated_at
2. Chapter
  - bigint:course_id
  - string:name
  - integer:sequence
  - datetime:created_at
  - datetime:updated_at
3. Unit
  - bigint:chapter_id
  - string:name
  - text:description
  - text:content
  - integer:sequence
  - datetime:created_at
  - datetime:updated_at

## Controllers
1. Courses Controller
  - #index
  - #show
  - #create
  - #update
  - #destroy

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

# GEM list

## awesome_print

- https://github.com/awesome-print/awesome_print
- awesome_print是一款方便開發美化的工具，可以在使用irb或是rails console時，將顯示畫面優話，因此在console測試或透過ActiveRecord檢查資料時可有更佳的閱讀性。

## pry-rails

- https://github.com/pry/pry-rails
- 常用rails debug工具，和pry gem功能類似，需要在程式碼debug時，在中間加入binding.pry即可當作中斷點，另外比較特別的一點是，使用pry-rails+awesome_print，以及再設定.pryrc後，即可在rails console中很方便的閱讀ActiveRecord資料。

## factory_bot_rails
- https://github.com/thoughtbot/factory_bot_rails
- factory_bot_rails是一款由factory_girl衍生過來，方便快速產生假資料的gem，並可以透過trail和association去設定多種模組及重複使用其他的factories。

## faker
- https://github.com/faker-ruby/faker
- ~~LOL界的GOAT~~
- faker也是一款相當方便於產生假資料的gem，但不同於factory_bot為設定model中資料，faker則是提供多元類型資料，如國家、地址、語言、姓名、email、字串，或甚至電影名稱、書名等等，可透過這個gem省下大量產生資料時間。

## rubocop, rubocop-rspec
- https://github.com/rubocop/rubocop
- https://github.com/rubocop/rubocop-rspec
- rubocop, rubocop-rspec為程式碼的風格統一的套件工具，並可配合.rubocop.yml設定檔，去微調設定不同開發團隊的一些慣例，如常見的單雙引號、長度行數限制等等，另外VS code這個IDE也有針對rubocop去開發plugin，在視覺上更容易看出coding style問題，或是可透過快捷建快速調整需修改的coding style。

## oj
- https://github.com/ohler55/oj
- oj為一套可快速處理JSON格式的套件，簡單方便好操作。

## blueprinter
- https://github.com/procore-oss/blueprinter
- Blueprinter是一個用於JSON object呈現的套件，主要功能用於response格式回傳的制定，類似其他Serializer套件(ex: jbuilder, ActiveModelSerializers)，其一大優點為可客製成多種格式，如Hash包裝方法、一個printer可設定多種view使用、重複使用其他printer，或是在printer中做排序。

# 程式碼註解原則
- 雖然註解於程式碼中算是隨處可見，有時候註解也是必要的，但印象clean code作者有提到盡量少用到註解，而是增進程式碼本身可閱讀性，個人也同意此觀點，但仍可能用到註解的情況我認為如下：1. 程式碼、商業邏輯整理，提供後人快速trace 2. 歷史因素或設計原因，了解當初緣由 3. TODO，寫程式難免在trade off中留下技術債，或在快速驗證時做架構雛型，此時留下一些尚未優化或是潛在危險，讓未來假如真的遇到狀況時方便解決問題。

# 考量
## 是否要使用mongo db，或使用rdbms?
> 雖然都存在同個collection裡很方便，也可把章節單元都存成json放在一個document中，但不確定章節、單元量級因此沒使用。

## Course, Chapter, Unit的primary key的選擇？
> 因為課程、章節、單元名稱重複雖然不常見，但比較偏向課程設定者的自由，因此不會特別針對name做uniq。

## 如果在建立、編輯課程時，沒有對應的章節及單元的話，算錯誤嗎？
> 考量過後可能會有編輯中或準備中的課程，因此設計成允許只有課程但沒有章節單元，並讓使用者可自行將課程上下架(available)，如果要再設計更符合情境詳細點，應該可將上下架改成課程狀態(status)，並有上架申請中、上架、下架。

## 是否將chapters, units做排序後response？
> 一開始並沒有考慮做排序原因，為考量Query後於Printer排序，會造成n+1 Query問題，且client端應該可處理，但後續測試後決定在用同個Query在includes時，同時將chapters、units一起排序完成，節省client要再處理資料時間。

# 遇到的問題
## New rails project with rails 7.0.6 / ruby 3.1.3，initailize bundle install遇到psych error
```
An error occurred while installing psych (5.1.0), and Bundler cannot continue.

In Gemfile:
  debug was resolved to 1.8.0, which depends on
    irb was resolved to 1.8.0, which depends on
      rdoc was resolved to 6.5.0, which depends on
        psych
```
- 發現是 libyaml 套件問題，用sudo apt-get install libyaml-dev安裝後重新bundle install完成
- https://community.openproject.org/projects/openproject/work_packages/45489/activity

## 三階層的printer問題
1. 一開始無法recursive呼叫UnitPrinter，因此CoursePrinter無法用view選擇是否印出Unit

- https://github.com/procore-oss/blueprinter#usage
- https://github.com/procore-oss/blueprinter/issues/262
> 查完blueprinter gem文件和issues後有找到解
```
association :chapters, blueprint: ChapterPrinter, view: :with_units
```

2. 如果想要printer將順序印出來，發現會造成n+1 query
- https://github.com/procore-oss/blueprinter/issues/262
> 參考stackoverflow和chatGPT後，找到可以先includes且order children方法，改成在controller先query好再放進printer中
```
@course = Course.includes(chapters: :units).order('chapters.sequence, units.sequence').find(params[:id])
```

## Heroku部屬
1. 轉換成pg，因此要在production gem加裝一個 gem 'pg'，安裝pg gem遇到問題：
> 和psych一樣是套件問題
https://stackoverflow.com/questions/52339221/rails-gem-error-while-installing-pg-1-1-3-and-bundler-cannot-continue

2. Database連線問題，一直找不到指定url
> 檢查config_vars發現沒有database_url環境變數，發現沒有去Heroku設定開啟postgres服務，設定完連上app後就可以看到有DB設定了，之後再重新跑一次heroku run rails db:migrate就成功了，BASE_URL設定也有自動加入config_vars
