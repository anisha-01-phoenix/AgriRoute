# AgriRoute – Optimized Multi-Stage Agricultural Supply Chain Design

## Overview

Agriculture supply chains involve various stages from farm to distribution, often constrained by perishability, transport limitations, and the need for cost minimization. In many cases, inefficiencies in routing, resource allocation, and scheduling lead to higher operational costs and spoilage. The challenge is to design an optimized multi-stage supply chain algorithm that minimizes cost while meeting dynamic requirements such as perishability, limited capacity, and traffic disruptions. The goal is to create a scalable and robust algorithm that optimizes both routing and resource allocation, ensuring efficient delivery with minimal spoilage.

## 1. Novel Optimization Algorithm for Multi-Stage Agricultural Supply Chain 

[Optimisation Algorithm Code Links](https://github.com/anisha-01-phoenix/AgriRoute/blob/bbc9960e6795763076f3b50b58c2a60e5667ec63/Optimization_Algo)

The goal is to determine the optimal transportation route, storage hub, and distribution center while minimizing costs, maximizing profit, and minimizing time. The transportation process must pass through one hub before reaching a distribution center. Below is the structured approach to solve this multi-objective problem.

### Step 1: Select Hub and Farm
- **Objective**: Select a hub and determine the shortest path between that hub and the desired farm.
- **Optimization Criteria**:
  - **Minimize cost**  
  - **Minimize time**  
  - **Maximize profit**
  

#### Result:
- This step optimizes for **minimum cost, minimum time, and maximum profit** between the **hub** and the **farm**.

---

### Step 2: Shortest Path from Hub to Distribution Centers
- **Objective**: Identify the shortest path from the chosen hub to all distribution centers.
- **Optimization Criteria**:
  - **Minimize cost**  
  - **Minimize time**  
  - **Maximize profit**
  
- **Method**:
  1. Use the same hub from Step 1.
  2. Calculate the **shortest path** from the hub to each **distribution center**.

#### Result:
- Optimization is performed based on the same criteria: **cost**, **time**, and **profit**.

---

### Step 3: Traffic Congestion and Delay Considerations
- **Objective**: Account for traffic congestion that causes delays.
- **Impact**:
  - **Delivery time increases**  
  - **Crop perishability rate increases amount of spoiled crop**, reducing **market value**.
  
- **Method**:  
  1. **Calculate travel time** based on vehicle speed and distance.
  2. **Adjust for delays** caused by traffic congestion.
  
#### Result:
- Time delays are factored into the total transportation time.

---

### Step 4: Perishability and Monetary Loss Calculation
- **Objective**: Minimize spoilage and losses due to delays.
- **Method**:  
  1. Calculate **percentage of crop spoilage** based on the **perishability rate**.
  2. Determine the **extra monetary loss** due to spoilage:
     - `Monetary Loss = Spoiled Percentage × Selling Price at Distribution Center`

#### Result:
- **Extra monetary loss** is added to the overall cost to reflect spoilage.

---

### Step 5: Optimization and Final Decision
- **Objective**: Solve the problem of minimizing time, cost, and spoilage loss by transforming it into a **single-factor cost minimization problem**.
- **Approach**:
  1. We solve for the most **optimal path** considering:
     - **Transportation cost** = Distance × Vehicle Rental Cost
     - **Time** (including delays due to traffic)
     - **Spoilage loss**
  
- **Outcome**:  
  - We identify the **optimal transportation route**, **hub**, and **distribution center**.
  - **Final optimization goal**: Minimize overall cost, including transportation, spoilage, and time.

---

### Efficiency
- **Time Complexity Reduction**:  
  By breaking down the problem into two separate shortest path calculations (hub to farm and hub to distribution center), we reduce the time complexity to **O(n²)**, making it computationally efficient.



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
