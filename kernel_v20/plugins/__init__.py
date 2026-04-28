"""
NEXA-Kernel v2.0 Plugins Package
Plugin management and registry
"""

from plugins.manager import PluginManager
from plugins.registry import PluginRegistry

__version__ = "2.0.6"
__all__ = [
    "PluginManager",
    "PluginRegistry",
]