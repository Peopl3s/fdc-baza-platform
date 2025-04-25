import sys
from pathlib import Path

current_path = Path(__file__).parent.parent.resolve()
sys.path.append(str(current_path))
