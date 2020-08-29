#!/usr/bin/env python3

import argparse
import subprocess
import time
import multiprocessing
import sys
import datetime
import math

PASS_MSG = "The final verdict is Pass"
FAIL_MSG = "The final verdict is Fail"
ERROR_MSG = "The final verdict is Error"

class ParallelProcess:
    def __init__(self, args):
        self.p = subprocess.Popen(
            args=args,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT)

        self.startTime = time.time()
        self.endTime = None
        self.finished = False

    def isFinished(self):
        if self.finished or self.p.poll() != None:
            self.endTime = time.time()
            self.stdout = self.p.stdout.read().decode("utf-8")
            return True
        else:
            return False

    def getDuration(self):
        if self.endTime == None:
            return time.time() - self.startTime
        else:
            return self.endTime - self.startTime

    def killIfRunning(self):
        if not self.isFinished():
            self.p.kill()

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--file", type=str, help="input file to run", required=True)
    parser.add_argument("--num-jobs", type=int, help="number of parallel jobs", default=multiprocessing.cpu_count())
    parser.add_argument("--run-cutoff", type=int, help="number of passes or failures needed to cut the jobs off", default=100)
    parser.add_argument("--time-cutoff", type=int, help="time after which to cut off a job", default=300)
    args = parser.parse_args()

    print(f"""Checking {args.file} for instability with {args.num_jobs} jobs.
Search is cut off at {args.run_cutoff} passes or fails.
Jobs will be cut off after {args.time_cutoff}s.""")

    processArgs = ["./bin/vct", "--silicon", "--disable-sat", "--check-history", args.file]

    print(f"""Process command: {" ".join(processArgs)}""")

    pps = []
    for i in range(args.num_jobs):
        pps += [ParallelProcess(processArgs)]

    numPasses = 0
    numFails = 0
    numTimeOuts = 0
    startTime = time.time()
     
    lastOverview = time.time()
    while (numPasses == 0 or numFails == 0) and numPasses < args.run_cutoff and numFails < args.run_cutoff:
        time.sleep(0.01)
        for i in range(len(pps)):
            pp = pps[i]
            if pp.isFinished():
                if PASS_MSG in pp.stdout:
                    print("One passed! Output of process:")
                    print(pp.stdout)
                    numPasses += 1
                elif ERROR_MSG in pp.stdout:
                    print("One error! Output of process:")
                    print(pp.stdout)
                    sys.exit(1)
                elif FAIL_MSG in pp.stdout:
                    print("One failed! Output of process:")
                    print(pp.stdout)
                    numFails += 1
                else:
                    print("Unknown output! Output of process:")
                    print(pp.stdout)
                    sys.exit(2)

                print(f"Restarting pps[{i}]")
                pps[i] = ParallelProcess(processArgs)
            else:
                if pp.getDuration() >= args.time_cutoff:
                    print(f"pps[{i}] timed out, restarting")
                    pp.killIfRunning()
                    numTimeOuts += 1
                    pps[i] = ParallelProcess(processArgs)

        if time.time() - lastOverview >= 30:
            print(f"-- Passes: {numPasses}, fails: {numFails} (cutoff at {args.run_cutoff}) --")
            print(f"-- Overview durations {datetime.datetime.now()} --")
            lastOverview = time.time()

            for (i, pp) in enumerate(pps):
                print(f"pps[{i}]: {pp.getDuration()}s")

    print(f"Encountered {numPasses} passes, {numFails} fails, and {numTimeOuts} time-outs")
    print(f"Search took {round(time.time() - startTime)}s")

    subprocess.run(["notify-send", "manyRun.py finished"])
