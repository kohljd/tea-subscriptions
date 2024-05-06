# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions


## Setup Instructions

1. Fork and/or clone this repo from GitHub
2. In terminal, run `git clone <ssh or https path>`
3. Navigate into the cloned project by running `cd tea-subscriptions`
4. Run `bundle install` to install gems used for this project
5. Setup the database migration and seed file by running `rails db:{drop,create,migrate,seed}`

## Testing

Rspec was used for testing. Official documentation [here](https://rspec.info/documentation/). This project ccurrently uses rspec-rails v6.1 for and rspec-core v3.13.

**Terminal commands**<br>
To run the entire test suite:
```shell
bundle exec rspec spec
```

To run just one file:
```shell
bundle exec rspec <path/to/test/file>
# ex: bundle exec rspec spec/requests/api/v0/customer_adds_subscription_spec.rb
```

To run just one test:
```shell
bundle exec rspec <path/to/test/file>:test_line
# ex: bundle exec rspec spec/requests/api/v0/customer_adds_subscription_spec.rb:8
```


## Endpoints
<details>
<summary>Add Customer Tea Subscription</summary>

Request
```http
POST /api/v0/customers/1/subscriptions
```

Body
```JSON
{
  "teas": [1, 2],
  "title": "Tea for Two",
  "price": 15,
  "frequency": "weekly",
  "status": "active"
}
```

Response
```JSON
{
  "data": {
    "id": "1",
    "type": "subscription",
    "attributes": {
      "title": "Tea for Two",
      "price": 15.0,
      "status": "active",
      "frequency": "weekly"
    },
    "relationships": {
      "teas": {
        "data": [
          {
            "id": "1",
            "type": "tea"
          },
          {
            "id": "2",
            "type": "tea"
          }
        ]
      }
    }
  }
}
```

</details>

<details>
<summary>Cancel Customer Tea Subscription</summary>

Request
```http
PATCH /api/v0/customers/1/subscriptions/2
```

Body
```JSON
{
  "status": "cancelled"
}
```

Response
```JSON
{
  "data": {
    "id": "2",
    "type": "subscription",
    "attributes": {
      "title": "Tea for Two",
      "price": 15.0,
      "status": "cancelled",
      "frequency": "weekly"
    },
    "relationships": {
      "teas": {
        "data": [
          {
            "id": "1",
            "type": "tea"
          },
          {
            "id": "2",
            "type": "tea"
          }
        ]
      }
    }
  }
}
```
</details>

<details>
<summary>List Customer's Tea Subscriptions</summary>

Request
```http
GET /api/v0/customers/1/subscriptions
```

Response
```JSON
{
  "data": [
    {
      "id": "1",
      "type": "subscription",
      "attributes": {
        "title": "Tea for Two",
        "price": 15.0,
        "status": "active",
        "frequency": "weekly"
      },
      "relationships": {
        "teas": {
          "data": [
            {
              "id": "1",
              "type": "tea"
            },
            {
              "id": "2",
              "type": "tea"
            }
          ]
        }
      }
    },
    {
      "id": "2",
      "type": "subscription",
      "attributes": {
        "title": "Par-tea!",
        "price": 10.0,
        "status": "cancelled",
        "frequency": "monthly"
      },
      "relationships": {
        "teas": {
          "data": [
            {
              "id": "3",
              "type": "tea"
            }
          ]
        }
      }
    }
  ]
}
```
</details>
