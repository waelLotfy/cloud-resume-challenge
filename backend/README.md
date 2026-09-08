# Backend (Logic Tier)

Lambda function source code backing the API Gateway defined in
`infrastructure/modules/logic`.

## Structure

```
backend/
├── functions/
│   └── get_visitor_count/   # one directory per Lambda function
│       ├── __init__.py
│       └── handler.py
├── shared/                  # code shared across functions
└── requirements.txt
```

## Status

Placeholder scaffold only — `get_visitor_count` is a naming placeholder
illustrating the intended per-function layout. Implementation will begin
once requirements (`docs/requirements/`) and the architecture
(`docs/architecture/architecture-overview.md`) are finalized.

## Testing

Unit tests for backend functions live under
[`tests/unit`](../tests/unit) and are run with `pytest`.
