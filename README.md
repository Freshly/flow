# Flow

[![Gem Version](https://badge.fury.io/rb/flow.svg)](https://badge.fury.io/rb/flow)
[![Build Status](https://semaphoreci.com/api/v1/freshly/flow/branches/main/badge.svg)](https://semaphoreci.com/freshly/flow)
[![Maintainability](https://api.codeclimate.com/v1/badges/02131658005b10c289e0/maintainability)](https://codeclimate.com/github/Freshly/flow/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/02131658005b10c289e0/test_coverage)](https://codeclimate.com/github/Freshly/flow/test_coverage)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "flow"
```

Then, in your project directory:

```bash
$ bundle install
$ rails generate flow:install
```

## What is Flow?

Flow is a [SOLID](https://en.wikipedia.org/wiki/SOLID) implementation of the [Command Pattern](https://en.wikipedia.org/wiki/Command_pattern) for Ruby on Rails.

Flows allow you to encapsulate your application's [business logic](http://en.wikipedia.org/wiki/Business_logic) into a set of extensible and reusable objects.

## Quickstart Example

Install Flow to your Rails project:
```bash
$ rails generate flow:install
```

Then define `State`, `Operation`(s), and `Flow` objects.

### State

A `State` object defines data that is to be read or written in `Operation` objects throughout the `Flow`. There are several types of data that can be defined, such as `argument`, `option`, and `output`.

```bash
$ rails generate flow:state Charge
```

```ruby
# app/states/charge_state.rb

class ChargeState < ApplicationState
  # @!attribute [r]
  # Order hash, readonly, required
  argument :order
  # @!attribute [r]
  # User model instance readonly, required
  argument :user

  # @!attribute [r]
  # PaymentMethod model instance readonly, optional
  option :payment_method

  # @!attribute [rw]
  # Charge model instance readwrite, required
  output :charge
end
```

### Operations

`Operation` objects execute some procedure defined in a `#behavior` method and can read and write to `State` data via defined accessor methods.

```bash
$ rails generate flow:operation CreateCharge
```

```ruby
# app/operations/create_charge.rb

class CreateCharge < ApplicationOperation
  # @!attribute [r]
  # Order hash, readonly
  state_reader :order
  # @!attribute [r]
  # User model instance readonly
  state_reader :user
  # @!attribute [r]
  # PaymentMethod model instance readonly
  state_reader :payment_method

  # @!attribute [rw]
  # Charge model instance readwrite
  state_writer :charge

  def behavior
    state.charge = Charge.create(payment_method: payment_method, order: order, user: user)
  end

  private

  def payment_method
    payment_method.present? payment_method : user.default_payment_method
  end
end
```

Use failure methods when an `Operation` and `Flow` should fail and no longer run:

```bash
$ rails generate flow:operation SubmitCharge
```

```ruby
# app/operations/submit_charge.rb

class SubmitCharge < ApplicationOperation
  # @!method charge_unsuccessful_failure!(data = {})
  # Raises, stops the Operation and Flow, takes unstructured data hash
  failure :charge_unsuccessful

  # @!attribute [rw]
  # Charge model instance read only
  state_reader :charge

  def behavior
    charge_unsuccessful_failure!(response_body: response.body) unless success?

    charge.update(success: true)
  end

  private

  def success?
    response.body.success == "true"
  end

  def response
    PaymentProcessorClient.submit_charge(charge)
  end
  memoize :response
end
```

### Flow

A `Flow` object is composed of one or more ordered `Operation`s. Changes to the state will persist from one `Operation` to the next:

```bash
$ rails generate flow Charge
```

```ruby
# app/flow/charge_flow.rb

class ChargeFlow < ApplicationFlow
  operations CreateCharge,
             SubmitCharge
end
```

### Usage

Trigger the `Flow` in your code with `State` inputs:

```ruby
flow_input = {
  order: order,
  user: current_user,
  payment_method: visa_credit_card,
}

flow = ChargeFlow.trigger(flow_input)
```

Arguments defined on `State` are required when triggering a `Flow`, options are optional:

```
> ChargeFlow.trigger({})
ArgumentError: Missing arguments: order, user
```

State output can be accessed from the flow instance:

```
> flow = ChargeFlow.trigger(flow_input)

> flow.state.charge
=> #<Charge:0x00007fd5c5cda080 ... >
```

Success of the triggered `Flow` can be determined with these methods:

```
> flow.success?
=> true

> flow.failed?
=> false
```

If the `Flow` fails you can see the failures on the instance:

```
# some flow that results in a failure...
> flow = ChargeFlow.trigger(flow_input)

> flow.success?
=> false

# get the failure
> flow.operation_failure.problem
=> :charge_unsuccessful

# access unstructured hash passed into failure method
> flow.operation_failure.details.response_body
=> { some_response_body_here: ... }
```

## Wiki

Learn more with our wiki [Getting Started](https://github.com/Freshly/flow/wiki/Getting-Started#installation) page.

You also can download wiki to have offline access.
Just simply do:

`git clone git@github.com:Freshly/flow.wiki.git`


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
