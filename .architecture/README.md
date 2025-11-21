# Architecture Documentation

This directory contains architectural decisions, reviews, and documentation for MyRailsApp.

## Structure

```
.architecture/
├── config.yml              # Framework configuration
├── decisions/              # Architectural decisions
│   └── adrs/              # Architecture Decision Records
├── reviews/               # Architecture review reports
└── templates/             # Document templates
    └── adr-template.md    # ADR template
```

## Architecture Decision Records (ADRs)

ADRs document important architectural decisions made for this project. Each ADR captures:
- The context and problem being addressed
- The decision made and why
- Consequences (positive, negative, neutral)
- Alternatives considered
- Implementation plan
- Success criteria and validation

### Current ADRs

- [ADR-001: Rails 8.1 Modern Stack Architecture](decisions/adrs/ADR-001-rails-81-modern-stack-architecture.md) - Foundational technology stack decisions

## Creating a New ADR

1. Use the template in `templates/adr-template.md`
2. Number sequentially (ADR-002, ADR-003, etc.)
3. Use kebab-case for filenames: `ADR-XXX-descriptive-title.md`
4. Save in `decisions/adrs/` directory

## ADR Status Lifecycle

- **Proposed**: Documented but not yet approved
- **Accepted**: Approved and should be implemented
- **Deprecated**: No longer best practice but not replaced
- **Superseded**: Replaced by newer ADR (reference the new one)

## When to Create an ADR

**Do create for**:
- Technology choices (frameworks, databases, languages)
- Architectural patterns (microservices, event-driven, etc.)
- Infrastructure decisions (cloud provider, deployment)
- Security approaches (authentication, encryption)
- Major library or dependency choices

**Don't create for**:
- Implementation details (function names, variable names)
- Temporary or experimental decisions
- Minor decisions with limited impact
- Coding style (use linting configs instead)

## Configuration

See `config.yml` for framework settings including:
- Pragmatic mode configuration
- Review requirements
- Documentation preferences
