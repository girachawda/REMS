# REMS - Real Estate Management System

A web-based property management platform for commercial real estate, enabling tenants to search for spaces and schedule viewings while leasing agents manage property portfolios and availability.

## Overview

REMS streamlines the commercial real estate leasing process by connecting tenants with available properties and facilitating appointment scheduling with leasing agents.

### Key Features

- **Property Search & Filtering** - Browse available commercial spaces with advanced filters (location, size, rate, classification tier)
- **User Authentication** - Role-based access for Tenants, Leasing Agents, and Administrative Staff
- **Unit Management** - Track individual units within properties with detailed specifications and 4-tier classification system
- **Appointment Scheduling** - Book property viewings based on agent availability with double-booking prevention
- **Agent Availability** - Leasing agents set their showing schedules for specific properties

## Tech Stack

- **Ruby** 3.3.0
- **Rails** 7.2.3
- **Database** SQLite3
- **Authentication** bcrypt with has_secure_password
- **Testing** Minitest 5.x

## Quick Start

### Prerequisites

- Ruby 3.3.0 (managed via rbenv)
- Rails 7.2+
- SQLite3

### Installation

```bash
# Install dependencies
bundle install

# Setup database
rails db:create db:migrate db:seed

# Start the server
rails server
```

Visit `http://localhost:3000` to access the application.

### Test Accounts

The seed data includes test users with password `password`:

| Role | Email | Use Case |
|------|-------|----------|
| Tenant | tenant1@example.com | Browse properties, schedule appointments |
| Leasing Agent | agent1@example.com | Manage availability, view appointments |
| Admin Staff | staff@example.com | Full system access |

## Core Functionality

### For Tenants
1. **Search Properties** - Filter by location, size, rental rate, and classification tier
2. **View Details** - See property and unit information with availability
3. **Book Appointments** - Schedule viewings when agents are available

### For Leasing Agents
1. **Set Availability** - Input showing schedules for specific properties
2. **View Appointments** - Track scheduled tenant viewings
3. **Manage Portfolio** - Access all property and unit information

## Database Schema

### Models & Relationships

```
User (tenant/agent/staff)
  ├── has_many :appointments
  └── has_many :availabilities

Property
  ├── has_many :units
  └── has_many :availabilities

Unit
  ├── belongs_to :property
  └── has_many :appointments

Availability (agent's showing schedule)
  ├── belongs_to :user
  ├── belongs_to :property
  └── has_many :appointments

Appointment
  ├── belongs_to :user (tenant)
  ├── belongs_to :unit
  └── belongs_to :availability
```

### Unit Classification Tiers

- **Tier 1** - Premium spaces
- **Tier 2** - Standard commercial
- **Tier 3** - Budget-friendly
- **Tier 4** - Economy options

## Testing

```bash
# Run all tests
rails test

# Run specific test file
rails test test/controllers/properties_controller_test.rb

# Run with verbose output
rails test --verbose
```

Current test coverage: **12 tests, 20 assertions, 0 failures**

## Project Structure

```
app/
├── controllers/     # Request handling & business logic
├── models/         # Data models with validations
└── views/          # HTML templates with embedded Ruby

config/
├── routes.rb       # URL routing configuration
└── database.yml    # Database configuration

db/
├── migrate/        # Database migrations
└── seeds.rb        # Sample data for development

test/
├── controllers/    # Controller integration tests
├── models/         # Model unit tests
└── fixtures/       # Test data
```

## API Routes

### Authentication
- `GET /login` - Login page
- `POST /login` - Authenticate user
- `DELETE /logout` - End session

### Properties & Units
- `GET /properties` - List all properties with search/filters
- `GET /properties/:id` - Property details
- `GET /properties/:id/units/:id` - Unit details

### Appointments
- `GET /appointments` - User's appointments
- `GET /appointments/new` - Schedule new appointment
- `POST /appointments` - Create appointment

### Availability (Agents only)
- `GET /availabilities` - Agent's availability schedule
- `GET /availabilities/new` - Add availability
- `POST /availabilities` - Create availability

## Configuration

### Environment Setup

The application uses rbenv for Ruby version management. Ensure your shell is configured:

```bash
eval "$(rbenv init - bash)"
```

### Linting

RuboCop is configured for code style enforcement:

```bash
# Check for violations
bundle exec rubocop

# Auto-fix violations
bundle exec rubocop -A
```

VS Code users: The project includes settings for automatic formatting with RuboCop.

## Development Notes

- Authentication is session-based (no JWT/tokens)
- Double-booking prevention is enforced at the model level
- All times are stored in UTC
- Fixtures use dynamic dates for testing
- Enum values use Rails 8 positional argument syntax

## Contributing

This is an academic project for learning Rails MVC architecture and real estate management workflows.

## License

Educational use only.
