#!/usr/bin/env python3

import argparse
import subprocess
import time
import multiprocessing
import sys
import datetime
import math

from enum import Enum, unique, auto
from shutil import which
from pathlib import Path

@unique
class Solver(Enum):
    VERCORS = auto(),
    SILICON = auto()

@unique
class Result(Enum):
    PASS = auto(),
    FAIL = auto(),
    ERROR = auto(),
    UNKNOWN = auto()

VERCORS_PASS_MSG = "The final verdict is Pass"
VERCORS_FAIL_MSG = "The final verdict is Fail"
VERCORS_ERROR_MSG = "The final verdict is Error"

VIPER_PASS_MSG = "Silicon finished verification successfully in"
VIPER_FAIL_MSG = "Silicon found"
VIPER_ERROR_MSG = "Parse error"

viperMarkers = {
    Result.PASS: VIPER_PASS_MSG,
    Result.FAIL: VIPER_FAIL_MSG,
    Result.ERROR: VIPER_ERROR_MSG
}

markers = {
    Solver.VERCORS: {
        Result.PASS: VERCORS_PASS_MSG,
        Result.FAIL: VERCORS_FAIL_MSG,
        Result.ERROR: VERCORS_ERROR_MSG
    },
    Solver.SILICON: viperMarkers
}

def getResult(solver, pp):
    for result in [Result.PASS, Result.ERROR, Result.FAIL]:
        if markers[solver][result] in pp.stdout:
            return result

    return Result.UNKNOWN

def findVerCors():
    path = which("vct")
    if path != None:
        return Path(path)

    path = Path("./bin/vct")
    if path.exists():
        return path

    raise Exception("VerCors not found")

def findSilicon():
    path = which("silicon.sh")
    if path != None:
        return Path(path)

    path = Path("./silicon.sh")
    if path.exists():
        return path

    raise Exception("Silicon not found")

def findZ3():
    path = which("z3")
    if path != None:
        return Path(path)

    path = Path("./z3")
    if path.exists():
        return path

    raise Exception("z3 not found")

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

def parseArgs():
    parser = argparse.ArgumentParser()
    parser.add_argument("--file", type=str, help="input file to run", required=True)
    parser.add_argument("--num-jobs", type=int, help="number of parallel jobs", default=multiprocessing.cpu_count())
    parser.add_argument("--run-cutoff", type=int, help="number of passes or failures needed to cut the jobs off", default=100)
    parser.add_argument("--time-cutoff", type=int, help="time after which to cut off a job", default=300)
    parser.add_argument("--vercors", action="store_true", help="Verify with VerCors")
    parser.add_argument("--silicon", action="store_true", help="Verify with Silicon")
    parser.add_argument("--args", type=str, help="Default arguments to append after automatically detected solver executable. Works only without --cmd", default="")
    parser.add_argument("--cmd", type=str, help="Overrides solver command to execute, not including filename. Disables --args", default="")
    args = parser.parse_args()

    if args.vercors == args.silicon:
        raise Exception("Must specify _one_ of --vercors, --silicon")

    if args.args != "" and args.cmd != "":
        raise Exception("Cannot specify both --args and --cmd")

    return args

def getSolver(args):
    if args.vercors:
        return Solver.VERCORS
    elif args.silicon:
        return Solver.SILICON
    else:
        raise Exception("Unknown solver set")

def constructSolverCommand(args):
    if args.cmd != "":
        return args.cmd

    if args.vercors:
        cmd = [str(findVerCors()), args.args]
    elif args.silicon:
        cmd = [str(findSilicon())]

        if not ("--z3Exe" in args.args):
            cmd += ["--z3Exe", findZ3()]

        cmd += [args.args]
    else:
        raise Exception("Unknown solver set")

    return cmd + [args.file]

if __name__ == "__main__":
    args = parseArgs()

    solver = getSolver(args)
    processArgs = constructSolverCommand(args)

    print(f"""Checking {args.file} for instability with {args.num_jobs} jobs.
Search is cut off at {args.run_cutoff} passes or fails.
Jobs will be cut off after {args.time_cutoff}s.
Solver: {solver}
Process command: {" ".join(processArgs)}
""")

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
                result = getResult(solver, pp)
                if result == Result.PASS:
                    print("One passed! Output of process:")
                    print(pp.stdout)
                    numPasses += 1
                elif result == Result.ERROR:
                    print("One error! Output of process:")
                    print(pp.stdout)
                    sys.exit(1)
                elif result == Result.FAIL:
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
            print(f"-- Passes: {numPasses}, fails: {numFails}, time-outs: {numTimeOuts} (cutoff at {args.run_cutoff}) --")
            print(f"-- Overview durations {datetime.datetime.now()} --")
            lastOverview = time.time()

            for (i, pp) in enumerate(pps):
                print(f"pps[{i}]: {pp.getDuration()}s")
            print()

    print(f"Encountered {numPasses} passes, {numFails} fails, and {numTimeOuts} time-outs")
    print(f"Search took {round(time.time() - startTime)}s")

    subprocess.run(["notify-send", "manyRun.py finished"])
