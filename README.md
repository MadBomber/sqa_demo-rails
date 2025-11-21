# My Rails App

## ⚠️ Experimental Testing Repository

This repository is for **experimental testing** of cutting-edge Ruby and Rails versions with PostgreSQL.

### Technology Stack

- **Rails**: 8.1.1 (Latest)
- **Ruby**: 4.0.0-preview2 (Experimental Preview Release)
- **Database**: PostgreSQL 17.7
- **Frontend**: Hotwire (Turbo + Stimulus) + Tailwind CSS
- **Infrastructure**: Solid Stack (Queue, Cache, Cable)

### Purpose

This project serves as a testing ground to:
- Validate compatibility of Rails 8.1.1 with Ruby 4.0.0-preview2
- Test the `pg` gem with the preview Ruby release
- Explore Rails 8.1 new features and improvements
- Experiment with the Solid Stack in a modern Rails environment

### Status

✅ **Rails 8.1.1** - Fully functional
✅ **Ruby 4.0.0-preview2** - Stable for testing
✅ **PostgreSQL Integration** - Working correctly
✅ **pg gem (1.6.2)** - Compatible with Ruby 4.0.0-preview2
✅ **Tailwind CSS** - Properly configured and compiled

## Architecture

Detailed architectural decisions are documented in the `.architecture/` directory:
- [ADR-001: Rails 8.1 Modern Stack Architecture](.architecture/decisions/adrs/ADR-001-rails-81-modern-stack-architecture.md)
- [ADR-002: Migrate to PostgreSQL Database](.architecture/decisions/adrs/ADR-002-migrate-to-postgresql-database.md)

## Setup

### Prerequisites

- Ruby 4.0.0-preview2
- PostgreSQL 17.7
- Node.js (for JavaScript dependencies)

### Installation

```bash
# Install dependencies
bundle install

# Create databases
rails db:create

# Run migrations (when available)
rails db:migrate

# Build Tailwind CSS
rails tailwindcss:build

# Start the server
rails server
# or use bin/dev for development with asset watching
```

### Database Configuration

The application uses a multi-database setup:
- **Development**: 4 separate PostgreSQL databases (primary, cache, queue, cable)
- **Test**: 4 separate PostgreSQL databases
- **Production**: Configured via environment variables

## Key Features

### Landing Page
A modern, responsive landing page showcasing MadBomber Software Solutions with:
- Dark gradient theme with orange/red accents
- Glassmorphism design elements
- Animated background effects
- Interactive project cards with hover effects
- Links to project documentation

### Solid Stack
- **Solid Queue**: Database-backed job processing
- **Solid Cache**: Database-backed caching layer
- **Solid Cable**: Database-backed WebSocket connections

### Modern Frontend
- **Hotwire**: SPA-like experience without heavy JavaScript
- **Tailwind CSS 4.1**: Utility-first CSS framework
- **Stimulus**: Modest JavaScript framework

## Development

```bash
# Run tests
rails test

# Run security scan
bin/brakeman

# Run linter
bin/rubocop

# Build Tailwind CSS
rails tailwindcss:build
```

## Deployment

Configured for Docker deployment using:
- **Kamal**: Zero-downtime container deployment
- **Thruster**: HTTP/2 proxy with asset caching

## Notes

### Ruby 4.0.0-preview2 Considerations

Ruby 4.0.0-preview2 is an **experimental release**:
- May have stability issues
- Native extensions (like `pg`) may have compatibility concerns
- Performance characteristics may differ from stable releases
- Breaking changes possible before 4.0.0 stable release

### PostgreSQL Benefits

- Better write concurrency than SQLite3
- Advanced features (JSON, full-text search, window functions)
- Production-ready for high-traffic applications
- Robust tooling and monitoring ecosystem

## Contributing

This is an experimental repository. Feel free to:
- Report compatibility issues with Ruby 4.0.0-preview2
- Test new Rails 8.1 features
- Suggest improvements to the architecture

## License

This project is open source and available under the MIT License.

## Links

- [MadBomber Software Solutions](https://madbomber.github.io)
- [Rails Guides](https://guides.rubyonrails.org/)
- [Ruby 4.0.0-preview2 Release Notes](https://www.ruby-lang.org/en/news/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/17/)
