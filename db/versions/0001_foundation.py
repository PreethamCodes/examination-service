"""Initial private examination schema."""
from pathlib import Path

from alembic import op

revision = "examination_0001"
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    sql = Path(__file__).with_suffix(".sql").read_text(encoding="utf-8")
    op.get_bind().exec_driver_sql(sql)


def downgrade():
    raise RuntimeError("Restore from a reviewed backup for this initial schema.")
