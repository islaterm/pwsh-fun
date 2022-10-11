class TimeUnit {
  [string]$Name
  [int]$Value
  TimeUnit([string]$Name, [int]$Value) {
    $this.Name = $Name
    $this.Value = $Value
  }
}

class Nanosecond : TimeUnit {
  Nanosecond([int]$Value) : base('Nanosecond', $Value) {}

  [string]toString() {
    return "$($this.Value)ns"
  }
}