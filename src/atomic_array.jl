using Base.Threads
import Lazy: @forward

struct AtomicArray{T,N} <: AbstractArray{T,N}
    v::Array{T,N}
    s::Array{SpinLock,N}
    AtomicArray(v::Array{T,N}) where {T,N} = new{T,N}(v, [SpinLock() for x in v]) 
end

const AtomicVector{T} = AtomicArray{T,1}
const AtomicMatrix{T} = AtomicArray{T,2}

AtomicVector(v::Vector) = AtomicArray(v)
AtomicMatrix(v::Matrix) = AtomicArray(v)


function Base.convert(::Type{AtomicArray{T,N}}, v::Array{T,N}) where {T,N} 
    AtomicArray(v)
end

@forward AtomicArray.v Base.length, Base.iterate, Base.size, Base.axes, 
    Base.eachindex, Base.firstindex, Base.lastindex, Base.pairs

Base.eachindex(A::AtomicArray) = eachindex(A.v)
Base.eachindex(s::IndexStyle, A::AtomicArray) = eachindex(s, A.v)

function Base.getindex(a::AtomicArray, i...)
    @boundscheck checkbounds(a, i...)
    @inbounds lock(a.s[i...])
    @inbounds x = a.v[i...]
    @inbounds unlock(a.s[i...])
    x
end

function Base.setindex!(a::AtomicArray, x, i...)
    @boundscheck checkbounds(a, i...)
    @inbounds lock(a.s[i...])
    @inbounds a.v[i...] = x
    @inbounds unlock(a.s[i...])
    x
end
