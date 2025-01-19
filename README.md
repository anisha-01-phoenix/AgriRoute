# AgriRoute – Optimized Multi-Stage Agricultural Supply Chain Design

## Overview

Agriculture supply chains involve various stages from farm to distribution, often constrained by perishability, transport limitations, and the need for cost minimization. In many cases, inefficiencies in routing, resource allocation, and scheduling lead to higher operational costs and spoilage. The challenge is to design an optimized multi-stage supply chain algorithm that minimizes cost while meeting dynamic requirements such as perishability, limited capacity, and traffic disruptions. The goal is to create a scalable and robust algorithm that optimizes both routing and resource allocation, ensuring efficient delivery with minimal spoilage.

## 1. Novel Optimization Algorithm for Multi-Stage Agricultural Supply Chain 

[Optimisation Algorithm Code Links](https://github.com/anisha-01-phoenix/AgriRoute/blob/bbc9960e6795763076f3b50b58c2a60e5667ec63/Optimization_Algo)

The objective is to determine the optimal transportation route, storage hub, and distribution center for farm produce while minimizing costs, maximizing profit, and minimizing time. The transportation process must pass through one hub before reaching a distribution center, with hub selection based on capacity constraints and cost considerations. Two types of vehicles are available, each differing in rental cost, speed, and capacity. Distribution centers have specific demand constraints and delivery deadlines that must be met. Additionally, traffic congestion on routes may cause delays, impacting delivery time and reducing the crop’s market value due to perishability. The perishability rate directly affects the selling price, making timely delivery crucial. The challenge is to identify the best combination of route, hub, and distribution center while optimizing total cost, maximizing profit, and minimizing transportation time.

**Approach** :- First, To reduce time complexity, we first select a hub and determine the shortest path between that hub and the most suitable farm while optimizing for minimum cost, minimum time, and maximum profit. Once this optimal path is identified, we then find the shortest path from the same hub to the all distribution center based on the same optimization criteria. By breaking the problem into two separate shortest path computations—one between the hub and the farm, and the other between the hub and the distribution center—we effectively reduce the overall time complexity to \( n^2 + n^2 = n^2 \), significantly improving computational efficiency. To optimize cost, time, and profit simultaneously, we establish a relationship between time, perishability rate, cost, and profit. While determining the shortest path, we calculate the transportation cost for each edge based on the selected vehicle using the formula: **cost = distance × rent**. Using the distance and vehicle speed, we determine the normal travel time. To account for traffic delays, we compute the additional time required on a given route to reach a specific distribution center. The total time is then used to calculate the percentage of crop spoilage based on the perishability rate. By multiplying this spoiled percentage with the crop's selling price at the distribution center, we determine the **extra monetary loss** due to spoilage. This approach effectively transforms our multi-objective problem of minimizing both time and cost into a **single-factor cost minimization problem**, making it computationally easier to determine the most optimal path.

## 2. Simulation and Dataset Generator  
<img src="https://github.com/user-attachments/assets/138e61a5-f4d5-486c-8579-153f802ae706" width="250" height="500">

## 3. Algorithm Benchmarking and Performance Analysis  
<img src="https://github.com/user-attachments/assets/19415f33-a827-453d-b5e0-769a9348fc49" width="250" height="500">

## 4. Interactive Visualization Dashboard  
<img src="https://github.com/user-attachments/assets/518d7b95-4242-4d04-8a34-6a7f9c57055a" width="250" height="500">  
<img src="https://github.com/user-attachments/assets/6b1b1a42-ee2b-41c2-9dce-2277079a82c7" width="250" height="500">  
<img src="https://github.com/user-attachments/assets/8ff162a8-703d-4bc7-920a-1e09e87f49b4" width="250" height="500">  
<img src="https://github.com/user-attachments/assets/39b79d62-1496-4b5d-b099-0c284f09a720" width="250" height="500">  
<img src="https://github.com/user-attachments/assets/adcbcca6-6ac5-4b13-80a5-a60c8f67f2fd" width="250" height="500">
