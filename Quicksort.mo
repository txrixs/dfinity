import Array "mo:base/Array";
import Order "mo:base/Order";
import Int "mo:base/Int";

module Quicksort {

  type Order = Order.Order;

  public func sortBy<X>(arr : [X], f : (X, X) -> Order) : [X] {
    let n = arr.size();
    if (n < 2) {
      return arr;
    } else {
      let result = Array.thaw<X>(arr);
      sortByHelper<X>(result, 0, n - 1, f);
      return Array.freeze<X>(result);
    };
  };

  private func sortByHelper<X>(
    arr : [var X],
    l : Int,
    r : Int,
    f : (X, X) -> Order,
  ) {
    if (l < r) {
      var i = l;
      var j = r;
      var swap  = arr[0];
      let pivot = arr[Int.abs(l + r) / 2];
      while (i <= j) {
        while (Order.isLess(f(arr[Int.abs(i)], pivot))) {
          i += 1;
        };
        while (Order.isGreater(f(arr[Int.abs(j)], pivot))) {
          j -= 1;
        };
        if (i <= j) {
          swap := arr[Int.abs(i)];
          arr[Int.abs(i)] := arr[Int.abs(j)];
          arr[Int.abs(j)] := swap;
          i += 1;
          j -= 1;
        };
      };
      if (l < j) {
        sortByHelper<X>(arr, l, j, f);
      };
      if (i < r) {
        sortByHelper<X>(arr, i, r, f);
      };
    };
  };
};
