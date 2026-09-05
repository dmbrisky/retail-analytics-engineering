# Retail Analytics Engineering

A hands-on analytics engineering project built with dbt and DuckDB using the Brazilian Olist e-commerce dataset. The project demonstrates transformation, dimensional modeling, data quality testing, incremental processing, historical change tracking, reusable SQL logic, and Git-based development practices.

## Project Architecture

The project follows a layered dbt structure:

**Sources → Staging → Intermediate → Marts**

* **Sources** define the raw Olist datasets used by dbt.
* **Staging models** standardize and prepare source data for downstream transformations.
* **Intermediate models** contain reusable transformation logic between staging and reporting models.
* **Marts** provide business-ready fact and dimension models for analytics and reporting.

The analytical layer includes models for orders, order items, customers, products, and related e-commerce data.

## Data Modeling

The project applies dimensional modeling principles to create business-ready analytical datasets.

Models include fact and dimension structures supporting analysis of:

* Orders and order status
* Customers
* Products
* Order items
* Payments
* Delivery and fulfillment activity

Model grain, relationships, and business logic are defined within the dbt transformation layer.

## Data Quality

Data quality validation is implemented using dbt tests, including:

* Primary-key uniqueness and not-null validation
* Referential integrity between fact and dimension models
* Accepted-value validation
* Business-rule testing

A custom singular test identifies delivered orders that do not have associated payment data. The known exception is configured as a warning rather than a build failure.

## Incremental Processing

`int_orders_incremental` demonstrates incremental processing using `order_id` as the unique key.

The model uses a three-day lookback window based on `order_purchase_timestamp` so recent records can be reprocessed while avoiding a full rebuild of historical order data.

Incremental behavior was tested using simulated source-data changes.

## Historical Change Tracking

`order_status_snapshot` uses a dbt snapshot with the `check` strategy to preserve historical changes to order status.

When an order's status changes, dbt retains the previous version and creates a new current version, allowing order-status history to be analyzed over time.

## Reusable Logic

The project includes a custom dbt macro for identifying orders with missing payment information.

This demonstrates how repeated SQL business logic can be centralized and reused across dbt models.

## Development Workflow

Development is managed through Git and GitHub using:

* Feature branches
* Git commits and pushes
* Pull requests
* Merge-conflict resolution
* Automated CI validation

A GitHub Actions workflow runs dbt project validation automatically for pull requests targeting `main`.

## Technology

* dbt
* DuckDB
* SQL
* Jinja
* Git
* GitHub
* GitHub Actions

## Dataset

This project uses the Brazilian Olist e-commerce dataset. Raw source files are intentionally excluded from the repository and are not tracked by Git.
