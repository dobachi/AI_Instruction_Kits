#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Modular instruction composer engine
Simple initial implementation (Phase 1)
"""

import argparse
import os
import sys
import yaml
from pathlib import Path
from typing import List, Dict, Optional, Any


class InstructionComposer:
    """Main class for composing instructions"""
    
    def __init__(self, modular_dir: Path = Path("modular")):
        self.modular_dir = modular_dir
        self.catalog_path = modular_dir / "catalog.yaml"
        self.catalog = self._load_catalog()
        
    def _load_catalog(self) -> Dict[str, Any]:
        """Load catalog file"""
        if not self.catalog_path.exists():
            print(f"Warning: Catalog file not found: {self.catalog_path}")
            return {"modules": {}, "presets": {}}
            
        with open(self.catalog_path, 'r', encoding='utf-8') as f:
            return yaml.safe_load(f)
    
    def compose(self, 
                module_ids: List[str], 
                variables: Optional[Dict[str, str]] = None,
                dry_run: bool = False) -> str:
        """
        Compose modules to generate instruction
        
        Args:
            module_ids: List of module IDs to use
            variables: Dictionary of variables
            dry_run: If True, only show info without generating
            
        Returns:
            Generated instruction string
        """
        if dry_run:
            return self._dry_run_info(module_ids, variables)
        
        # Phase 1: Return simple message
        content = []
        content.append("# Modular Instruction (Prototype)\n")
        content.append("*Note: This is Phase 1 prototype. Actual module composition will be implemented in Phase 2.*\n")
        content.append("## Selected Modules\n")
        
        for module_id in module_ids:
            content.append(f"- {module_id}")
        
        if variables:
            content.append("\n## Variables\n")
            for key, value in variables.items():
                content.append(f"- {key}: {value}")
        
        content.append("\n---\n*In Phase 2, actual module files will be loaded and combined.*")
        
        return "\n".join(content)
    
    def _dry_run_info(self, module_ids: List[str], variables: Optional[Dict[str, str]]) -> str:
        """Display dry run information"""
        info = []
        info.append("=== Dry Run Info ===")
        info.append(f"Module count: {len(module_ids)}")
        info.append("Selected modules:")
        for module_id in module_ids:
            info.append(f"  - {module_id}")
        
        if variables:
            info.append("\nVariables:")
            for key, value in variables.items():
                info.append(f"  - {key} = {value}")
        
        return "\n".join(info)
    
    def get_preset(self, preset_name: str) -> Optional[Dict[str, Any]]:
        """Get preset configuration"""
        presets = self.catalog.get("presets", {})
        return presets.get(preset_name)


def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(description="Modular instruction composer")
    parser.add_argument("--module", action="append", dest="modules", 
                       help="Module ID to use (can specify multiple)")
    parser.add_argument("--preset", help="Preset name")
    parser.add_argument("--output", help="Output file name")
    parser.add_argument("--variable", action="append", dest="variables",
                       help="Variable setting (KEY=VALUE format)")
    parser.add_argument("--dry-run", action="store_true", 
                       help="Show info without generating")
    
    args = parser.parse_args()
    
    # Collect module IDs
    module_ids = []
    
    # Get modules from preset
    composer = InstructionComposer()
    if args.preset:
        preset = composer.get_preset(args.preset)
        if preset and "modules" in preset:
            module_ids.extend(preset["modules"])
        else:
            print(f"Warning: Preset '{args.preset}' not found")
    
    # Add modules from command line
    if args.modules:
        module_ids.extend(args.modules)
    
    if not module_ids:
        print("Error: No modules specified")
        print("Use --module or --preset option")
        sys.exit(1)
    
    # Parse variables
    variables = {}
    if args.variables:
        for var in args.variables:
            if "=" in var:
                key, value = var.split("=", 1)
                variables[key] = value
    
    # Generate instruction
    result = composer.compose(module_ids, variables, args.dry_run)
    
    # Output
    if args.output and not args.dry_run:
        output_path = Path(args.output)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(result)
        print(f"Generated instruction: {output_path}")
    else:
        print(result)


if __name__ == "__main__":
    main()