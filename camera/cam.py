#!/usr/bin/python3
import subprocess
import time

class FlashMode:
    AUTO = 0
    ON = 1
    OFF = 2

class Camera:
    def __init__(self):
        self.proc = subprocess.Popen(
            "./run",
            stdin=subprocess.PIPE,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            shell=True)
        self._command("c")
        self._command("rec")
        self._command("lua", "require(\"capmode\").set(\"MONOCHROME\")")
        time.sleep(5)
        self.set_flash_mode(FlashMode.OFF)

    def _command(self, command, *args):
        cmdList = [command] + list(args)
        self.proc.stdin.write(bytearray(" ".join(cmdList) + "\n", "utf-8"))
        self.proc.stdin.flush()

    def shoot(self):
        self._command("remoteshoot")

    def set_flash_mode(self, mode):
        flash_prop = 143
        self._command("lua", "set_prop(%d, %d)" % (flash_prop, mode))

    def __del__(self):
        self.proc.stdin.close()
        try:
            self.proc.wait(timeout=10)
        except subprocess.TimeoutExpired:
            print("Timeout waiting for chdkptp to end, forcing a kill")
            self.proc.kill()
            self.proc.wait()

c = Camera()

cmd = input()
while cmd != "":
    c._command(cmd)
    cmd = input()
del c
