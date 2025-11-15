#ifndef HELPER_HPP
#define HELPER_HPP

#include <bits/stdc++.h>
#include <pthread.h>
#include <semaphore.h>
using namespace std;

#define TYPE_WRITING_STATIONS 4
#define INTELLIGENCE_STAFF 2
#define INTELLIGENCE_STUFF_WORKING_MULTIPLIER 500
#define OPERATIVE_ARRIVAL_MULTIPLIER 500
#define OPERATIVE_WORKING_MULTIPLIER 700
#define UNIT_LEADER_WORKING_MULTIPLIER 600
#define DEBUG 2

int N_OPERATIVES;
int M_UNIT_SIZE;
int x_time;
int y_time;
int num_of_groups;
double lambda = 10;

pthread_mutex_t reader_count_mutex;
pthread_mutex_t output_file_mutex;
sem_t station_sems[TYPE_WRITING_STATIONS];

vector<pthread_mutex_t> group_mutexes; // jotogula grp ase shbgular jnne
vector<sem_t> grp_sem_locks;
vector<int> grp_doc_recreation_counts; // grp r koejn r doc recre done..count++ r vul jate na hy

sem_t logbook_sem_lock;
int reader_count = 0;
int operations_completed = 0;
bool simulation_running = true;

struct Operative
{
    int id;
    int group_id;
    int station_id;
};

auto start_time = chrono::high_resolution_clock::now();

long long get_time()
{
    auto end_time = chrono::high_resolution_clock::now();
    auto duration = chrono::duration_cast<chrono::milliseconds>(end_time - start_time);
    return duration.count();
}

int get_random_number()
{
    random_device rd;
    mt19937 generator(rd());

    std::poisson_distribution<int> poissonDist(lambda);
    return min(1000, poissonDist(generator));
}

void printLog(string msg)
{
    pthread_mutex_lock(&output_file_mutex);
    cout << msg << endl;
    pthread_mutex_unlock(&output_file_mutex);
}

void print_Intelligence_Stuff_Logs(int staff_id, int completed_ops)
{
    pthread_mutex_lock(&output_file_mutex);
    cout << "Intelligence Staff " << staff_id << " began reviewing logbook at time "
         << get_time() << ". Operations completed = " << completed_ops << endl;
    pthread_mutex_unlock(&output_file_mutex);
}

#endif