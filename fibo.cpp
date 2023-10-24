#include <iostream>
#include <chrono>

using namespace std;

// Nth fibonacci term to be computed
int N = 40;

int recursiveFibo(int n)
{
    if (n < 1)
    {
        return 0;
    }
    else if (n == 1)
    {
        return 1;
    }
    else
    {
        return recursiveFibo(n - 1) + recursiveFibo(n - 2);
    }
}

int dynamicFibo(int n)
{
    int fibo[n + 1];
    fibo[0] = 0;
    fibo[1] = 1;
    for (int i = 2; i <= n; i++)
    {
        fibo[i] = fibo[i - 1] + fibo[i - 2];
    }
    return fibo[n];
}

int main(int argc, char const *argv[])
{
    auto start_recursive = chrono::high_resolution_clock::now();
    cout << "Recursive: " << recursiveFibo(N) << "  ";
    auto end_recursive = chrono::high_resolution_clock::now();
    auto duration_recursive = chrono::duration_cast<chrono::microseconds>(end_recursive - start_recursive);
    cout << "Time taken: " << duration_recursive.count() << " microseconds" << endl;

    auto start_dynamic = chrono::high_resolution_clock::now();
    cout << "Dynamic  : " << dynamicFibo(N) << "  ";
    auto end_dynamic = chrono::high_resolution_clock::now();
    auto duration_dynamic = chrono::duration_cast<chrono::microseconds>(end_dynamic - start_dynamic);
    cout << "Time taken: " << duration_dynamic.count() << " microseconds" << endl;

    return 0;
}
