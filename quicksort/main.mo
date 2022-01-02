import Int "mo:base/Int";
import Quicksort "Quicksort";

actor Main {

  public func qsort(arr : [Int]) : async [Int] {
    return Quicksort.sortBy(arr, Int.compare);
  };
};