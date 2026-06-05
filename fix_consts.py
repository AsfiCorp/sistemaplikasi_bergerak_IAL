import subprocess
import re

def run_analyze():
    print("Running flutter analyze...")
    result = subprocess.run(['flutter', 'analyze'], capture_output=True, text=True)
    return result.stdout + result.stderr

def fix_errors(output):
    pattern = re.compile(r'error • .*? • (lib/.*?\.dart):(\d+):\d+ • const_eval_method_invocation')
    
    fixes_made = 0
    for match in pattern.finditer(output):
        filepath = match.group(1)
        line_num = int(match.group(2)) - 1
        
        with open(filepath, 'r') as f:
            lines = f.readlines()
            
        if 'const ' in lines[line_num]:
            lines[line_num] = lines[line_num].replace('const ', '')
            with open(filepath, 'w') as f:
                f.writelines(lines)
            fixes_made += 1
            print(f"Removed const in {filepath} at line {line_num + 1}")
        else:
            for i in range(line_num, max(-1, line_num - 5), -1):
                if 'const ' in lines[i]:
                    lines[i] = lines[i].replace('const ', '')
                    with open(filepath, 'w') as f:
                        f.writelines(lines)
                    fixes_made += 1
                    print(f"Removed const in {filepath} at line {i + 1} for error at {line_num + 1}")
                    break
    
    return fixes_made

def main():
    while True:
        output = run_analyze()
        fixes = fix_errors(output)
        if fixes == 0:
            break
        print(f"Made {fixes} fixes in this iteration.")

if __name__ == '__main__':
    main()
