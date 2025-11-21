# ADR-001: Rails 8.1 Modern Stack Architecture

**Date**: 2025-11-21
**Status**: Accepted
**Decision Makers**: Development Team
**Tags**: rails, architecture, framework, frontend, database, deployment

## Context

We are establishing the foundational architecture for MyRailsApp, a new Ruby on Rails application. The application needs a modern, production-ready stack that supports rapid development, easy deployment, and can scale as the product grows. We need to make decisions about the web framework version, frontend approach, database, caching, job processing, and deployment strategy.

## Decision Drivers

- **Modern Rails Features**: Want to leverage the latest Rails 8.1 capabilities and conventions
- **Developer Productivity**: Need fast development cycles with hot reload and minimal configuration
- **Production Readiness**: Must have built-in solutions for caching, job processing, and WebSockets
- **Simple Deployment**: Require Docker-ready deployment with minimal infrastructure complexity
- **Frontend Simplicity**: Prefer server-rendered HTML with progressive enhancement over heavy JavaScript frameworks
- **Cost Efficiency**: Start with simple, cost-effective solutions that can scale later

## Decision

We will build MyRailsApp using Rails 8.1 with a modern "Solid Stack" architecture, featuring Hotwire for frontend interactivity, Tailwind CSS for styling, SQLite3 for initial database needs, and Docker-based deployment.

### Key Components

#### Core Framework
- **Rails 8.1.1** - Latest stable Rails with modern defaults and improvements
- **Ruby 4.0.0-preview2** - Cutting-edge Ruby with YJIT and PRISM enabled

#### Frontend Stack
- **Hotwire** (Turbo + Stimulus) - SPA-like experience with minimal JavaScript
- **Tailwind CSS** - Utility-first CSS framework for rapid UI development
- **ImportMap-Rails** - Modern JavaScript module management without bundlers
- **Propshaft** - Modern asset pipeline (replacement for Sprockets)

#### Data Layer
- **SQLite3 (≥ 2.1)** - Primary database with separate databases for cache, queue, and cable in production
- **Multi-database architecture** - Separate databases for:
  - Primary application data
  - Cache store (Solid Cache)
  - Job queue (Solid Queue)
  - WebSocket connections (Solid Cable)

#### Infrastructure ("Solid Stack")
- **Solid Queue** - Database-backed job processing (replaces Redis/Sidekiq)
- **Solid Cache** - Database-backed caching (replaces Redis/Memcached)
- **Solid Cable** - Database-backed Action Cable (replaces Redis for WebSockets)

#### Deployment
- **Kamal** - Docker-based deployment tool
- **Thruster** - HTTP asset caching/compression and X-Sendfile acceleration for Puma
- **Puma Web Server** (≥ 5.0) - Multi-threaded Ruby web server
- **Docker** - Multi-stage Dockerfile with Ruby 3.4.1 slim base

#### Development Tools
- **Brakeman** - Security vulnerability scanner
- **RuboCop Rails Omakase** - Ruby code quality and style enforcement
- **Web Console** - In-browser debugging console
- **Minitest** - Testing framework with Capybara and Selenium for system tests

## Consequences

### Positive

- **Rapid Development**: Hot reload, convention over configuration, and comprehensive defaults enable fast iteration
- **Simplified Infrastructure**: Solid Stack eliminates need for Redis or separate job queue infrastructure
- **Modern Frontend**: Hotwire provides SPA-like UX without heavy JavaScript framework complexity
- **Production Ready**: All infrastructure components (caching, jobs, WebSockets) included out of the box
- **Docker-Native**: Easy deployment to any Docker-compatible host using Kamal
- **Cost Effective**: SQLite3 eliminates database hosting costs for early stages
- **Security Built-in**: Modern browser requirements, CSP, SSL enforcement, and Brakeman scanning
- **Latest Features**: Access to Rails 8.1 improvements (JSON escaping, redirect security, render tracking)

### Negative

- **SQLite Limitations**: May need migration to PostgreSQL/MySQL for high-concurrency scenarios
- **Solid Stack Maturity**: Solid components are newer, less battle-tested than Redis-based alternatives
- **Ruby Preview Version**: Using Ruby 4.0.0-preview2 may have stability issues
- **Multi-database Complexity**: Production uses 4 separate SQLite databases which increases operational overhead
- **Limited Scaling**: Solid Stack backed by SQLite won't scale to very high traffic without architectural changes

### Neutral

- **Framework Lock-in**: Heavily invested in Rails ecosystem and conventions
- **Hotwire Learning Curve**: Team needs to learn Turbo/Stimulus patterns vs traditional SPA frameworks
- **Docker Requirement**: Deployment strategy requires Docker knowledge and infrastructure

## Implementation

### Immediate Actions

1. ✅ Rails 8.1.1 installed and configured
2. ✅ Gemfile configured with all Solid Stack components
3. ✅ Frontend stack (Hotwire, Tailwind, ImportMap) integrated
4. ✅ Multi-database configuration for production environments
5. ✅ Docker and Kamal deployment configuration in place
6. ✅ Development tools (Brakeman, RuboCop) configured
7. ✅ Testing infrastructure (Minitest, Capybara, Selenium) set up
8. ⏳ Create initial database schema and models
9. ⏳ Define application routes and implement controllers
10. ⏳ Build initial views and UI components

### Long-term Considerations

- Monitor SQLite performance as data grows; plan migration to PostgreSQL if needed
- Evaluate Solid Stack performance under load; have fallback plan for Redis if needed
- Consider upgrading from Ruby 4.0.0-preview2 to stable release when available
- Plan for horizontal scaling strategy when application traffic increases
- Implement comprehensive monitoring and logging for production environment

## Alternatives Considered

### Alternative 1: Rails with Traditional Redis Stack

**Description**: Use Rails 8.1 but with Redis-backed Sidekiq, Redis caching, and Redis Action Cable

**Pros**:
- Battle-tested, proven at scale
- Better performance for high-concurrency scenarios
- Larger community and more resources
- More flexible scaling options

**Cons**:
- Additional infrastructure to manage (Redis server)
- Higher operational complexity
- Increased hosting costs
- More moving parts to configure and monitor

**Why not chosen**: Solid Stack provides sufficient performance for initial launch with dramatically reduced infrastructure complexity. We can migrate to Redis later if needed.

### Alternative 2: Rails API + React/Vue SPA Frontend

**Description**: Build Rails as pure API backend with separate React or Vue.js frontend

**Pros**:
- Maximum flexibility for frontend
- Rich ecosystem of frontend libraries
- Better for highly interactive UIs
- Easier to build mobile apps later

**Cons**:
- Significantly more development time
- Two separate codebases to maintain
- More complex deployment
- Slower initial development
- Need to solve state management, routing, etc.

**Why not chosen**: Hotwire provides sufficient interactivity for our needs with much faster development time. We can always add API endpoints later if needed for mobile apps.

### Alternative 3: Rails 7.x LTS

**Description**: Use Long-Term Support version of Rails 7 instead of Rails 8.1

**Pros**:
- More stable, proven in production
- Longer support lifecycle
- Fewer potential bugs
- More third-party gem compatibility

**Cons**:
- Miss out on Rails 8.1 improvements
- Don't get latest security features
- Eventual upgrade needed anyway
- Less modern defaults

**Why not chosen**: As a new application, we benefit from starting with the latest Rails features and conventions. Rails 8.1 includes important security improvements (redirect protection) and performance optimizations.

### Alternative 4: PostgreSQL Primary Database

**Description**: Start with PostgreSQL instead of SQLite3

**Pros**:
- Better for high-concurrency
- More features (JSON, full-text search, etc.)
- No migration needed later
- Industry standard for production Rails apps

**Cons**:
- Additional infrastructure to set up
- Slightly slower local development
- Hosting costs from day one
- More complex backup/restore procedures

**Why not chosen**: SQLite3 is sufficient for initial development and early production. Rails 8 improved SQLite support makes it viable for small-to-medium traffic. We can migrate to PostgreSQL when we hit SQLite limitations.

## Validation

### Success Criteria

- Application boots successfully in development and production environments
- Hot reload works correctly during development
- Hotwire provides smooth SPA-like navigation without full page reloads
- Background jobs process correctly via Solid Queue
- WebSocket connections work via Solid Cable
- Docker deployment succeeds via Kamal
- Security scan (Brakeman) passes with no critical issues
- Tests pass in CI environment

### Monitoring

- Application response times (target: <200ms p95)
- Background job processing times and queue depth
- Database query performance and N+1 detection
- Memory usage and Ruby heap size
- Error rates and exception tracking
- Security vulnerability scanning results

### Review Schedule

- **Initial review**: After first production deployment
- **Ongoing review**: Quarterly or when experiencing performance issues

## References

- [Rails 8.1 Release Notes](https://guides.rubyonrails.org/8_1_release_notes.html)
- [Rails Upgrade Guide](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html)
- [Hotwire Documentation](https://hotwired.dev/)
- [Solid Queue](https://github.com/basecamp/solid_queue)
- [Solid Cache](https://github.com/basecamp/solid_cache)
- [Solid Cable](https://github.com/basecamp/solid_cable)
- [Kamal Deployment](https://kamal-deploy.org/)
- [Rails 8 SQLite Improvements](https://fractaledmind.github.io/2024/04/15/sqlite-on-rails-the-how-and-why-of-optimal-performance/)

## Notes

### Configuration Highlights

- **Modern browser enforcement**: Requires webp, web push, badges, import maps, CSS nesting, CSS :has
- **Security posture**: SSL enforcement, secure cookies, CSP ready, CSRF protection
- **PWA support**: Manifest and service worker templates included (currently disabled)
- **CI environment**: New `config/ci.rb` environment for continuous integration
- **Rails 8.1 defaults**: New framework defaults in `config/initializers/new_framework_defaults_8_1.rb` (commented out, ready to enable)

### Recent Changes

- **2025-11-21**: Upgraded from Rails 8.0.1 to Rails 8.1.1
  - Added new CI environment configuration
  - Updated error page templates
  - Added Active Storage migrations
  - New framework defaults file created
  - Updated bin scripts and Dockerfile

### Future Considerations

- Consider enabling Rails 8.1 new defaults:
  - `escape_json_responses = false` (performance improvement)
  - `action_on_path_relative_redirect = :raise` (security enhancement)
  - `raise_on_missing_required_finder_order_columns = true` (query safety)
  - `render_tracker = :ruby` (template dependency tracking)
- Evaluate smart_message gem integration if messaging features needed
- Monitor Ruby 4.0.0 stability and plan upgrade to stable release
