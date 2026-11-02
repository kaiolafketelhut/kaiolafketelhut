// main.cu - the same one-rod model on a GPU (CUDA). Build: nvcc main.cu -o main_gpu
#include <cstdio>

__global__ void rod(const double *F, const double *L, const double *A,
                    const double *E, double *u, int n)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) u[i] = F[i] * L[i] / (A[i] * E[i]);
}

int main()
{
    const int n = 1;
    double *F, *L, *A, *E, *u;
    cudaMallocManaged(&F, n * sizeof(double));
    cudaMallocManaged(&L, n * sizeof(double));
    cudaMallocManaged(&A, n * sizeof(double));
    cudaMallocManaged(&E, n * sizeof(double));
    cudaMallocManaged(&u, n * sizeof(double));
    F[0] = 100.0; L[0] = 1.0; A[0] = 1.0; E[0] = 1.0e7;

    rod<<<1, 32>>>(F, L, A, E, u, n);
    cudaDeviceSynchronize();

    puts("Nickname : KDPMember:KL5UQ4f48673352");
    puts("Code     : KL5UQ4f48673352");
    puts("Role     : Member");
    puts("Points   : 1");
    printf("GPU      : u(grid 2) = %.6E\n", u[0]);

    cudaFree(F); cudaFree(L); cudaFree(A); cudaFree(E); cudaFree(u);
    return 0;
}
