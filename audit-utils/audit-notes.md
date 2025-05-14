# Title: Hawk High

## Protocol About
Welcome to **Hawk High**, enroll, avoid bad reviews, and graduate!!!
You have been contracted to review the upgradeable contracts for the Hawk High School which will be launched very soon.
These contracts utilize the UUPSUpgradeable library from OpenZeppelin.
At the end of the school session (4 weeks), the system is upgraded to a new one.

## Roles:
- `Principal`:
    * hiring/firing teachers
    * start new the school session
    * upgrading the system at the end of the school session
    * expel students who break rules
    * get 5% of the school fees
- `Teachers`:
    * giving reviews to students at the end of each week
    * get 35% of the school fees
- `Student`:
    * pay a school fee when enrolling in Hawk High School
    * get a review each week
    * If they fail to meet the cutoff score at the end of a school session, they will be not graduated to the next level when the `Principal` upgrades the system.


## Audit Scope

```
├── src
│   ├── LevelOne.sol
│   └── LevelTwo.sol
```
## Project Stats

 Checked | Code | Files\
    -    | 40   | [LevelTwo.sol](../src/LevelTwo.sol)\
    -    | 203  | [LevelOne.sol](../src/LevelOne.sol)


## Compatibilities
- Solc versions:
    - 0.8.26
- Chains for production:
    - EVM Compatible
- Tokens:
    - USDC

## Known Issues



--------------------------------------------------------------------

# Lists

## Restrictions:
```
Scope
├── src
│   ├── LevelOne.sol
│   └── LevelTwo.sol
```
- Assumes that USDC has 18 decimals

## Unknows:
+ ERC-1822 
+ EIP-1967
+ USDC

## Not Testeables Invariants:

## Confirmed Invariants
- Wages are to be paid only when the `graduateAndUpgrade()` function is called by the `principal`
- Students can only be reviewed once per week
- `principal` gets 5% of `bursary`

## Not Confirmed Invariants
+ A school session lasts 4 weeks
+ `teachers` share of 35% of `bursary`
+ remaining 60% should reflect in the bursary after upgrade
+ Students must have gotten all reviews before system upgrade.
+ System upgrade should not occur if any student has not gotten 4 reviews (one for each week)
+ Any student who doesn't meet the `cutOffScore` should not be upgraded
+ System upgrade cannot take place unless school's `sessionEnd` has reached


----------------------------------------------------------------------

# Audit Process

###  1. (+) Onboarding
###  2. (+) Research unknows
###  3. (+) Search restrictions
###  4. (+) Automated analisis
###  5. (+) Increase Kwnoledge
###  6. (+) Search the invariants
###  7. (+) Manual analisis
###  8. (+) Invariants confirmation
###  9. (+) Test invatiants
### 10. (-) Answering
### 11. (-) Analisis-Answer loop
### 12. (-) Reporting


----------------------------------------------------------------------

# Auxiliary Notes

- For overrided storage see "./audit-notes.ods"

