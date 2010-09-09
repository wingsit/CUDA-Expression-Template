main:
	nvcc -O3 main_thrust_et.cu -I/usr/local/cuda/include/ -o main_thrust_et
#	g++ -O3 main_c.cpp -o main_c
#	g++ -O3 main_cpp_naive.cpp -o main_cpp_naive	
#	g++ -O3 main_cpp_et.cpp -o main_cpp_et
#	nvcc -O3 main_cuda.cu -o main_cuda
#	nvcc -O3 main_thrust.cu -I/usr/local/cuda/include/ -o main_thrust

time:
	time ./main_c
	time ./main_cpp_naive
	time ./main_cpp_et
	time ./main_cuda
	time ./main_thrust