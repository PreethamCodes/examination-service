"""Run this repository's migrations in its own transaction and schema."""
import os

from alembic import context
from sqlalchemy import create_engine

engine = create_engine(os.environ["MIGRATION_DATABASE_URL"])
with engine.begin() as connection:
    connection.exec_driver_sql("CREATE SCHEMA IF NOT EXISTS examination")
    context.configure(connection=connection, version_table_schema="examination")
    with context.begin_transaction():
        context.run_migrations()
