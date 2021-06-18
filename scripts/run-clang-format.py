#!/usr/bin/env python
#
#===- run-clang-format.py - Parallel clang-format runner -----*- python -*--===#
#
# Based on run-clang-tidy.py, which is part of the LLVM Project, under the
# Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#
#===------------------------------------------------------------------------===#

import argparse
import json
import multiprocessing
import os
import subprocess
import sys
import threading

is_py2 = sys.version[0] == '2'

if is_py2:
    import Queue as queue
else:
    import queue as queue

def find_compilation_database(path):
  """Adjusts the directory until a compilation database is found."""
  result = './'
  while not os.path.isfile(os.path.join(result, path)):
    if os.path.realpath(result) == '/':
      print('Error: could not find compilation database.')
      sys.exit(1)
    result += '../'
  return os.path.realpath(result)


def make_absolute(f, directory):
  if os.path.isabs(f):
    return f
  return os.path.normpath(os.path.join(directory, f))


def get_format_invocation(f, clang_format_binary, fix, warnings_as_errors, quiet):
  """Gets a command line for clang-format."""
  start = [clang_format_binary]
  if fix:
    start.append('-i')
  else:
    start.append('--dry-run')
  if warnings_as_errors:
    start.append('--Werror')
  start.append(f)
  return start


def run_format(args, build_path, queue, lock, failed_files):
  """Takes filenames out of queue and runs clang-format on them."""
  while True:
    name = queue.get()
    invocation = get_format_invocation(name, args.clang_format_binary, args.fix,
                                       args.warnings_as_errors, args.quiet)

    proc = subprocess.Popen(invocation, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output, err = proc.communicate()
    if proc.returncode != 0:
      failed_files.append(name)
    with lock:
      sys.stdout.write(' '.join(invocation) + '\n' + output.decode('utf-8'))
      if len(err) > 0:
        sys.stdout.flush()
        sys.stderr.write(err.decode('utf-8'))
    queue.task_done()


def main():
  parser = argparse.ArgumentParser(description='Runs clang-format over all files '
                                   'in a compilation database. Requires '
                                   'clang-format in $PATH.')
  parser.add_argument('-clang-format-binary', metavar='PATH',
                      default='clang-format',
                      help='path to clang-format binary')
  parser.add_argument('-p', dest='build_path',
                      help='Path used to read a compile command database.')
  parser.add_argument('-j', type=int, default=0,
                      help='number of tidy instances to be run in parallel.')
  parser.add_argument('-fix', action='store_true', help='reformat files')
  parser.add_argument('-exclude-dirs', nargs='*', default=[],
                      help='Directories to exclude from analysis.')
  parser.add_argument('-warnings-as-errors', action='store_true',
                      help='Let the clang-tidy process return != 0 if a check failed.')
  parser.add_argument('-quiet', action='store_true',
                      help='Run clang-format in quiet mode')
  args = parser.parse_args()

  db_path = 'compile_commands.json'

  if args.build_path is not None:
    build_path = args.build_path
  else:
    # Find our database
    build_path = find_compilation_database(db_path)

  try:
    with open(os.devnull, 'w') as dev_null:
      subprocess.check_call([args.clang_format_binary, '--dump-config'], stdout=dev_null)
  except:
    print("Unable to run clang-format.", file=sys.stderr)
    sys.exit(1)

   # Load the database and extract all files.
  database = json.load(open(os.path.join(build_path, db_path)))
  files = [make_absolute(entry['file'], entry['directory'])
           for entry in database]

  #files = ['/home/zuhlke/DeviceFW/src/style_test.cpp']

  max_task = args.j
  if max_task == 0:
    max_task = multiprocessing.cpu_count()

  return_code = 0
  try:
    # Spin up a bunch of format-launching threads.
    task_queue = queue.Queue(max_task)
    # List of files with a non-zero return code.
    failed_files = []
    lock = threading.Lock()
    for _ in range(max_task):
      t = threading.Thread(target=run_format,
                           args=(args, build_path, task_queue, lock, failed_files))
      t.daemon = True
      t.start()

    # Fill the queue with files.
    for name in files:
      if not name.startswith(tuple(args.exclude_dirs)):
        task_queue.put(name)

    # Wait for all threads to be done.
    task_queue.join()
    if len(failed_files):
      return_code = 1

  except KeyboardInterrupt:
    # This is a sad hack. Unfortunately subprocess goes
    # bonkers with ctrl-c and we start forking merrily.
    print('\nCtrl-C detected, goodbye.')
    if tmpdir:
      shutil.rmtree(tmpdir)
    os.kill(0, 9)

  sys.exit(return_code)


if __name__ == '__main__':
  main()
