#define N 1024
#define L 3 

#include<stdio.h>
#include<stdlib.h>
#include<time.h>

void initData(float x[N]);
void print(float x[N]);
__global__ void convolve(float *x, float *h, float *y, int fftL);

int main(){
	float x[N];
	float h[L] = {0,1,1};
	float y[N+L-1] = {0};

	float *dev_x, *dev_h, *dev_y;
	
	cudaMalloc((void **)&dev_x, N*sizeof(float));
	cudaMalloc((void **)&dev_h, L*sizeof(float));
	cudaMalloc((void **)&dev_y, (N+L-1)*sizeof(float));

	initData(x);

	cudaMemcpy(dev_x,&x,N*sizeof(float),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_h,&h,L*sizeof(float),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_y,&y,(N+L-1)*sizeof(float),cudaMemcpyHostToDevice);
	
	int fftL;

	/*
		decide fftL

   */

	dim3 dimGrid(N/fftL,1);
	dim3 dimBlock(fftL,1);

	convolve<<<dimGrid,dimBlock>>>(dev_x dev_h, dev_y,fftL);

	cudaError_t err = cudaGetLastError();
	if (err != cudaSuccess) 
		printf("Error: %s\n", cudaGetErrorString(err));
	
	cudaMemcoy(&y,dev_y,(N+L-1)*sizeof(float), cudaMemcpyDeviceToHost);

	cudaFree(dev_x);
	cudaFree(dev_y);
	cudaFree(dev_h);
	
	print(y);
	
	return 0;
}

void initData(float x[N]){
	int i;
	for(i=0;i<N;i++){
		x[i] = i;
	}
}

void print(float x[N]){
	int i;
	for(i=0;i<N;i++){
		printf("%.3f\t",x[i]);
	}

}

__global__ void convolve(float *x, float *h, float *y, int fftL){



}
