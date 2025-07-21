tail -n0 -F /APP/logs/trace.log \
  | grep --line-buffered 'MYAPP R\[PRO\]' \
  | awk '
      BEGIN {
        interval = 1           # seconds between reports
        last = systime()
        count = 0
      }
      {
        count++
      }
      (systime() - last >= interval) {
        ts = strftime("%Y-%m-%d %H:%M:%S", last)
        print ts, count
        count = 0
        last = systime()
      }
    '
