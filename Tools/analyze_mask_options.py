#!/usr/bin/env python3
"""Exact 8-bit mask feasibility and independently constructed witnesses.

No solver dependency. Lists mean unordered sets of distinct masks. Hamming
distance is popcount(a XOR b). No production or archived mask-bank source is read.
"""
import argparse
import itertools
import json
import math
from pathlib import Path


def weight(value):
    return bin(value).count("1")


def valid(masks, distance, weights):
    return (len(masks) == len(set(masks))
            and all(weight(m) in weights for m in masks)
            and all(weight(a ^ b) >= distance for a, b in itertools.combinations(masks, 2)))


def witness(candidates, count, distance, chosen=()):
    if len(chosen) == count:
        return list(chosen)
    while len(candidates) >= count - len(chosen):
        first, candidates = candidates[0], candidates[1:]
        result = witness([m for m in candidates if weight(m ^ first) >= distance],
                         count, distance, chosen + (first,))
        if result is not None:
            return result
    return None


def encoded(masks):
    return [f"0x{m:02X}" for m in sorted(masks)]


def analyze():
    triples = [m for m in range(256) if weight(m) == 3]
    # Equal weight implies even distance. At distance >=4 two triples share
    # at most one position. A fixed position belongs to at most floor(7/2)=3
    # triples (their other two positions cannot repeat). Count incidences:
    # 3 * number_of_masks <= 8 * 3, hence at most eight masks.
    upper = 8 * (7 // 2) // 3
    eight = witness(triples, upper, 3)
    assert eight is not None and valid(eight, 3, {3})

    # The 14 nonconstant affine Boolean functions on three input bits.
    # Each truth table is balanced; two distinct tables differ in four or
    # eight positions. Construct the witness without a stored mask bank.
    fourteen = sorted(sum(((weight(point & linear) ^ constant) & 1) << point
                          for point in range(8))
                      for linear in range(1, 8) for constant in range(2))
    assert len(fourteen) == 14 and valid(fourteen, 4, {4})
    # Extended Hamming code: zero, the 14 balanced words, and all-one.
    # Translate every word by a two-one vector. Distance stays unchanged.
    # Choose a translation producing only weights 2, 4 and 6 (no 0/8).
    sixteen = sorted(m ^ 0x03 for m in [0, 255] + fourteen)
    assert len(sixteen) == 16 and valid(sixteen, 4, {2, 4, 6})
    return {
        "definition": "unordered sets of distinct 8-bit masks; Hamming distance = popcount(a XOR b)",
        "three_ones_distance_at_least_three": {
            "candidate_masks": len(triples), "maximum_list_length": upper,
            "proof": "Equal weights give even distances. Each position can occur in at most 3 masks; 3*M <= 8*3.",
            "maximum_witness": encoded(eight),
            "list_counts": {str(n): 0 for n in range(15, 20)},
        },
        "balanced_construction": {
            "list_length": 14, "ones": 4, "minimum_distance": 4,
            "method": "Nonconstant affine functions on three input bits",
            "example_14": encoded(fourteen),
        },
        "alternatives": {
            "four_ones_distance_four": {"maximum_length": 14,
                "proof": "Each position occurs in at most 7 masks, so 4*M <= 8*7."},
            "mixed_two_four_six_ones_distance_four": {"maximum_length": 16,
                "witness": encoded(sixteen),
                "proof": "Puncture one position: a length-7 distance-3 code. Disjoint radius-1 balls give M*8 <= 128.",
                "tradeoff": "Changes mask density; selected/complement portions are no longer always equal."},
            "three_ones_distance_two": {"maximum_length": 56,
                "list_counts": {str(n): math.comb(56, n) for n in range(15, 20)},
                "tradeoff": "Permits pairs differing in only two bit positions."},
        },
    }


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    result = json.dumps(analyze(), indent=2) + "\n"
    if args.output:
        args.output.write_text(result)
    print(result, end="")
