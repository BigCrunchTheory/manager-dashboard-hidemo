# Manager App Mock Server

Simple Express mock server implementing two endpoints used by the manager app for testing.

How to run (Windows PowerShell):

1. cd to this folder

```powershell
cd manager_app/mock_server
npm install
npm start
```

Endpoints:

- GET /api/v1/manager/locations
  - query params: preset=TODAY|YESTERDAY|THIS_WEEK|THIS_MONTH|LAST_WEEK|LAST_MONTH|ALL_TIME
  - or: from=YYYY-MM-DD&to=YYYY-MM-DD

- GET /api/v1/manager/locations/cards
  - returns sample list of location cards
