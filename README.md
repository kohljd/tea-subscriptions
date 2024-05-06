# Tea Subscriptions

## Table of Contents

[Summary](#summary)<br>
[Setup Instructions](#setup-instructions)<br>
[Testing Instructions](#testing-instructions)<br>
[Endpoints](#endpoints)

## Summary
This project is a take-home prompt completed as part of Turing's Mod 3 $\rightarrow$ Mod 4 intermission work. The overall goal was to create a Rails API for a tea subscription service. Requirements included:
- An endpoint to subscribe a customer to a tea subscription
- An endpoint to cancel a customer’s tea subscription
- An endpoint to see all of a customer’s subsciptions (active and cancelled)

A full description with the entire prompt may be read [here](https://mod4.turing.edu/projects/take_home/take_home_be) on Turing's site.

## Setup Instructions

1. Fork and/or clone this repo from GitHub
2. In terminal, run `git clone <ssh or https path>`
3. Navigate into the cloned project by running `cd tea-subscriptions`
4. Run `bundle install` to install gems used for this project
5. Setup the database migration and seed file by running `rails db:{drop,create,migrate,seed}`

### Local Server
To start a local rails server run
```shell
rails server
```

Endpoints may then be utilized in a browser by navigating to
```http
http://localhost:3000/
```
And adding the desired api endpoint path to the end. A full list of options may be found in this README's [endpoints section](#endpoints).

<details>
<summary>Local Host Endpoint URL Example</summary>

```http
http://localhost:3000/api/v0/customers/1/subscriptions
```
</details><br>

To stop the local rails server use `Ctrl` + `C` in the open terminal.

>Note: If preferred, you can also use [Postman](https://www.postman.com/) rather than the browser's localhost, but you will still need to startup the local server using the `rails server` command.


## Testing Instructions

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
