# AtomicVector

This minimal package implements an atomic read-write array wrapping a standard `Array`. The only guarantee is that assignment with
`a[i] = v` is made atomically, i.e. without interference by reads of `a[i]` from other threads; that is, it is not possible to read a value while it is being written by another thread. Note that if `eltype(a)` is mutable, then there is no protection against *modifying* `a[i]` while it is being read.  

[![Build Status](https://github.com/abraunst/AtomicArrays.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/abraunst/AtomicArrays.jl/actions/workflows/CI.yml?query=branch%3Amain)
