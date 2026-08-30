import subprocess

message = "Hi TaiseiYokoshima! You've successfully authenticated, but GitHub does not provide shell access."

result = subprocess.run(
    ["ssh", "-T", "mgh"],
    capture_output=True,
    text=True
).stderr

if message in result:
    exit(0)
else:
    exit(1)
