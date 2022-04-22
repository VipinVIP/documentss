#include<stdio.h>
#include<stdlib.h>
#define MAX 20

// print 2D matrix 

void print_matrix(int mat[MAX][MAX], int n, int m)
{
    for (int i = 0;i < n;i++) {
        for (int j = 0;j < m;j++) {
            printf(" %d ", mat[i][j]);
        }
        printf("\n");
    }
    printf("\n");
}

void print_array(int arr[MAX], int m)
{
    for (int i = 0;i < m;i++)
        printf(" %d ", arr[i]);
    printf("\n");
}


void print_safety_seq(int n, int m, int need[MAX][MAX], int curr_availabe[MAX], int allocation[MAX][MAX])
{
    int process = n;

    // safety sequence path holder
    int ans[n];

    // flag array for checking request fullfill
    int req_fullfill[n];

    int index = 0;

    for (int i = 0;i < n;i++)
        req_fullfill[i] = 0;


    for (int k = 0;k < process;k++) {
        for (int i = 0;i < n;i++) {
            if (req_fullfill[i] == 0)
            {
                int flag = 1;

                for (int j = 0;j < m;j++) {
                    if (need[i][j] > curr_availabe[j])
                    {
                        flag = 0;
                        break;
                    }
                }
                if (flag == 1) {
                    ans[index] = i+1;
                    index++;
                    req_fullfill[i] = 1;
                    for (int j = 0;j < m;j++) {
                        curr_availabe[j] += allocation[i][j];
                    }
                }
            }
            // print_array(curr_availabe, m);

        }
    }

        // check for unsafe
    int flag = 1;
    for (int i = 0; i < n; i++)
    {
        if (req_fullfill[i] == 0) {
            flag = 0;
            break;
        }
    }

    if (flag == 0) {
        printf("System is in unsafe\n");
    }
    else if (flag == 1) {
        printf("The system is in safe state : \n");
        printf("--- safe seq ---\n");

        for (int i = 0; i < n-1; i++)
        {
            printf("p%d ->", ans[i]);
        }
        
        printf("p%d ", ans[n - 1]);

        printf("\n");

    }

    


}


void res_req(int n, int m, int need[MAX][MAX], int curr_availabe[MAX], int allocation[MAX][MAX]) {
    int p_num = 0;
    printf("Enter the process number : ");
    scanf("%d", &p_num);
    p_num -= 1;

    int add_res[MAX] = { 0 };
    printf("Enter the additional resources : ");
    for (int i = 0;i < m;i++)
        scanf("%d", &add_res[i]);

    for (int i = 0;i < m;i++) {
        if ((add_res[i] > need[p_num][i]) || (add_res[i] > curr_availabe[i]))
        {
            printf("process has exceeded its maximum claim.\n");
            return;
        }
    }

    print_array(need[p_num],m);
    print_array(allocation[p_num],m);

    for (int i = 0;i < m;i++) {
        curr_availabe[i] -= add_res[i];
        need[p_num][i] -= add_res[i];
        allocation[p_num][i] += add_res[i];
    }


    printf("--- new allocation matrix ---\n");
    print_matrix(allocation, n, m);

    printf("--- need matrix ---\n");
    print_matrix(need, n, m);

    printf("--- currently resources ---\n");
    print_array(curr_availabe, m);

    print_safety_seq(n, m, need, curr_availabe, allocation);

}

int main()
{
    int n; // number of process
    int m; //number of resource types

    printf("Enter the number of process available : ");
    scanf("%d", &n);

    printf("Enter the number of resource types available : ");
    scanf("%d", &m);

    // total availabe resoucres
    int total_available[MAX];

    // the resources in which possesd 
    int possessed[MAX] = { 0 };

    printf("Enter the instances of different resources : ");
    for (int i = 0;i < m;i++)
        scanf("%d", &total_available[i]);

    // allocation matrix
    int allocation[MAX][MAX];

    printf("Enter the elements in the allocation matrix : ");
    for (int i = 0;i < n;i++) {
        for (int j = 0;j < m;j++) {
            scanf("%d", &allocation[i][j]);
            possessed[j] = possessed[j] + allocation[i][j];
        }
    }

    printf("Enter the elements in the max matrix : \n");

    // max matrix
    int max[MAX][MAX];
    
    for (int i = 0;i < n;i++) {
        for (int j = 0; j < m; j++)
        {
            scanf("%d", &max[i][j]);
        }

    }

    // need matrix
    int need[MAX][MAX];

    // calculating the need matrix 
    for (int i = 0;i < n;i++) {
        for (int j = 0;j < m;j++) {
            need[i][j] = max[i][j] - allocation[i][j];
        }
    }

    // currently availabe resource instances
    int curr_availabe[MAX];

    for (int i = 0;i < m;i++)
        curr_availabe[i] = total_available[i] - possessed[i];

    printf("--- max matrix ---\n");
    print_matrix(max, n, m);

    printf("--- allocation matrix ---\n");
    print_matrix(allocation, n, m);

    printf("--- need matrix ---\n");
    print_matrix(need, n, m);

    printf("--- total resources ---\n");
    print_array(total_available, m);

    printf("--- possessed resources ---\n");
    print_array(possessed, m);

    printf("--- currently resources ---\n");
    print_array(curr_availabe, m);

    printf("\n");


    // print_safety_seq(n, m, need, curr_availabe, allocation);
    res_req(n, m, need, curr_availabe, allocation);





}
