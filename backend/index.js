const express = require("express");
const fs = require("fs");

const app = express();
app.use(express.json());

class PriorityQueue {
    constructor() {
        this.heap = [];
    }

    // Helper methods for heap navigation
    parentIndex(index) {
        return Math.floor((index - 1) / 2);
    }

    leftChildIndex(index) {
        return 2 * index + 1;
    }

    rightChildIndex(index) {
        return 2 * index + 2;
    }

    // Swap elements in the heap
    swap(i, j) {
        [this.heap[i], this.heap[j]] = [this.heap[j], this.heap[i]];
    }

    // Add an element to the queue with custom priority logic
    enqueue(value) {
        this.heap.push(value);
        this.bubbleUp();
    }

    // Remove and return the element with the highest priority
    dequeue() {
        if (this.size() === 0) return null;
        if (this.size() === 1) return this.heap.pop();

        const top = this.heap[0];
        this.heap[0] = this.heap.pop();
        this.bubbleDown();
        return top;
    }

    // Restore heap property after adding an element
    bubbleUp() {
        let index = this.heap.length - 1;

        while (
            index > 0 &&
            this.compare(this.heap[index], this.heap[this.parentIndex(index)]) < 0
        ) {
            this.swap(index, this.parentIndex(index));
            index = this.parentIndex(index);
        }
    }

    // Restore heap property after removing the root
    bubbleDown() {
        let index = 0;

        while (this.leftChildIndex(index) < this.heap.length) {
            let smallerChildIndex = this.leftChildIndex(index);

            if (
                this.rightChildIndex(index) < this.heap.length &&
                this.compare(
                    this.heap[this.rightChildIndex(index)],
                    this.heap[smallerChildIndex]
                ) < 0
            ) {
                smallerChildIndex = this.rightChildIndex(index);
            }

            if (this.compare(this.heap[index], this.heap[smallerChildIndex]) <= 0) {
                break;
            }

            this.swap(index, smallerChildIndex);
            index = smallerChildIndex;
        }
    }

    // Comparison logic for priority
    compare(a, b) {
        const [costA, timeA] = a[0];
        const [costB, timeB] = b[0];

        // Primary comparison by cost, secondary by time
        if (costA !== costB) return costA - costB;
        return timeA - timeB;
    }

    // Check the size of the queue
    size() {
        return this.heap.length;
    }

    // Peek at the element with the highest priority
    peek() {
        return this.size() > 0 ? this.heap[0] : null;
    }
}

class Farm {
    constructor(id, crop, perishRate, quantity) {
        this.id = id;
        this.crop = crop;
        this.perishRate = perishRate;
        this.quantity = quantity;
    }
}

class Hub {
    constructor(id, cost, capacity) {
        this.id = id;
        this.cost = cost;
        this.capacity = capacity;
    }
}

class Center {
    constructor(id, crop, demand, rate, deadline) {
        this.id = id;
        this.crop = crop;
        this.demand = demand;
        this.rate = rate;
        this.deadline = deadline;
    }
}

class Vehicle {
    constructor(type, rent, capacity, speed) {
        this.type = type;
        this.rent = rent;
        this.capacity = capacity;
        this.speed = speed;
    }
}

class Result {
    constructor(center, totalCost, profit, spoil, path, hub) {
        this.center = center;
        this.totalCost = totalCost;
        this.profit = profit;
        this.spoil = spoil;
        this.path = path;
        this.hub = hub;
    }
}

function generateNetwork(totalNodes, farmNodes, hubNodes, centerNodes) {
    const g = Array.from({ length: totalNodes + 1 }, () => []);

    // Create connections between farms and hubs
    farmNodes.forEach((farm) => {
        hubNodes.forEach((hub) => {
            const distance = 5 + Math.floor(Math.random() * 46);
            g[farm].push([hub, distance]);
            g[hub].push([farm, distance]);
        });
    });

    // Create connections between hubs
    hubNodes.forEach((hub, i) => {
        for (let j = i + 1; j < hubNodes.length; j++) {
            const distance = 10 + Math.floor(Math.random() * 41);
            g[hub].push([hubNodes[j], distance]);
            g[hubNodes[j]].push([hub, distance]);
        }
    });

    // Create connections between hubs and centers
    hubNodes.forEach((hub) => {
        centerNodes.forEach((center) => {
            const distance = 15 + Math.floor(Math.random() * 36);
            g[hub].push([center, distance]);
            g[center].push([hub, distance]);
        });
    });

    return g;
}

// Helper function to generate traffic data
function generateTraffic(g) {
    const tr = new Map();
    for (let i = 0; i < g.length; i++) {
        g[i].forEach(([j, dist]) => {
            const traffic = Math.random();
            tr.set(`${i}-${j}`, traffic);
            tr.set(`${j}-${i}`, traffic);
        });
    }
    return tr;
}

// Helper function to generate hub data
function generateHubs(hubNodes) {
    return hubNodes.map((id) => {
        const capacity = 100 + Math.floor(Math.random() * 101);
        const cost = 200 + Math.floor(Math.random() * 310);
        return new Hub(id, cost, capacity);
    });
}

// Comparison function for results
function cmp(a, b) {
    if (a.profit === b.profit) {
        return a.spoil < b.spoil;
    }
    return a.profit > b.profit;
}

// Pathfinding function
function findMinCostAndTime(
    g,
    src,
    dest,
    path,
    tr,
    rent,
    speed,
    rate,
    weight,
    perishRate
) {
    const pq = new PriorityQueue();
    const cost = Array(g.length).fill(Infinity);
    const timeTaken = Array(g.length).fill(Infinity);
    const parent = Array(g.length).fill(-1);

    cost[src] = 0;
    timeTaken[src] = 0;
    pq.enqueue([
        [0, 0], src
    ]);
    // console.log(pq.size());
    while (pq.size() > 0) {
        const [
            [d, t], u
        ] = pq.dequeue();
        // console.log(d);
        if (d > cost[u]) continue;

        g[u].forEach(([v, w]) => {
            const traffic = tr.get(`${u}-${v}`);
            if (traffic >= 0.99) {
                return;
            }
            const nw =
                w * rent +
                (w / speed) * (1 / (1 - traffic)) * rate * weight * perishRate;
            if (cost[u] + nw < cost[v]) {
                cost[v] = cost[u] + nw;
                timeTaken[v] = timeTaken[u] + (w / speed) * (1 - traffic);
                parent[v] = u;
                pq.enqueue([
                    [cost[v], timeTaken[v]], v
                ]);
            }
        });
    }

    if (cost[dest] === Infinity) return [Infinity, Infinity];

    let current = dest;
    path.length = 0;
    while (current !== -1) {
        path.push(current);
        current = parent[current];
    }
    path.reverse();
    return [cost[dest], timeTaken[dest]];
}

// API route for processing
app.post("/process", (req, res) => {
    const { vehicles, farms3, centers } = req.body;

    const TOTAL_NODES = 200;
    const NUM_FARMS = 50;
    const NUM_HUBS = 15;
    const NUM_CENTERS = 10;

    const farmNodes = Array.from({ length: NUM_FARMS }, (_, i) => i + 1);
    const hubNodes = Array.from({ length: NUM_HUBS }, (_, i) => 51 + i);
    const centerNodes = Array.from({ length: NUM_CENTERS }, (_, i) => 66 + i);

    const g = generateNetwork(TOTAL_NODES, farmNodes, hubNodes, centerNodes);
    const tr = generateTraffic(g);
    const hubs = generateHubs(hubNodes);

    const vehi = vehicles.map(
        (veh) =>
        new Vehicle(
            veh.type,
            parseFloat(veh.rent),
            parseFloat(veh.capacity),
            parseFloat(veh.speed)
        )
    );
    const v1 = vehi[0];
    const v2 = vehi[1];
    let farm = farms3.map((farms_) => {
        const { id, crop, perish_rate, quantity } = farms_;
        return new Farm(
            parseInt(id),
            crop,
            parseFloat(perish_rate),
            parseFloat(quantity)
        );
    });
    farm = farm[0];
    const centerMap = new Map();
    centers.forEach((cent) => {
        const { id, crop, demand, rate, deadline } = cent;
        centerMap.set(
            id,
            new Center(
                id,
                crop,
                parseFloat(demand),
                parseFloat(rate),
                parseFloat(deadline)
            )
        );
    });

    const resv1 = [];
    const resv2 = [];

    // Process for vehicle type 1
    hubs.forEach((hub) => {
        if (v1.capacity > hub.capacity) return;

        centerMap.forEach((center, id) => {
            if (center.crop !== farm.crop) return;
            const path = [];
            const path2 = [];
            const [cost1, time1] = findMinCostAndTime(
                g,
                hub.id,
                farm.id,
                path,
                tr,
                v1.rent,
                v1.speed,
                center.rate,
                Math.min(farm.quantity, v1.capacity),
                farm.perishRate
            );
            const [cost2, time2] = findMinCostAndTime(
                g,
                hub.id,
                id,
                path2,
                tr,
                v1.rent,
                v1.speed,
                center.rate,
                Math.min(farm.quantity, v1.capacity),
                farm.perishRate
            );
            path.reverse();
            path.pop();
            path.push(...path2);

            const q = Math.floor(farm.quantity / v1.capacity);
            const rem = farm.quantity - q * v1.capacity;
            const ncost =
                cost1 +
                cost2 -
                (time1 + time2) *
                (Math.min(farm.quantity, v1.capacity) - rem) *
                farm.perishRate *
                center.rate +
                hub.cost;

            const p =
                q *
                (Math.min(farm.quantity, v1.capacity) * center.rate -
                    cost2 -
                    cost1 -
                    hub.cost) +
                rem * center.rate -
                ncost;

            if (p > 0 && time1 + time2 <= center.deadline) {
                const result = new Result(
                    id,
                    q * (cost1 + cost2 + hub.cost) + ncost,
                    p,
                    (time1 + time2) * farm.perishRate * farm.quantity,
                    path,
                    hub.id
                );
                resv1.push(result);
            }
        });
    });

    // Similar process for vehicle type 2
    hubs.forEach((hub) => {
        if (v2.capacity > hub.capacity) return;

        centerMap.forEach((center, id) => {
            if (center.crop !== farm.crop) return;
            const path = [];
            const path2 = [];
            const [cost1, time1] = findMinCostAndTime(
                g,
                hub.id,
                farm.id,
                path,
                tr,
                v2.rent,
                v2.speed,
                center.rate,
                Math.min(farm.quantity, v2.capacity),
                farm.perishRate
            );
            const [cost2, time2] = findMinCostAndTime(
                g,
                hub.id,
                id,
                path2,
                tr,
                v2.rent,
                v2.speed,
                center.rate,
                Math.min(farm.quantity, v2.capacity),
                farm.perishRate
            );
            path.reverse();
            path.pop();
            path.push(...path2);

            const q = Math.floor(farm.quantity / v2.capacity);
            const rem = farm.quantity - q * v2.capacity;
            const ncost =
                cost1 +
                cost2 -
                (time1 + time2) *
                (Math.min(farm.quantity, v2.capacity) - rem) *
                farm.perishRate *
                center.rate +
                hub.cost;

            const p =
                q *
                (Math.min(farm.quantity, v2.capacity) * center.rate -
                    cost2 -
                    cost1 -
                    hub.cost) +
                rem * center.rate -
                ncost;

            if (p > 0 && time1 + time2 <= center.deadline) {
                const result = new Result(
                    id,
                    q * (cost1 + cost2 + hub.cost) + ncost,
                    p,
                    (time1 + time2) * farm.perishRate * farm.quantity,
                    path,
                    hub.id
                );
                resv2.push(result);
            }
        });
    });
    resv1.sort((a, b) =>
        b.profit === a.profit ? a.spoil - b.spoil : b.profit - a.profit
    );
    resv2.sort((a, b) =>
        b.profit === a.profit ? a.spoil - b.spoil : b.profit - a.profit
    );
    const optimalResult =
        resv1.length === 0 && resv2.length === 0 ?
        "Nothing is possible" :
        resv1.length === 0 ||
        (resv2.length > 0 && resv2[0].profit >= resv1[0].profit) ?
        { vehicle: "v2", ...resv2[0] } :
        { vehicle: "v1", ...resv1[0] };

    console.log(optimalResult);

    // Prepare output as JSON
    const output = {
        optimalResult: optimalResult,
        vehicle1: resv1.map((result) => ({
            center: result.center,
            totalCost: result.totalCost,
            profit: result.profit,
            spoil: result.spoil,
            path: result.path,
            hub: result.hub,
        })),
        vehicle2: resv2.map((result) => ({
            center: result.center,
            totalCost: result.totalCost,
            profit: result.profit,
            spoil: result.spoil,
            path: result.path,
            hub: result.hub,
        })),
    };

    res.json(output); // Send the result as JSON response
});

// Server setup
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});