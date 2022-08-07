package main

import "fmt"

func main() {
  var meter float32
  fmt.Println("How many meters do you need to convert?")
  fmt.Scanf("%f", &meter)
  foot := meter / 0.3048
  fmt.Println("This is equivalent to", foot, "feet")
}
