# Process dynamic
## Recons:
1. Docs
    - UUPSUpgradeable library from OpenZeppelin
    - At the end of the school session (4 weeks), the system is upgraded to a new one.
    
2. Inherits
    - UUPSUpgradeable
3. Code

-----------------------------------------------------------
# Title: Hawk High

# Audit Scope

```
├── src
│   ├── LevelOne.sol
│   └── LevelTwo.sol
```

# Roles:
- `Principal`:
    * hiring/firing teachers
    * start new the school session
    * upgrading the system at the end of the school session
    * expel students who break rules
    <!-- @? - every what time period (4 weeks?) the wages are deposit to principal and teachers? -->
    * get 5% of the school fees
- `Teachers`:
    * giving reviews to students at the end of each week
    * get 35% of the school fees
- `Student`:
    * pay a school fee when enrolling in Hawk High School
    * get a review each week
    * If they fail to meet the cutoff score at the end of a school session, they will be not graduated to the next level when the `Principal` upgrades the system.

# Invariants:
- A school session lasts 4 weeks
- For the sake of this project, assume USDC has 18 decimals
- Wages are to be paid only when the `graduateAndUpgrade()` function is called by the `principal`
- Payment structure is as follows:
  - `principal` gets 5% of `bursary`
  - `teachers` share of 35% of `bursary`
  - remaining 60% should reflect in the bursary after upgrade
- Students can only be reviewed once per week
- Students must have gotten all reviews before system upgrade. System upgrade should not occur if any student has not gotten 4 reviews (one for each week)
- Any student who doesn't meet the `cutOffScore` should not be upgraded
- System upgrade cannot take place unless school's `sessionEnd` has reached

# Unknow EIP/ERC/Tokens/Protocols
+ ERC-1822 
+ EIP-1967
+ USDC

# Compatibilities
- Solc version:
- Chains:
    - EVM Compatible
- Tokens:
    - USDC

# Known Issues

# Stats

 Checked | Code | Files
    -    | 40   | [](../src/LevelTwo.sol)
    -    | 203  | [](../src/LevelOne.sol)