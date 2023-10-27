using AtomicArrays, Test

@testset "AtomicArrays" begin
    X = rand(5)
    Y = AtomicVector(X)
    @test X == Y
end
