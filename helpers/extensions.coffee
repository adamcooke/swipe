Number.prototype.minsToDHMS = ->
  Math.round(this * 60).secsToDHMS()

Number.prototype.secsToDHMS = ->
  n = Math.abs this
  [seconds, n] = [n % 60, Math.floor n / 60]
  [minutes, n] = [n % 60, Math.floor n / 60]
  [hours, n]  = [n % 24, Math.floor n / 24]
  days = n
  s = []
  s.push "#{days}d" if days
  s.push "#{hours}h" if hours
  s.push "#{minutes}m" if minutes
  s.push "#{seconds}s" if seconds
  s = s.join " "
  if this < 0 then "-#{s}" else s
