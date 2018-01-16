#!/bin/sh
#\
exec tclsh "$0" ${1+"$@"}

proc extract {a b} {
  set ::aR [lindex $a 0]
  if {[llength $a]>1} {
    set ::aEpsilon [lindex $a 1]
  } else {
    set ::aEpsilon 0
  }
  set ::bR [lindex $b 0]
  if {[llength $b]>1} {
    set ::bEpsilon [lindex $b 1]
  } else {
    set ::bEpsilon 0
  }
}
proc + {a b} {
  extract $a $b
  return "[expr {$::aR+$::bR}] [expr {$::aEpsilon+$::bEpsilon}]"
}
proc - {a b} {
  extract $a $b
  return "[expr {$::aR-$::bR}] [expr {$::aEpsilon-$::bEpsilon}]"
}
proc * {a b} {
  extract $a $b
  return "[expr {$::aR*$::bR}] [expr {$::bR*$::aEpsilon+$::aR*$::bEpsilon}]"
}
proc / {a b} {
  extract $a $b
  return "[expr {$::aR*$::bR}] [expr {($::bR*$::aEpsilon-$::aR*$::bEpsilon)/($aR*$aR)}]"
}
if {$argc>0} {
  set min [lindex $argv 0]
  set max [lindex $argv 1]
  set increment [lindex $argv 2]
  set fx [lindex $argv 3]
} else {
  fconfigure stdout -buffering none
  puts -nonewline "Min: "
  set min [gets stdin]
  puts -nonewline "Max: "
  set max [gets stdin]
  puts -nonewline "Increnment: "
  set increment [gets stdin]
  puts -nonewline "f(x): "
  set fx [gets stdin]
}
for {set a $min} {$a<=$max} {set a [expr {$a+$increment}]} {
  puts "$a [expr [string map "x {{$a 1}}" $fx]]"
}
