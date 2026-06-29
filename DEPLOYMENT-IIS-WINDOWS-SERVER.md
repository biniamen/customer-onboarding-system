# Customer Onboarding IIS Deployment Guide

This guide deploys the solution to a Windows Server inside the bank network using:

- Angular frontend hosted as a static IIS site
- ASP.NET Core backend hosted as a separate IIS site on `127.0.0.1:5098`
- PostgreSQL database for application data
- Existing internal bank integrations reached through IIS reverse proxy

## 1. Final deployment architecture

```text
Bank User Browser
  -> http(s)://onboarding.bank.local
  -> IIS Frontend Site (Angular static files)
     -> /api/core/*                     -> IIS Backend Site on 127.0.0.1:5098
     -> /api/ida/*                      -> 10.10.13.68:8080
     -> /api/customer-image-signature/* -> 10.10.13.97
     -> /api/fcubs                      -> 10.1.200.153:7003 FCUBSCustomerService
     -> /api/fcubs-account              -> 10.1.200.153:7003 FCUBSAccService
```

## 2. Deployment outputs

Run the publish script from the solution root:

```powershell
cd "C:\Users\biniyamk\Documents\New project"
.\publish-iis.ps1
```

It creates:

- Frontend build: `C:\Users\biniyamk\Documents\New project\deploy\frontend`
- Backend publish: `C:\Users\biniyamk\Documents\New project\deploy\backend`

## 3. Server prerequisites

Install on the Windows Server:

1. IIS Web Server role
2. IIS features:
   - Static Content
   - Default Document
   - HTTP Errors
   - Request Filtering
   - IIS Management Console
   - ASP.NET 4.x is optional, not required for this app
3. URL Rewrite Module 2.x
4. Application Request Routing (ARR) 3.x
5. Enable proxy in ARR:
   - IIS Manager
   - Click server node
   - Open `Application Request Routing Cache`
   - Click `Server Proxy Settings`
   - Enable `Proxy`
6. ASP.NET Core Hosting Bundle for .NET 9
7. PostgreSQL server access from the application server
8. DNS or host entry for the bank-only site, for example:
   - `onboarding.bank.local`

## 4. Database preparation

Use PostgreSQL and create the database:

- Database name: `customer_onboarding_prod`

Connection string currently used by the backend:

```text
Host=localhost;Port=5432;Database=customer_onboarding_prod;Username=postgres;Password=Amen@2461
```

If the database server is different on the bank server, update:

- `C:\inetpub\customer-onboarding-api\appsettings.json`

The backend creates the initial schema automatically on startup and seeds the default users if they do not exist.

## 5. Recommended IIS folder structure

Create these folders on the server:

```text
C:\inetpub\customer-onboarding-app
C:\inetpub\customer-onboarding-api
```

Copy deployment outputs:

- Copy everything from `deploy\frontend` to `C:\inetpub\customer-onboarding-app`
- Copy everything from `deploy\backend` to `C:\inetpub\customer-onboarding-api`

## 6. Backend IIS site setup

Create the backend site first.

1. Open IIS Manager
2. Create a new Application Pool:
   - Name: `CustomerOnboardingApiPool`
   - .NET CLR version: `No Managed Code`
   - Managed pipeline mode: `Integrated`
3. Create a new IIS site:
   - Site name: `CustomerOnboardingApi`
   - Physical path: `C:\inetpub\customer-onboarding-api`
   - Binding type: `http`
   - IP address: `127.0.0.1`
   - Port: `5098`
   - Host name: leave blank
4. Assign the site to `CustomerOnboardingApiPool`
5. Open `C:\inetpub\customer-onboarding-api\appsettings.json`
6. Confirm or update:
   - database connection string
   - FCUBS account endpoint
   - seed users if needed
7. Start the site

Backend validation URL from the server itself:

```text
http://127.0.0.1:5098/api/core/auth/me
```

You should get `401 Unauthorized`, which confirms the backend is running.

## 7. Frontend IIS site setup

Create the frontend site second.

1. Create a new Application Pool:
   - Name: `CustomerOnboardingAppPool`
   - .NET CLR version: `No Managed Code`
   - Managed pipeline mode: `Integrated`
2. Create a new IIS site:
   - Site name: `CustomerOnboardingApp`
   - Physical path: `C:\inetpub\customer-onboarding-app`
   - Binding type: `http` or `https`
   - IP address: bank server internal IP
   - Port: `80` for HTTP or `443` for HTTPS
   - Host name: for example `onboarding.bank.local`
3. Assign the site to `CustomerOnboardingAppPool`
4. Confirm `web.config` exists in `C:\inetpub\customer-onboarding-app`
5. Start the site

The frontend `web.config` already handles:

- Angular SPA routing
- reverse proxy to the backend API on `127.0.0.1:5098`
- reverse proxy to IDA
- reverse proxy to customer image/signature upload
- reverse proxy to FCUBS customer creation
- reverse proxy to FCUBS account creation

## 8. Bank-network-only access

To keep the solution accessible only inside the bank:

1. Bind the frontend site only to the internal server IP or internal host name
2. Do not publish the site on any public IP
3. Add Windows Firewall inbound rules only for the bank subnet
4. Keep the backend site bound to `127.0.0.1:5098` only
5. Use internal DNS only, for example `onboarding.bank.local`
6. If HTTPS is used, use an internal bank certificate
7. Do not expose PostgreSQL to public networks

Recommended firewall approach:

- Allow frontend port `80` or `443` only from bank LAN ranges
- Do not allow inbound access to `5098` except localhost
- Keep outbound access open only to the required internal bank systems

## 9. Post-deployment validation checklist

Validate in this order:

1. Open the app using the internal URL
2. Login with maker user
3. Complete FAN verification
4. Create a customer request
5. Create CIF
6. Upload customer photo and signature
7. Submit for checker approval
8. Login as checker
9. Approve the pending request
10. Confirm account opening succeeds
11. Confirm the record appears in approved accounts
12. Confirm the branch filter works correctly

## 10. Default seeded users

These are currently seeded automatically:

- Maker:
  - Username: `maker01`
  - Password: `Maker@123`
  - Branch: `109`
- Checker:
  - Username: `checker01`
  - Password: `Checker@123`
  - Branch: `109`

Change these immediately on the server if the bank requires different operational users.

## 11. Operational files to know

Frontend site:

- `C:\inetpub\customer-onboarding-app\web.config`
- `C:\inetpub\customer-onboarding-app\assets\branding\GB.png`

Backend site:

- `C:\inetpub\customer-onboarding-api\appsettings.json`
- `C:\inetpub\customer-onboarding-api\web.config`

## 12. Troubleshooting

### Frontend opens but API calls fail

Check:

- ARR proxy is enabled
- URL Rewrite is installed
- backend site is running on `127.0.0.1:5098`
- frontend `web.config` exists after copy

### Backend site returns 500.30

Check:

- .NET 9 Hosting Bundle is installed
- app pool is set to `No Managed Code`
- `stdout` logs or Windows Event Viewer

### Database errors on startup

Check:

- PostgreSQL service is running
- connection string is correct
- database exists
- PostgreSQL user has permission to create tables

### Maker and checker cannot see records correctly

Check:

- user branch code values in database
- onboarding records branch values
- JWT token is refreshed after login

## 13. Official deployment resources

- ASP.NET Core on IIS:
  - https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/iis/?view=aspnetcore-9.0
- ASP.NET Core Module for IIS:
  - https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/aspnet-core-module?view=aspnetcore-9.0
- IIS URL Rewrite:
  - https://learn.iis.net/downloads/microsoft/url-rewrite
- IIS Application Request Routing:
  - https://www.iis.net/downloads/microsoft/application-request-routing
