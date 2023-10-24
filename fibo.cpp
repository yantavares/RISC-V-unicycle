#include <bits/stdc++.h>

using namespace std;

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
    cout << "Recursive: " << recursiveFibo(4) << "  Dynamic: " << dynamicFibo(4) << endl;
    return 0;
}
