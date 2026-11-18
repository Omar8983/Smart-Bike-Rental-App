# Documentation

This folder holds the design documents for Milestone 2.

| File | Description | Status |
| ---- | ----------- | ------ |
| `erd.drawio` | Editable Entity-Relationship Diagram (open with [draw.io](https://app.diagrams.net/)) | To be added manually |
| `erd.png` | Exported image of the ERD, shown in the main README | To be added manually |

The ERD must match [`../schema/01_create_tables.sql`](../schema/01_create_tables.sql):

- Exactly six tables: `users`, `stations`, `bikes`, `rentals`, `pricing_plans`, `damage_reports`
- Eight one-to-many relationships (see the **Relationships** section in the [main README](../README.md))
- `rentals` has **two** separate relationships to `stations` (`start_station_id` and `end_station_id`)
- Nullable foreign keys: `bikes.station_id` and `rentals.end_station_id`
