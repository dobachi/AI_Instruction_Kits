#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Modular instruction composer engine
Enhanced with distributed metadata system
"""

import argparse
import json
import os
import sys
import yaml
from pathlib import Path
from typing import List, Dict, Optional, Any


class InstructionComposer:
    """Main class for composing instructions"""
    
    def __init__(self, modular_dir: Path = Path("modular")):
        self.modular_dir = modular_dir
        self.modules_dir = modular_dir / "modules"
        self.templates_dir = modular_dir / "templates"
        self.cache_file = modular_dir / "catalog_cache.json"
        self._module_cache = None
        
    def discover_modules(self, force_refresh: bool = False) -> Dict[str, Dict[str, Any]]:
        """
        Discover all modules by scanning directories and reading metadata files
        
        Args:
            force_refresh: Force refresh even if cache exists
            
        Returns:
            Dictionary of modules organized by category
        """
        # Use cache if available and not forcing refresh
        if not force_refresh and self._module_cache is not None:
            return self._module_cache
            
        # Try to load from cache file
        if not force_refresh and self.cache_file.exists():
            try:
                with open(self.cache_file, 'r', encoding='utf-8') as f:
                    self._module_cache = json.load(f)
                    return self._module_cache
            except Exception:
                pass  # Ignore cache errors
        
        # Discover modules from filesystem
        modules = {}
        
        for category in ['core', 'tasks', 'skills', 'quality', 'fragments']:
            category_path = self.modules_dir / category
            if not category_path.exists():
                continue
                
            modules[category] = {}
            
            # Find all .yaml files in the category
            for yaml_file in category_path.glob('**/*.yaml'):
                # Skip if no corresponding .md file exists
                md_file = yaml_file.with_suffix('.md')
                if not md_file.exists():
                    continue
                    
                try:
                    with open(yaml_file, 'r', encoding='utf-8') as f:
                        metadata = yaml.safe_load(f)
                        
                    # Add file paths to metadata
                    metadata['_yaml_path'] = str(yaml_file.relative_to(self.modular_dir))
                    metadata['_md_path'] = str(md_file.relative_to(self.modular_dir))
                    
                    # Use the ID from metadata
                    module_id = metadata.get('id', yaml_file.stem)
                    modules[category][module_id] = metadata
                    
                except Exception as e:
                    print(f"Warning: Failed to load metadata from {yaml_file}: {e}")
        
        # Save to cache
        self._module_cache = modules
        try:
            with open(self.cache_file, 'w', encoding='utf-8') as f:
                json.dump(modules, f, indent=2, ensure_ascii=False)
        except Exception:
            pass  # Ignore cache write errors
            
        return modules
    
    def find_module(self, module_id: str) -> Optional[Dict[str, Any]]:
        """Find a module by its ID"""
        modules = self.discover_modules()
        
        for category, category_modules in modules.items():
            if module_id in category_modules:
                return category_modules[module_id]
                
        return None
    
    def load_module_content(self, module_metadata: Dict[str, Any]) -> str:
        """Load the actual content of a module"""
        md_path = self.modular_dir / module_metadata['_md_path']
        
        with open(md_path, 'r', encoding='utf-8') as f:
            return f.read()
    
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
        
        # Find all modules
        modules_metadata = []
        missing_modules = []
        
        for module_id in module_ids:
            metadata = self.find_module(module_id)
            if metadata:
                modules_metadata.append(metadata)
            else:
                missing_modules.append(module_id)
        
        if missing_modules:
            return f"Error: The following modules were not found: {', '.join(missing_modules)}"
        
        # Phase 1: Still return prototype message
        content = []
        content.append("# Modular Instruction (Prototype)\n")
        content.append("*Note: This is Phase 1 prototype with distributed metadata. Actual module composition will be implemented in Phase 2.*\n")
        content.append("## Selected Modules\n")
        
        for metadata in modules_metadata:
            content.append(f"- {metadata['id']}: {metadata.get('name', metadata['id'])}")
            content.append(f"  - Description: {metadata.get('description', 'No description')}")
            content.append(f"  - Version: {metadata.get('version', 'unknown')}")
        
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
            metadata = self.find_module(module_id)
            if metadata:
                info.append(f"  - {module_id}: {metadata.get('name', 'Unknown')}")
            else:
                info.append(f"  - {module_id}: [NOT FOUND]")
        
        if variables:
            info.append("\nVariables:")
            for key, value in variables.items():
                info.append(f"  - {key} = {value}")
        
        return "\n".join(info)
    
    def get_preset(self, preset_name: str) -> Optional[Dict[str, Any]]:
        """Get preset configuration"""
        preset_file = self.templates_dir / "presets" / f"{preset_name}.yaml"
        
        if not preset_file.exists():
            return None
            
        try:
            with open(preset_file, 'r', encoding='utf-8') as f:
                return yaml.safe_load(f)
        except Exception:
            return None
    
    def list_modules(self) -> str:
        """List all available modules"""
        modules = self.discover_modules()
        output = []
        
        for category, category_modules in modules.items():
            if category_modules:
                output.append(f"\n{category.upper()} MODULES:")
                for module_id, metadata in category_modules.items():
                    output.append(f"  - {module_id}: {metadata.get('name', 'Unknown')}")
                    if metadata.get('description'):
                        output.append(f"    {metadata['description']}")
        
        return "\n".join(output)


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
    parser.add_argument("--list", action="store_true",
                       help="List all available modules")
    parser.add_argument("--refresh-cache", action="store_true",
                       help="Refresh module cache")
    
    args = parser.parse_args()
    
    composer = InstructionComposer()
    
    # Handle special commands
    if args.list:
        print(composer.list_modules())
        sys.exit(0)
    
    if args.refresh_cache:
        composer.discover_modules(force_refresh=True)
        print("Module cache refreshed")
        sys.exit(0)
    
    # Collect module IDs
    module_ids = []
    
    # Get modules from preset
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
        print("Use --list to see available modules")
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