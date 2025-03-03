#include <bits/stdc++.h>
using namespace std;

// Original classes remain the same
class Farm {
public:
    int id;
    string crop;
    double perish_rate;
    double quantity;
    Farm(int id, string crop, double perish_rate, double quantity) {
        this->id = id;
        this->crop = crop;
        this->perish_rate = perish_rate;
        this->quantity = quantity;
    }
};

class Hub {
public:
    int id;
    double cost, capacity;
    Hub(int id, double cost, double capacity) {
        this->id = id;
        this->cost = cost;
        this->capacity = capacity;
    }
};

class Center {
public:
    int id;
    string crop;
    double demand, rate, deadline;
    Center(int id, string crop, double demand, double rate, double deadline) {
        this->id = id;
        this->crop = crop;
        this->demand = demand;
        this->rate = rate;
        this->deadline = deadline;
    }
    Center() {};
};

class Vehicle {
public:
    int type;
    double rent;
    double capacity;
    double speed;
    Vehicle(int type, double rent, double capacity, double speed) {
        this->type = type;
        this->rent = rent;
        this->capacity = capacity;
        this->speed = speed;
    }
};

class Result {
public:
    double total_cost, profit, spoil;
    vector<int> path;
    int center, hub;
    Result(int center, double total_cost, double profit, double spoil, vector<int>& path, int hub) {
        this->center = center;
        this->total_cost = total_cost;
        this->profit = profit;
        this->spoil = spoil;
        this->path = path;
        this->hub = hub;
    }
};

// Helper function to generate network structure
vector<vector<pair<int, double>>> generateNetwork(int totalNodes, 
                                                const vector<int>& farmNodes,
                                                const vector<int>& hubNodes,
                                                const vector<int>& centerNodes) {
    vector<vector<pair<int, double>>> g(totalNodes + 1);
    
    // Create connections between farms and hubs
    for(int farm : farmNodes) {
        for(int hub : hubNodes) {
            // Generate realistic distance between 5 to 50 km
            double distance = 5 + (rand() % 46);
            g[farm].push_back({hub, distance});
            g[hub].push_back({farm, distance});
        }
    }
    
    // Create connections between hubs
    for(int i = 0; i < hubNodes.size(); i++) {
        for(int j = i + 1; j < hubNodes.size(); j++) {
            double distance = 10 + (rand() % 41);  // 10-50 km between hubs
            g[hubNodes[i]].push_back({hubNodes[j], distance});
            g[hubNodes[j]].push_back({hubNodes[i], distance});
        }
    }
    
    // Create connections between hubs and centers
    for(int hub : hubNodes) {
        for(int center : centerNodes) {
            double distance = 15 + (rand() % 36);  // 15-50 km
            g[hub].push_back({center, distance});
            g[center].push_back({hub, distance});
        }
    }
    
    return g;
}

// Helper function to generate traffic data
map<pair<int, int>, double> generateTraffic(const vector<vector<pair<int, double>>>& g) {
    map<pair<int, int>, double> tr;
    for(int i = 0; i < g.size(); i++) {
        for(auto [j, dist] : g[i]) {
            tr[{i, j}] = 0.0;  // Hardcoded to 0 as per requirement
            tr[{j, i}] = 0.0;
        }
    }
    return tr;
}

// Helper function to generate hub data
vector<Hub> generateHubs(const vector<int>& hubNodes) {
    vector<Hub> hubs;
    for(int id : hubNodes) {
        double capacity = 1000 + (rand() % 10001);  // 1000-10000 kg capacity
        double cost = 200 + (rand() % 301);          // Rs. 200-500 per unit storage cost
        hubs.emplace_back(id, cost, capacity);
    }
    return hubs;
}

// Comparison function for results
bool cmp(Result& a, Result& b) {
    if(a.profit == b.profit) {
        return a.spoil < b.spoil;
    }
    return a.profit > b.profit;
}

// Original pathfinding function given source and destination
pair<double, double> findMinCostAndTime(vector<vector<pair<int, double>>>& g, int src, int dest, vector<int>& path, map<pair<int, int>, double>& tr, double rent, double speed, double rate, double weight, double perish_rate) 
{
    priority_queue<pair<pair<double, double>, int>, vector<pair<pair<double, double>, int>>, greater<>> pq;
    vector<double> cost(g.size(), 1e18);
    vector<double> timeTaken(g.size(), 1e18);
    vector<int> parent(g.size(), -1);

    cost[src] = 0;
    timeTaken[src] = 0;
    pq.push({{0, 0}, src});

    while (!pq.empty())
    {
        auto [d_t, u] = pq.top();
        auto [d, t] = d_t;
        pq.pop();
        if (d > cost[u])
            continue;

        for (auto [v, w] : g[u])
        {
            double t = tr[{u, v}];
            if (t >= 0.99)
            {
                continue;
            }
        
            double nw = w * rent + w / speed * 1 / (1 - t) * rate * weight * perish_rate;
            if (cost[u] + nw < cost[v])
            {
                cost[v] = cost[u] + nw;
                timeTaken[v] = timeTaken[u] + w / speed * (1 - t);
                parent[v] = u;
                pq.push({{cost[v], timeTaken[v]}, v});
            }
        }
    }

    if (cost[dest] >= 1e18)
        return {1e18, 1e18};

    int current = dest;
    path.clear();
    while (current != -1)
    {
        path.push_back(current);
        current = parent[current];
    }
    reverse(path.begin(), path.end());
    return {cost[dest], timeTaken[dest]};}

int main() {
    srand(time(0));
    
    // Network structure parameters
    const int TOTAL_NODES = 200;
    const int NUM_FARMS = 50;
    const int NUM_HUBS = 15;
    const int NUM_CENTERS = 10;
    
    // Generate node assignments
    vector<int> farmNodes, hubNodes, centerNodes;
    
    // Assign farm nodes (1-50)
    for(int i = 1; i <= NUM_FARMS; i++) {
        farmNodes.push_back(i);
    }
    
    // Assign hub nodes (51-65)
    for(int i = 51; i <= 51 + NUM_HUBS - 1; i++) {
        hubNodes.push_back(i);
    }
    
    // Assign center nodes (66-75)
    for(int i = 66; i <= 66 + NUM_CENTERS - 1; i++) {
        centerNodes.push_back(i);
    }
    
    // Generate network
    auto g = generateNetwork(TOTAL_NODES, farmNodes, hubNodes, centerNodes);
    auto tr = generateTraffic(g);
    
    // Generate hubs
    auto hubs = generateHubs(hubNodes);
    
    // These values would come from JSON in actual implementation
    // Example JSON structure:
    /*
    {
        "vehicles": [
            {"id": 1, "rent": 5.0, "capacity": 5000, "speed": 30},
            {"id": 2, "rent": 8.0, "capacity": 8000, "speed": 25}
        ],
        "farms": [
            {"id": 1, "crop": "corn", "perish_rate": 0.0002, "quantity": 10000}
        ],
        "centers": [
            {"id": 66, "crop": "corn", "demand": 11000, "rate": 300, "deadline": 12},
            {"id": 67, "crop": "corn", "demand": 10000, "rate": 500, "deadline": 12}
        ]
    }
    */
    
    // Hardcoded vehicle data
    Vehicle v1(1, 5.0, 50, 30);  // Type 1: Medium capacity, higher speed
    Vehicle v2(2, 8.0, 80, 25);  // Type 2: Higher capacity, lower speed
    
    // Hardcoded farm data
    Farm farm(1, "corn", 0.0002, 100);  // Example farm with corn production
    
    // Hardcoded center data
    map<int, Center> centerMap;
    centerMap[66] = Center(66, "corn", 11000, 300, 120);
    centerMap[67] = Center(67, "corn", 10000, 500, 120);
    
    // Rest of the optimization logic remains the same
    vector<Result> resv1, resv2;
    
    // Process optimization for vehicle type 1
    for(const auto& hub : hubs) {
        if(v1.capacity > hub.capacity) continue;
        
        for(const auto& [id, center] : centerMap) {
            
            if(center.crop != farm.crop) {continue;}
               
            
            vector<int> path, path2;
            auto [cost1, time1] = findMinCostAndTime(g, hub.id, farm.id, path, tr, 
                                                   v1.rent, v1.speed, center.rate,
                                                   min(farm.quantity, v1.capacity),
                                                   farm.perish_rate);
                                                   
            auto [cost2, time2] = findMinCostAndTime(g, hub.id, id, path2, tr,
                                                   v1.rent, v1.speed, center.rate,
                                                   min(farm.quantity, v1.capacity),
                                                   farm.perish_rate);
           
            // Process path and calculate costs
            reverse(path.begin(), path.end());
            path.pop_back();
            path.insert(path.end(), path2.begin(), path2.end());
            
            int q = farm.quantity/v1.capacity;
            double rem = farm.quantity - q*v1.capacity;
            double ncost = cost1 + cost2 - (time1 + time2) * 
                          (min(farm.quantity, v1.capacity) - rem) *
                          farm.perish_rate * center.rate + hub.cost;
                          
            double p = q * (min(farm.quantity, v1.capacity) * center.rate - 
                     cost2 - cost1 - hub.cost) + rem * center.rate - ncost;
    
            if(p > 0 && time1 + time2 <= center.deadline) {
                Result r(id, q*(cost1+cost2+hub.cost)+ncost, p,
                        (time1+time2)*farm.perish_rate*farm.quantity, path, hub.id);
                resv1.push_back(r);
            }
        }
    }
    
    // Similar process for vehicle type 2
       for(const auto& hub : hubs) {
        if(v2.capacity > hub.capacity) continue;
        
        for(const auto& [id, center] : centerMap) {
            if(center.crop != farm.crop) continue;
            
            vector<int> path, path2;
            auto [cost1, time1] = findMinCostAndTime(g, hub.id, farm.id, path, tr, 
                                                   v2.rent, v2.speed, center.rate,
                                                   min(farm.quantity, v2.capacity),
                                                   farm.perish_rate);
                                                   
            auto [cost2, time2] = findMinCostAndTime(g, hub.id, id, path2, tr,
                                                   v2.rent, v2.speed, center.rate,
                                                   min(farm.quantity, v2.capacity),
                                                   farm.perish_rate);
            
            // Process path and calculate costs
            reverse(path.begin(), path.end());
            path.pop_back();
            path.insert(path.end(), path2.begin(), path2.end());
            
            int q = farm.quantity/v2.capacity;
            double rem = farm.quantity - q*v2.capacity;
            double ncost = cost1 + cost2 - (time1 + time2) * 
                          (min(farm.quantity, v2.capacity) - rem) *
                          farm.perish_rate * center.rate + hub.cost;
                          
            double p = q * (min(farm.quantity, v2.capacity) * center.rate - 
                     cost2 - cost1 - hub.cost) + rem * center.rate - ncost;
                     
            if(p > 0 && time1 + time2 <= center.deadline) {
                Result r(id, q*(cost1+cost2+hub.cost)+ncost, p,
                        (time1+time2)*farm.perish_rate*farm.quantity, path,hub.id);
                resv2.push_back(r);
            }
        }
    }
    
    // Sort results
    sort(resv1.begin(), resv1.end(), cmp);
    sort(resv2.begin(), resv2.end(), cmp);
    
     for(int j = 0 ; j<resv2.size(); j++){
        cout <<resv2[j].center<<" "<<resv2[j].total_cost<<" "<<resv2[j].profit<<" "<<resv2[j].spoil<<" ";
        for(int i = 0 ; i< resv2[j].path.size(); i++){
            cout << resv2[j].path[i]<<" ";
        }
        cout <<"\n";
    }
     for(int j = 0 ; j<resv1.size(); j++){
        cout <<resv1[j].center<<" "<<resv1[j].total_cost<<" "<<resv1[j].profit<<" "<<resv1[j].spoil<<" ";
        for(int i = 0 ; i< resv1[j].path.size(); i++){
            cout << resv1[j].path[i]<<" ";
        }
        cout <<"\n";
    }
        if(resv1.size() == 0 && resv2.size() == 0){
               cout <<"Nothing is possible";
        }
        else if(resv1.size() == 0 || resv2.size() == 0){
         if(resv1.size()){
               cout <<"v1 is optimal ";
               cout << resv1[0].center<<" "<<resv1[0].profit<<" "<<resv1[0].spoil<<" "<<resv1[0].hub<<"\n";
               for(int i = 0; i< (int)resv1[0].path.size(); i++){
                cout << resv1[0].path[i]<<" ";
               }
        } 
        else if(resv2.size()){
              cout <<"v2 is optimal ";
               cout << resv2[0].center<<" "<<resv2[0].profit<<" "<<resv2[0].spoil<<" "<<resv2[0].hub<<"\n";
               for(int i = 0;i<(int) resv2[0].path.size(); i++){
                cout << resv2[0].path[i]<<" ";
               }
        }}
        else {
         if(resv1[0].profit < resv2[0].profit){
               cout <<"v2 is optimal ";
               cout << resv2[0].center<<" "<<resv2[0].profit<<" "<<resv2[0].spoil<<" "<<resv2[0].hub<<"\n";
               for(int i = 0; i<(int)resv2[0].path.size(); i++){
                cout << resv2[0].path[i]<<" ";
               }
        }
        else if(resv1[0].profit > resv2[0].profit){
                 cout <<"v1 is optimal ";
               cout << resv1[0].center<<" "<<resv1[0].profit<<" "<<resv1[0].spoil<<" "<<resv1[0].hub<<"\n";
               for(int i = 0; i< (int)resv1[0].path.size(); i++){
                cout << resv1[0].path[i]<<" ";
               }
        }
        else if(resv1[0].spoil < resv2[0].spoil){
                cout <<"v1 is optimal ";
               cout << resv1[0].center<<" "<<resv1[0].profit<<" "<<resv1[0].spoil<<" "<<resv1[0].hub<<"\n";
               for(int i = 0;i< (int)resv1[0].path.size(); i++){
                cout << resv1[0].path[i]<<" ";
               }
        }
        else {
               cout <<"v2 is optimal ";
               cout << resv2[0].center<<" "<<resv2[0].profit<<" "<<resv2[0].spoil<<" "<<resv2[0].hub<<"\n";
               for(int i = 0 ; i< (int)resv2[0].path.size(); i++){
                cout << resv2[0].path[i]<<" ";
               }
        }
        }
    
    
    return 0;
}
