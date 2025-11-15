#include <bits/stdc++.h>
#include <pthread.h>
#include <semaphore.h>
#include "helper.h"
using namespace std;

void *operative_Operation_Cycle(void *arg)
{
    Operative *operative = (Operative *)arg;
    usleep(get_random_number() * OPERATIVE_ARRIVAL_MULTIPLIER);

    printLog("Operative " + to_string(operative->id) + " has arrived at typewriting station " +
             to_string(operative->station_id) + " at time " + to_string(get_time()));

    int station_index = operative->station_id - 1;

    // Try to access station immediately
    if (sem_trywait(&station_sems[station_index]) != 0)
    {
        if (DEBUG == 2)
            printLog("!! Operative " + to_string(operative->id) +
                     " is waiting for station " + to_string(operative->station_id) +
                     " at time " + to_string(get_time()) + " !!");

        sem_wait(&station_sems[station_index]); // now actually wait

        if (DEBUG == 2)
            printLog("** Operative " + to_string(operative->id) +
                     " received signal to use station " + to_string(operative->station_id) +
                     " at time " + to_string(get_time()) + " **");
    }
    else
    {
        if (DEBUG == 2)
            printLog("## Operative " + to_string(operative->id) +
                     " directly accessed free station " + to_string(operative->station_id) +
                     " at time " + to_string(get_time()) + " ##");
    }

    // Document recreation
    printLog("Operative " + to_string(operative->id) + " started document recreation using station " +
             to_string(operative->station_id) + " at time " + to_string(get_time()));

    usleep(x_time * OPERATIVE_WORKING_MULTIPLIER);

    printLog("Operative " + to_string(operative->id) + " has completed document recreation at time " +
             to_string(get_time()));

    if (DEBUG == 1 || DEBUG == 2)
        printLog("______ Operative " + to_string(operative->id) +
                 " is broadcasting availability of station " + to_string(operative->station_id) +
                 " at time " + to_string(get_time()) + " ______");

    sem_post(&station_sems[station_index]); // unlock station

    // Group recr count update nd check
    int group_idx = operative->group_id - 1;

    pthread_mutex_lock(&group_mutexes[group_idx]);
    grp_doc_recreation_counts[group_idx]++;
    int finished_operatives_count = grp_doc_recreation_counts[group_idx];
    pthread_mutex_unlock(&group_mutexes[group_idx]);

    if (finished_operatives_count == M_UNIT_SIZE)
    {
        printLog("Unit " + to_string(operative->group_id) +
                 " has completed document recreation phase at time " + to_string(get_time()));
        for (int i = 0; i < M_UNIT_SIZE - 1; i++)
        {
            sem_post(&grp_sem_locks[group_idx]); // wake up teammates
        }
    }
    else
    {
        sem_wait(&grp_sem_locks[group_idx]); // wait for leader's signal
    }

    // Logbook Entry --->
    bool is_leader = (operative->id % M_UNIT_SIZE == 0 || operative->id == N_OPERATIVES);
    if (M_UNIT_SIZE == 1)
        is_leader = true;

    if (is_leader)
    {
        sem_wait(&logbook_sem_lock);
        // reader dhore na rakhle ek matro aquire krte parbe

        usleep(y_time * UNIT_LEADER_WORKING_MULTIPLIER);
        operations_completed++;

        printLog("Unit " + to_string(operative->group_id) +
                 " has completed intelligence distribution at time " + to_string(get_time()));

        sem_post(&logbook_sem_lock);
    }

    delete operative;
    return nullptr;
}

void *intelligence_staff_lifecycle(void *arg)
{
    int staff_id = *(int *)arg;
    delete (int *)arg;

    while (simulation_running)
    {
        // cout <<  "get ran num " << get_random_number() << endl;
        usleep(get_random_number() * INTELLIGENCE_STUFF_WORKING_MULTIPLIER);

        pthread_mutex_lock(&reader_count_mutex);
        reader_count++;
        if (reader_count == 1)
            sem_wait(&logbook_sem_lock);
        pthread_mutex_unlock(&reader_count_mutex); // count done

        print_Intelligence_Stuff_Logs(staff_id, operations_completed);

        usleep(get_random_number() * INTELLIGENCE_STUFF_WORKING_MULTIPLIER);

        pthread_mutex_lock(&reader_count_mutex);
        reader_count--;
        if (reader_count == 0)
            sem_post(&logbook_sem_lock); // first reader lock krlo , last reader unlock krlo
        pthread_mutex_unlock(&reader_count_mutex);
    }

    return nullptr;
}

void initialize()
{

    pthread_mutex_init(&output_file_mutex, nullptr);
    pthread_mutex_init(&reader_count_mutex, nullptr);
    sem_init(&logbook_sem_lock, 0, 1);

    for (int i = 0; i < TYPE_WRITING_STATIONS; i++)
        sem_init(&station_sems[i], 0, 1);

    group_mutexes.resize(num_of_groups);
    grp_sem_locks.resize(num_of_groups);
    grp_doc_recreation_counts.assign(num_of_groups, 0);

    for (int i = 0; i < num_of_groups; i++)
    {
        pthread_mutex_init(&group_mutexes[i], nullptr);
        sem_init(&grp_sem_locks[i], 0, 0);
    }
}

void destroy()
{
    pthread_mutex_destroy(&output_file_mutex);
    pthread_mutex_destroy(&reader_count_mutex);
    sem_destroy(&logbook_sem_lock);

    for (int i = 0; i < TYPE_WRITING_STATIONS; i++)
        sem_destroy(&station_sems[i]);

    for (int i = 0; i < num_of_groups; i++)
    {
        pthread_mutex_destroy(&group_mutexes[i]);
        sem_destroy(&grp_sem_locks[i]);
    }
}

int main(int argc, char *argv[])
{
    if (argc != 3)
    {
        cerr << "Usage: " << argv[0] << " <in.txt> <out.txt>" << endl;
        return 1;
    }

    ifstream inputFile(argv[1]);
    ofstream outputFile(argv[2]);
    streambuf *cin_buf = cin.rdbuf();
    streambuf *cout_buf = cout.rdbuf();
    cin.rdbuf(inputFile.rdbuf());
    cout.rdbuf(outputFile.rdbuf());

    cin >> N_OPERATIVES >> M_UNIT_SIZE >> x_time >> y_time;

    if (N_OPERATIVES % M_UNIT_SIZE != 0)
    {
        cout << "N = cM condition not fulfilled. Exiting." << endl;
        return 1;
    }

    start_time = chrono::high_resolution_clock::now();

    // crreating
    num_of_groups = N_OPERATIVES / M_UNIT_SIZE;
    vector<pthread_t> operative_threads(N_OPERATIVES);
    pthread_t staff_threads[INTELLIGENCE_STAFF];

    initialize();

    for (int i = 0; i < INTELLIGENCE_STAFF; i++)
    {
        int *id = new int(i + 1);
        pthread_create(&staff_threads[i], nullptr, intelligence_staff_lifecycle, id); // last arg ta ptr chae pthread ejnne
    }

    for (int i = 0; i < N_OPERATIVES; i++)
    {
        Operative *op = new Operative();
        op->id = i + 1;
        op->group_id = i / M_UNIT_SIZE + 1;
        op->station_id = (op->id - 1) % TYPE_WRITING_STATIONS + 1;
        pthread_create(&operative_threads[i], nullptr, operative_Operation_Cycle, op);
    }

    // joining

    for (int i = 0; i < N_OPERATIVES; i++)
    {
        pthread_join(operative_threads[i], nullptr);
        // basically ekhane call korbe and will wait for them to finish ie return krbe from that function
    }

    simulation_running = false;

    for (int i = 0; i < INTELLIGENCE_STAFF; i++)
    {
        pthread_join(staff_threads[i], nullptr);
    }

    // destroy
    destroy();

    cin.rdbuf(cin_buf);
    cout.rdbuf(cout_buf);
    inputFile.close();
    outputFile.close();

    return 0;
}
