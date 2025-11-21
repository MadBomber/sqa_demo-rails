# ADR-002: Migrate to PostgreSQL Database

**Date**: 2025-11-21
**Status**: Accepted
**Decision Makers**: Development Team
**Tags**: database, postgresql, sqlite, ruby-4.0, testing
**Supersedes**: ADR-001 (Database section)

## Context

MyRailsApp was initially configured with SQLite3 as documented in ADR-001. While SQLite3 provided a simple starting point with the Solid Stack architecture, we need to migrate to PostgreSQL for two primary reasons:

1. **Ruby 4.0.0-preview2 Compatibility Testing**: As we're using Ruby 4.0.0-preview2, we need to validate that the `pg` gem works correctly with this preview Ruby version. Early testing helps identify potential compatibility issues before they become production problems.

2. **SQLite3 Limitations**: While SQLite3 works well for development and low-traffic applications, it has known limitations:
   - Limited write concurrency (single writer lock)
   - No network access (single-server only)
   - Limited connection pooling capabilities
   - Less robust under high concurrent load
   - More difficult to backup/restore in production

PostgreSQL is the industry standard for production Rails applications and provides better scalability, concurrency, and feature set for future growth.

## Decision Drivers

- **Ruby Preview Testing**: Need to validate `pg` gem compatibility with Ruby 4.0.0-preview2
- **Production Readiness**: PostgreSQL is better suited for production workloads
- **Write Concurrency**: Need better handling of concurrent writes
- **Advanced Features**: Access to JSON columns, full-text search, advanced indexing
- **Industry Standard**: Team familiarity and abundance of resources/tooling
- **Scalability**: Better prepared for horizontal scaling and replication
- **Development Environment**: PostgreSQL 17.7 already installed and operational

## Decision

We will migrate from SQLite3 to PostgreSQL 17.7 as the primary database for all environments (development, test, production). We will maintain the multi-database architecture established in ADR-001, using separate PostgreSQL databases for:
- Primary application data
- Solid Cache storage
- Solid Queue job data
- Solid Cable WebSocket connections

### Key Configuration

#### Database Setup
- **Development**:
  - Databases: `my_rails_app_development`, `my_rails_app_cache_development`, `my_rails_app_queue_development`, `my_rails_app_cable_development`
  - Connection: Local PostgreSQL server (localhost:5432)
  - Authentication: System user with trust authentication

- **Test**:
  - Databases: `my_rails_app_test`, `my_rails_app_cache_test`, `my_rails_app_queue_test`, `my_rails_app_cable_test`
  - Connection: Local PostgreSQL server (localhost:5432)

- **Production**:
  - Databases: `my_rails_app_production`, `my_rails_app_cache_production`, `my_rails_app_queue_production`, `my_rails_app_cable_production`
  - Connection: Via DATABASE_URL environment variable
  - Pool size: 5 connections per database

#### Gem Changes
- Remove: `sqlite3` gem (>= 2.1)
- Add: `pg` gem (>= 1.1)

## Consequences

### Positive

- **Proven Scalability**: PostgreSQL handles high-concurrency production workloads effectively
- **Advanced Features**: JSON/JSONB columns, full-text search, advanced indexing, window functions
- **Better Concurrency**: Multiple concurrent writers without locking issues
- **Network Access**: Database can be on separate server for scaling
- **Robust Tooling**: pgAdmin, psql, extensive monitoring and backup tools
- **Replication**: Built-in streaming replication for high availability
- **Ruby 4.0 Validation**: Early testing identifies any compatibility issues with preview Ruby
- **Team Knowledge**: PostgreSQL is well-known standard in Rails community
- **Production Ready**: Used by majority of production Rails applications

### Negative

- **Local Development Requirement**: Requires PostgreSQL server running locally
- **Increased Complexity**: More configuration than SQLite3's single-file approach
- **Memory Usage**: PostgreSQL uses more memory than SQLite3
- **Setup Overhead**: New developers need to install and configure PostgreSQL
- **Backup Complexity**: Database dumps instead of simple file copies
- **Docker Builds**: Dockerfile needs PostgreSQL client libraries

### Neutral

- **Migration Effort**: Since no data exists yet, migration is configuration-only
- **Development Speed**: Similar development experience once configured
- **Cost**: PostgreSQL hosting has cost implications for production (vs SQLite file)

## Implementation

### Immediate Actions

1. Update Gemfile: Replace `sqlite3` gem with `pg` gem
2. Run `bundle install` to install PostgreSQL adapter
3. Reconfigure `config/database.yml` with PostgreSQL settings for all databases
4. Update Dockerfile to include PostgreSQL client libraries (libpq-dev)
5. Create all databases: `rails db:create`
6. Verify database connections: `rails db:migrate:status`
7. Update `.gitignore` if needed (remove SQLite-specific entries)
8. Test application boot in all environments
9. Validate Solid Stack components work with PostgreSQL
10. Document PostgreSQL setup instructions in README

### Long-term Considerations

- Set up database backup strategy for production
- Configure connection pooling optimization (PgBouncer if needed)
- Implement database monitoring (pg_stat_statements, query performance)
- Plan for read replicas if scaling requires it
- Consider database maintenance tasks (VACUUM, ANALYZE, REINDEX)
- Monitor Ruby 4.0.0-preview2 + pg gem for any issues
- Upgrade to stable Ruby 4.0.0 when released

## Alternatives Considered

### Alternative 1: Stay with SQLite3

**Description**: Keep SQLite3 as chosen in ADR-001

**Pros**:
- No changes needed
- Simpler local development
- Zero infrastructure for database
- Perfect for prototyping

**Cons**:
- Can't test pg gem with Ruby 4.0.0-preview2
- Limited write concurrency
- Poor fit for production at scale
- Eventually need to migrate anyway

**Why not chosen**: Need to validate Ruby 4.0.0-preview2 compatibility with PostgreSQL. SQLite limitations will eventually require migration, so better to do it now while there's no data.

### Alternative 2: MySQL/MariaDB

**Description**: Use MySQL or MariaDB instead of PostgreSQL

**Pros**:
- Also production-ready and scalable
- Good performance characteristics
- Wide adoption and tooling
- Can test mysql2 gem with Ruby 4.0.0-preview2

**Cons**:
- Less feature-rich than PostgreSQL
- Fewer advanced data types
- Less consistent with Rails conventions
- Not as strong for JSON/JSONB support

**Why not chosen**: PostgreSQL is the Rails community standard and has better feature alignment with modern Rails applications. Already have PostgreSQL 17.7 installed.

### Alternative 3: Cloud Database Service

**Description**: Use managed PostgreSQL (AWS RDS, Digital Ocean, Heroku Postgres, etc.)

**Pros**:
- No local database management
- Automatic backups
- Easy scaling
- High availability options

**Cons**:
- Monthly costs from day one
- Network latency in development
- Requires internet connection to develop
- More complex local setup
- Can't develop offline

**Why not chosen**: For development and testing, local PostgreSQL is more practical. Cloud database services can be adopted for production deployment later.

## Validation

### Success Criteria

- `bundle install` completes successfully with pg gem
- All databases create without errors
- Rails application boots in development
- Test suite runs successfully
- Solid Cache, Solid Queue, and Solid Cable work with PostgreSQL
- No Ruby 4.0.0-preview2 compatibility issues detected
- Database migrations run correctly
- Connection pooling works as expected

### Compatibility Testing

- Verify pg gem version compatibility with Ruby 4.0.0-preview2
- Test all CRUD operations
- Test concurrent write operations
- Test Solid Queue job processing
- Test Solid Cable WebSocket connections
- Test Solid Cache read/write operations
- Monitor for any Ruby preview-related errors or warnings

### Monitoring

- Database connection pool usage
- Query performance and slow query log
- Database size growth
- Connection errors or timeouts
- Ruby compatibility issues or deprecation warnings

### Review Schedule

- **Immediate**: After initial setup and configuration
- **Short-term**: When Ruby 4.0.0 stable is released (validate upgrade)
- **Ongoing**: Quarterly review of database performance

## References

- [PostgreSQL Documentation](https://www.postgresql.org/docs/17/)
- [Rails Guide: Configuring Rails Applications](https://guides.rubyonrails.org/configuring.html#configuring-a-database)
- [pg gem GitHub](https://github.com/ged/ruby-pg)
- [PostgreSQL on Rails Performance](https://www.postgresql.org/docs/current/performance-tips.html)
- [Solid Queue with PostgreSQL](https://github.com/basecamp/solid_queue#database-requirements)
- [Ruby 4.0.0-preview2 Release Notes](https://www.ruby-lang.org/en/news/)
- Related ADRs: [ADR-001: Rails 8.1 Modern Stack Architecture](ADR-001-rails-81-modern-stack-architecture.md)

## Notes

### PostgreSQL 17.7 Features

PostgreSQL 17 includes several improvements:
- Enhanced performance for parallel queries
- Improved JSON processing
- Better vacuuming and maintenance
- Logical replication enhancements
- Incremental backup support

### Ruby 4.0.0-preview2 Considerations

As an early preview release, Ruby 4.0.0-preview2 may have:
- Compatibility issues with native extensions (like pg gem)
- Performance characteristics different from stable releases
- Potential bugs or unexpected behavior
- Breaking changes before stable release

This migration helps identify any issues early, allowing time to report bugs to Ruby core team or pg gem maintainers if needed.

### Migration Notes

Since this is a fresh Rails application with no production data:
- No data migration required
- Only configuration changes needed
- Safe to switch before building models and schema
- Ideal time to make this architectural change

### Connection Details

Development database connection uses:
- Host: localhost (127.0.0.1)
- Port: 5432 (PostgreSQL default)
- Username: System username (via trust authentication)
- Password: Not required for local development
- Encoding: UTF-8
- Pool: 5 connections per database

Production will use DATABASE_URL environment variable for security and flexibility.
