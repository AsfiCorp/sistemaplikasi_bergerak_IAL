import os

replacements = {
    'AppTheme.primaryOlive': 'Theme.of(context).primaryColor',
    'AppTheme.secondaryCharcoal': 'Theme.of(context).colorScheme.onSurface',
    'AppTheme.backgroundCream': 'Theme.of(context).scaffoldBackgroundColor',
    'AppTheme.tertiaryMutedOlive': 'Theme.of(context).colorScheme.secondary',
}

def process_file(filepath):
    if filepath.endswith('theme.dart'):
        return
    
    with open(filepath, 'r') as f:
        content = f.read()
    
    new_content = content
    for old, new in replacements.items():
        new_content = new_content.replace(old, new)
        
    if new_content != content:
        with open(filepath, 'w') as f:
            f.write(new_content)
        print(f"Updated {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))
