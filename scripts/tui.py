#!/usr/bin/env python3
"""
Dotfiles Installer TUI
A ncurses-based interface for the layered installer.
"""

import argparse
import os
import sys
import subprocess
import threading
import time
from dataclasses import dataclass
from enum import Enum
from pathlib import Path
from typing import Optional

# Try to import blessed, fall back to basic mode
try:
    from blessed import Terminal
    HAS_BLESSED = True
except ImportError:
    HAS_BLESSED = False


@dataclass
class Layer:
    name: str
    title: str
    script: str
    status: str = "pending"  # pending, running, done, failed, skipped
    output: str = ""


class State(Enum):
    PENDING = "pending"
    RUNNING = "running"
    DONE = "done"
    FAILED = "failed"
    SKIPPED = "skipped"


# Layers definition
LAYERS = [
    Layer("os", "OS Packages", "layers/01-os.sh"),
    Layer("cargo", "Cargo Tools", "layers/02-cargo.sh"),
    Layer("npm", "NPM Packages", "layers/03-npm.sh"),
    Layer("config", "Configuration", "layers/04-config.sh"),
]


class InstallerTUI:
    def __init__(self, args, source_dir: Path):
        self.args = args
        self.source_dir = source_dir
        self.layers = {l.name: Layer(l.name, l.title, l.script) for l in LAYERS}
        self.lock = threading.Lock()
        self.running = True
        self.current_layer: Optional[str] = None
        self.output_buffer = ""
        self.exit_code = 0

        if HAS_BLESSED:
            self.t = Terminal()
        else:
            self.t = None

    def log(self, msg: str):
        """Thread-safe logging."""
        with self.lock:
            self.output_buffer += msg + "\n"
            if self.t:
                self.render()
            else:
                print(msg)

    def read_sentinel(self, layer_name: str) -> bool:
        """Check if a layer is already completed."""
        state_dir = Path.home() / ".local" / "state" / "dotfiles"
        sentinel = state_dir / f"{layer_name}.done"
        return sentinel.exists()

    def render(self):
        """Render the TUI."""
        if not self.t:
            return

        with self.t.fullscreen(), self.t.cbreak(), self.t.location(0, 0):
            lines = []
            lines.append(self.t.clear)

            # Header
            lines.append(self.t.bold(self.t.white_on_steelblue(" Dotfiles Installer ")))
            lines.append("")
            lines.append(f"  Source: {self.source_dir}")
            lines.append(f"  Mode: {'Dry run' if self.args.dry_run else 'Install'}")
            lines.append("")

            # Layer status
            lines.append("  " + self.t.underline("Layers"))
            lines.append("")

            for name, layer in self.layers.items():
                status_icon = self._status_icon(layer.status)
                status_color = self._status_color(layer.status)

                prefix = "  "
                if self.current_layer == name:
                    prefix = self.t.reverse(" >")

                status_line = f"{prefix} {status_icon} {layer.title:<20}"
                if layer.status == "done":
                    status_line += self.t.green(" [DONE]")
                elif layer.status == "failed":
                    status_line += self.t.red(" [FAILED]")
                elif layer.status == "running":
                    status_line += self.t.yellow(" [RUNNING...]")
                elif layer.status == "skipped":
                    status_line += self.t.dim(" [SKIPPED]")
                else:
                    status_line += self.t.dim(" [PENDING]")

                lines.append(status_line)

            # Output log
            lines.append("")
            lines.append("  " + self.t.underline("Output"))
            lines.append("")

            # Show last 10 lines of output
            output_lines = self.output_buffer.strip().split("\n")[-10:]
            for line in output_lines:
                if "ERROR" in line or "Failed" in line:
                    lines.append(self.t.red(f"    {line}"))
                elif "SUCCESS" in line or "Done" in line or "complete" in line:
                    lines.append(self.t.green(f"    {line}"))
                elif "SKIP" in line:
                    lines.append(self.t.yellow(f"    {line}"))
                else:
                    lines.append(self.t.dim(f"    {line}"))

            # Footer
            lines.append("")
            lines.append(f"  Press 'q' to quit, 'r' to restart")

            print("\n".join(lines), end="", flush=True)

    def _status_icon(self, status: str) -> str:
        icons = {
            "pending": "○",
            "running": "◐",
            "done": "●",
            "failed": "✗",
            "skipped": "◌",
        }
        return icons.get(status, "○")

    def _status_color(self, status: str) -> str:
        if not self.t:
            return ""
        colors = {
            "pending": self.t.dim,
            "running": self.t.yellow,
            "done": self.t.green,
            "failed": self.t.red,
            "skipped": self.t.dim,
        }
        return colors.get(status, self.t.dim)(self._status_icon(status))

    def run_layer(self, name: str):
        """Run a single layer."""
        layer = self.layers[name]
        script = self.source_dir / "scripts" / layer.script

        if not script.exists():
            layer.status = "failed"
            self.log(f"ERROR: Script not found: {script}")
            return

        self.current_layer = name
        layer.status = "running"
        self.log(f"Starting: {layer.title}")

        # Build command
        cmd = [str(script)]
        if self.args.dry_run:
            cmd.append("--dry-run")

        try:
            result = subprocess.run(
                cmd,
                cwd=str(self.source_dir),
                capture_output=True,
                text=True,
                timeout=self.args.timeout if self.args.timeout else 3600,
            )

            # Log output
            for line in (result.stdout + result.stderr).split("\n"):
                if line.strip():
                    self.log(line.strip())

            if result.returncode == 0:
                layer.status = "done"
                self.log(f"Done: {layer.title}")
            else:
                layer.status = "failed"
                self.log(f"Failed: {layer.title} (exit {result.returncode})")
                self.exit_code = 1

        except subprocess.TimeoutExpired:
            layer.status = "failed"
            self.log(f"Timeout: {layer.title} exceeded {self.args.timeout}s")
            self.exit_code = 1
        except Exception as e:
            layer.status = "failed"
            self.log(f"ERROR: {e}")
            self.exit_code = 1
        finally:
            self.current_layer = None

    def run(self):
        """Run all layers."""
        self.log("=" * 50)
        self.log("Dotfiles Installer Starting")
        self.log("=" * 50)

        # Check which layers should run
        for name in self.layers:
            if self.args.skip and name in self.args.skip:
                self.layers[name].status = "skipped"
                self.log(f"Skipping (--skip): {self.layers[name].title}")
            elif self.args.force and name in self.args.force:
                self.log(f"Force rerun: {self.layers[name].title}")

        if not HAS_BLESSED:
            self.log("")
            self.log("Note: Install 'blessed' for TUI mode:")
            self.log("  pip install blessed")
            self.log("")

        # Run layers sequentially
        for name in ["os", "cargo", "npm", "config"]:
            layer = self.layers[name]

            if layer.status == "skipped":
                continue

            # Skip already done unless forced
            if self.read_sentinel(name) and name not in (self.args.force or []):
                layer.status = "done"
                self.log(f"Already done: {layer.title} (use --force to rerun)")
                continue

            self.run_layer(name)

            # Stop on failure unless --continue
            if layer.status == "failed" and not self.args.continue_on_error:
                break

        self.running = False
        return self.exit_code


def main():
    parser = argparse.ArgumentParser(description="Dotfiles Installer TUI")
    parser.add_argument("--dry-run", action="store_true", help="Preview only")
    parser.add_argument("--skip", nargs="+", choices=["os", "cargo", "npm", "config"],
                        help="Skip layers")
    parser.add_argument("--force", nargs="+", choices=["os", "cargo", "npm", "config"],
                        help="Force rerun layers")
    parser.add_argument("--continue", dest="continue_on_error", action="store_true",
                        help="Continue on error")
    parser.add_argument("--timeout", type=int, default=3600,
                        help="Layer timeout in seconds")
    parser.add_argument("--cli", action="store_true", help="Force CLI mode")
    parser.add_argument("--no-color", action="store_true", help="Disable colors")

    args = parser.parse_args()

    # Find source directory
    script_dir = Path(__file__).parent.resolve()
    source_dir = script_dir.parent

    if not HAS_BLESSED or args.cli:
        # CLI fallback mode
        print("Running in CLI mode...")
        cmd = [str(script_dir / "install.sh")]
        if args.dry_run:
            cmd.append("--dry-run")
        if args.skip:
            for s in args.skip:
                cmd.extend(["--skip", s])
        if args.force:
            for f in args.force:
                cmd.extend(["--force", f])

        result = subprocess.run(cmd, cwd=str(source_dir))
        sys.exit(result.returncode)

    # Run TUI
    tui = InstallerTUI(args, source_dir)
    exit_code = tui.run()

    # Final render
    tui.render()

    print("")
    print("=" * 50)
    if exit_code == 0:
        print("✓ Installation complete!")
    else:
        print("✗ Installation completed with errors")
    print("=" * 50)

    sys.exit(exit_code)


if __name__ == "__main__":
    main()
